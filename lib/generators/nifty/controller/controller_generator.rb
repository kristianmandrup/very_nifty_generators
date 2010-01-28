module Nifty
  class ControllerGenerator < Rails::Generators::NamedBase
    argument :actions, :type => :array, :default => [], :banner => "action action"
    check_class_collision :suffix => "Controller"

    class_option :singleton, :type => :boolean, :desc => "Supply to create a singleton controller"
    
    def self.source_root
      @source_root ||= File.expand_path('../templates', __FILE__)
    end

    def create_controller_files
      template 'controller.rb', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
    end

    hook_for :template_engine, :test_framework, :helper
  end  
end