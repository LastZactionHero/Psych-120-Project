class CareerAccountController < ApplicationController
  
  before_filter CASClient::Frameworks::Rails::Filter
  
  def login
    Rails.logger.warn "CAS Info:"
    Rails.logger.warn session[:cas_user]
  end
  
end