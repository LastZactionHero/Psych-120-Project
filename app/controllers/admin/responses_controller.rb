class Admin::ResponsesController < ApplicationController
  
  def dump    
    @tests = Test.all  
  end
  
  def clear_all
    Response.all.each do |response|
      response.delete      
    end
    redirect_to admin_root_path
  end
  
end