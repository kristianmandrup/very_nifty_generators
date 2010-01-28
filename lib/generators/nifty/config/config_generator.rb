require 'generators/nifty'

module Nifty
  module Generators
    class ConfigGenerator < Base
      argument :config_name, :type => :string, :default => 'app'

      def create_files
        initializer("load_#{file_name}_config.rb") do
          <<EOF
path = File.expand_path('../../app_config.yml', __FILE__)
raw_config = File.read(path)
#{constant_name}_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
EOF
        end
        copy_file 'config.yml', "config/#{file_name}_config.yml"
      end

      no_tasks do
        def file_name
          config_name.underscore
        end

        def constant_name
          config_name.underscore.upcase
        end
      end
    end
  end
end
