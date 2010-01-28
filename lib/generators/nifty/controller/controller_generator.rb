require 'generators/nifty'

module Nifty
  module Generators
    class ControllerGenerator < Base
      no_tasks { attr_accessor :model_name, :controller_actions }

      argument :controller_name, :type => :string, :required => true, :banner => 'ControllerName'
      argument :controller_actions, :type => :array, :default => [], :banner => 'controller_actions'
      # check_class_collision :suffix => "Controller"

      class_option :singleton, :type => :boolean, :desc => "Supply to create a singleton controller"
    
      def initialize(*args, &block)
        super

        @controller_actions = []

        controller_actions.each do |arg|
          @controller_actions << arg
          @controller_actions << 'create' if arg == 'new'
          @controller_actions << 'update' if arg == 'edit'
        end

        @controller_actions.uniq!

        if @controller_actions.empty?
          @controller_actions = all_actions - @controller_actions
        end
      end    
    
      def create_controller
        template '_controller.rb', "app/controllers/#{plural_name}_controller.rb"        
      end

      no_tasks do
        def all_actions
          %w[index show new create edit update destroy]
        end

        def action?(name)
          controller_actions.include? name.to_s
        end

        def actions?(*names)
          names.all? { |name| action? name }
        end        
        
        def singular_name
          controller_name.underscore
        end

        def plural_name
          controller_name.underscore.pluralize
        end

        def class_name
          controller_name.camelize
        end

        def plural_class_name
          controller_name.camelize
        end
        
        def controller_methods(dir_name)
          controller_actions.map do |action|
            read_template("#{dir_name}/#{action}.rb")
          end.join("  \n").strip
        end
        
        def read_template(relative_path)
          ERB.new(File.read(find_in_source_paths(relative_path)), nil, '-').result(binding)
        end
        
      end

      hook_for :template_engine, :test_framework #, :helper
    end  
  end
end