  def update
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
    respond_with(@<%= singular_name %>)
  end
