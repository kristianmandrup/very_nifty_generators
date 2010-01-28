  def new
    respond_with(@<%= singular_name %> = <%= class_name %>.new)
  end
