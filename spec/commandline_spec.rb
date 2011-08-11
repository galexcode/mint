require 'spec_helper'

module Mint
  describe CommandLine do
    describe "#options" do
      it "provides default options" do
        CommandLine.options['template']['long'].should == 'template'
        CommandLine.options['layout']['long'].should == 'layout'
        CommandLine.options['style']['long'].should == 'style'
      end
    end

    describe "#parser" do
      it "provides a default option parser" do
        fake_argv = ['--layout', 'pro']

        options = {}
        CommandLine.parser {|k, p| options[k] = p }.parse!(fake_argv)
        options[:layout].should == 'pro'
      end

      it "provides an option parser based on a formatted hash" do
        fake_argv = ['--novel', 'novel']
        formatted_options = {
          # Option keys must be formatted as strings, so we
          # use hash-bang syntax
          novel: {
            'short' => 'n',
            'long' => 'novel',
            'parameter' => true,
            'description' => ''
          }
        }

        options = {}

        CommandLine.parser(formatted_options) do |k, p| 
          options[k] = p
        end.parse!(fake_argv)

        options[:novel].should == 'novel'
      end
    end

    describe "#configuration" do
      context "when no config syntax file is loaded" do
        it "returns nil" do
          CommandLine.configuration(nil).should be_nil
        end
      end

      context "when a config syntax file is loaded but there is no .config file" do
        it "returns a default set of options" do
          expected_map = {
            layout: 'default',
            style: 'default',
            destination: nil,
            style_destination: nil
          }

          CommandLine.configuration.should == expected_map 
        end
      end

      context "when a config syntax file is loaded and there is a .config file" do
        before do
          FileUtils.mkdir_p '.mint/config'
          File.open('.mint/config/config.yaml', 'w') do |file|
            file << 'layout: pro'
          end
        end

        after do
          File.delete '.mint/config/config.yaml'
        end

        it "merges all specified options with precedence according to scope" do
          CommandLine.configuration[:layout].should == 'pro'
        end
      end
    end

    it "displays the sum of all configuration files with other options added"
    it "prints a help message"
    it "installs a template file to the correct scope"
    it "pulls up a named template file in the user's editor"
    it "writes options to the correct file for the scope specified"
    it "sets and stores a scoped configuration variable"
    it "publishes a set of files"
  end
end