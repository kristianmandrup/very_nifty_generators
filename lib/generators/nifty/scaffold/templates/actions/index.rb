  def index
    respond_with(@<%= plural_name %> = <%= class_name %>.all)
  end
