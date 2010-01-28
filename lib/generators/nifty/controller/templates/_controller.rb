class <%= plural_class_name %>Controller < ApplicationController::Base  
  respond_to :html, :xml, :json
  <%= controller_methods :actions %>
end