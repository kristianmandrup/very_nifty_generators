  def create
    respond_with(@<%= singular_name %> = <%= class_name %>.create(params[:<%= singular_name %>]))      
  end

