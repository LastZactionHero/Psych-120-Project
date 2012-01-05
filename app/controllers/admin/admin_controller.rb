class Admin::AdminController < ApplicationController
  before_filter :check_admin_flag, :except => [ :sign_in, :complete_sign_in ]
    
  layout 'admin'    
  
    
  def index
    @active_question_count = Question.where( :active => true ).count
    @inactive_question_count = Question.where( :active => false ).count
  end
  
  def sign_in
    
  end
  
  def complete_sign_in
    username = params[:username]
    password = params[:password]
      
    if username == "psych120" and password == "021hcysp"
      session[:admin_user] = true
      redirect_to admin_root_path
    else
      @error = "Invalid username or password"
      render :sign_in      
    end
  end  
  
  def sign_out
    session[:admin_user] = nil
    redirect_to admin_root_path      
  end
  
  protected
  
  def check_admin_flag
    redirect_to admin_sign_in_path if !session[:admin_user]
  end
  
  
end