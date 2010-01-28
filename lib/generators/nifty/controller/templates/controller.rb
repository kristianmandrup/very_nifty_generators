class <%= plural_class_name %>Controller < ApplicationController::Base  
  respond_to :html, :xml, :json
  
<% for action in actions -%>
<% unless options[:singleton] && action == 'index '-%>
  def <%= action %>
    <% case action  
      when 'create' then -%>
        respond_with(@<%= singular_name %> = <%= class_name %>.create(params[:<%= singular_name %>]))            
      <% when 'index' then -%>         
        respond_with(@<%= plural_name %> = <%= class_name %>.all)
      <% when 'new' then -%>                 
        respond_with(@<%= singular_name %> = <%= class_name %>.new)        
      <% when 'update' then -%>                         
        @<%= singular_name %> = <%= class_name %>.find(params[:id])
        @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
        respond_with(@<%= singular_name %>)        
    <% else -%>   
      respond_with(@<%= singular_name %> = <%= class_name %>.find(params[:id]))        
    <% end -%>       
  end
<% end -%>
<% end -%>
end