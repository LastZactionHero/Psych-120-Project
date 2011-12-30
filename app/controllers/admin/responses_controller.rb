class Admin::ResponsesController < ApplicationController
  
  def dump    
    @responses = Response.all  
  end
  
  def clear_all
    Response.all.each do |response|
      response.delete      
    end
    redirect_to admin_root_path
  end
  
end