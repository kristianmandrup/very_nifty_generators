  def edit
    respond_with(@<%= singular_name %> = <%= class_name %>.find(params[:id]))  
  end
