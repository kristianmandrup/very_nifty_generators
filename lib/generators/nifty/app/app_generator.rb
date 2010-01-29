require 'digest/md5'
require 'active_support/secure_random'
require 'rails/version' unless defined?(Rails::VERSION)
require 'generators/nifty'

module Nifty  
  module Generators
    # We need to store the RAILS_DEV_PATH in a constant, otherwise the path
    # can change in Ruby 1.8.7 when we FileUtils.cd.    
    RAILS_DEV_PATH = File.expand_path("../../../../..", File.dirname(__FILE__))    
    class AppGenerator < Base
      add_shebang_option!

      argument :app_path, :type => :string

      class_option :template, :type => :string, :aliases => "-m",
                              :desc => "Path to an application template (can be a filesystem path or URL)."

      class_option :dev, :type => :boolean, :default => false,
                         :desc => "Setup the application with Gemfile pointing to your Rails checkout"

      class_option :edge, :type => :boolean, :default => false,
                          :desc => "Setup the application with Gemfile pointing to Rails repository"

      class_option :skip_git, :type => :boolean, :aliases => "-G", :default => false,
                              :desc => "Skip Git ignores and keeps"

      # Add bin/rails options
      class_option :version, :type => :boolean, :aliases => "-v", :group => :rails,
                             :desc => "Show Rails version number and quit"

      class_option :help, :type => :boolean, :aliases => "-h", :group => :rails,
                          :desc => "Show this help message and quit"

      def self.source_root 
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))  
      end 

      def initialize(*args)
        super
      end

      def create_root
        self.destination_root = File.expand_path(app_path, destination_root)
        valid_app_const?

        empty_directory '.'
        set_default_accessors!
        FileUtils.cd(destination_root)
      end

      def create_root_files
        # puts "Source path: #{self.source_root}"
        copy_file "README"
        copy_file "gitignore", ".gitignore" unless options[:skip_git]
        template "Rakefile"
        template "config.ru"
        template "Gemfile"
      end

      def create_app_files
        directory "app"
      end

      def create_config_files
        empty_directory "config"

        inside "config" do
          template "routes.rb"
          template "application.rb"
          template "environment.rb"

          directory "environments"
          directory "initializers"
          directory "locales"
        end
      end

      def create_boot_file
        template "config/boot.rb"
      end

      def create_db_files
        directory "db"
      end

      def create_doc_files
        directory "doc"
      end

      def create_lib_files
        empty_directory "lib"
        empty_directory_with_gitkeep "lib/tasks"
        empty_directory_with_gitkeep "lib/generators"      
      end

      def create_log_files
        empty_directory "log"

        inside "log" do
          %w( server production development test ).each do |file|
            create_file "#{file}.log"
            chmod "#{file}.log", 0666, :verbose => false
          end
        end
      end

      def create_public_files
        directory "public", "public", :recursive => false # Do small steps, so anyone can overwrite it.
      end

      def create_public_image_files
        directory "public/images"
      end

      def create_public_stylesheets_files
        empty_directory_with_gitkeep "public/stylesheets"
      end

      def create_javascript_files
        directory "public/javascripts"
      end

      def create_script_files
        directory "script" do |content|
          "#{shebang}\n" + content
        end
        chmod "script", 0755, :verbose => false
      end

      def create_test_files
        directory "test"
      end

      def create_tmp_files
        empty_directory "tmp"

        inside "tmp" do
          %w(sessions sockets cache pids).each do |dir|
            empty_directory(dir)
          end
        end
      end

      def create_vendor_files
        empty_directory_with_gitkeep "vendor/plugins"
      end

      def apply_rails_template
        apply rails_template if rails_template
      rescue Thor::Error, LoadError, Errno::ENOENT => e
        raise Error, "The template [#{rails_template}] could not be loaded. Error: #{e}"
      end

      def bundle_if_dev_or_edge
        run "gem bundle" if dev_or_edge?
      end

      protected
        attr_accessor :rails_template

        def set_default_accessors!
          self.rails_template = case options[:template]
            when /^http:\/\//
              options[:template]
            when String
              File.expand_path(options[:template], Dir.pwd)
            else
              options[:template]
          end
        end

        # Define file as an alias to create_file for backwards compatibility.
        def file(*args, &block)
          create_file(*args, &block)
        end

        def app_name
          @app_name ||= File.basename(destination_root)
        end

        def app_const_base
          @app_const_base ||= app_name.gsub(/\W/, '_').squeeze('_').camelize
        end

        def app_const
          @app_const ||= "#{app_const_base}::Application"
        end

        def valid_app_const?
          case app_const
          when /^\d/
            raise Error, "Invalid application name #{app_name}. Please give a name which does not start with numbers."
          end
        end

        def app_secret
          ActiveSupport::SecureRandom.hex(64)
        end

        def dev_or_edge?
          options.dev? || options.edge?
        end

        def self.banner
          "#{$0} #{self.arguments.map(&:usage).join(' ')} [options]"
        end

        def empty_directory_with_gitkeep(destination, config = {})
          empty_directory(destination, config)
          create_file("#{destination}/.gitkeep") unless options[:skip_git]
        end
    end
  end
end
