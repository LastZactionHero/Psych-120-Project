class CareerAccountController < ApplicationController
  
  before_filter CASClient::Frameworks::Rails::Filter
  
  def login
    @cas_username = session[:cas_user] ? session[:cas_user] : "no user"
  end
  
end