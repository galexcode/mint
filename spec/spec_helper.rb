require 'pathname'
require 'mint'

def delete_class(klass)
  klass = nil
  GC.start
  sleep 1
end

RSpec::Matchers.define :be_in_directory do |name|
  match {|resource| resource.source_directory =~ /#{name}/ }
end

RSpec::Matchers.define :be_path do |name|
  match {|resource| resource == Pathname.new(name) }
end

RSpec::Matchers.define :be_in_template do |name|
  match {|file| file =~ /#{Mint.root}.*#{name}/ }
end

RSpec::Matchers.define :be_a_template do |name|
  match {|file| Mint.template? file }
end

RSpec.configure do |config|
  config.before(:suite) do
    @old_dir = Dir.getwd
    @tmp_dir = '/tmp/mint-test'

    FileUtils.mkdir_p @tmp_dir
    Dir.chdir @tmp_dir
  end

  config.after(:suite) do
    Dir.chdir @old_dir
    FileUtils.rm_r @tmp_dir
  end

  config.before(:each) do
    @content_file = 'content.md'
    @destination_file = 'content.html'
    @layout_file = 'layout.haml'
    @style_file = 'style.css'

    @static_style_file = 'static.css'
    @dynamic_style_file = 'dynamic.sass'

    @content = <<-HERE
---
metadata: true

Header
------

This is just a test.

Paragraph number two.

Header 2
--------

Third sentence.

Fourth sentence.
    HERE

    @layout = <<-HERE
!!!
%html
  %head
  %body= content
    HERE

    @style = 'body { font-size: 16px }'

    @static_style = <<-HERE
body #container {
  padding: 1em;
}
    HERE

    @dynamic_style = <<HERE
body
  #container
    padding: 1em
HERE

    [:content, :layout, :style, :static_style, :dynamic_style ].each do |v|
      File.open(instance_variable_get(:"@#{v}_file"), 'w') do |f|
        f << instance_variable_get(:"@#{v}")
      end
    end
  end

  config.after(:each) do
    instance = lambda do |name|
      instance_variable_get(:"@#{name}_file")
    end

    [:content, :destination, :layout, :style, :static_style, :dynamic_style].
      map(&instance).
      select {|file| File.file? file }.
      each {|file| File.delete(file) }

    Mint.templates.
      map {|template| Pathname.new(template) + 'css' }.
      select(&:exist?).
      map(&:children).
      flatten.
      each {|cache| File.delete(cache) }
  end
end
