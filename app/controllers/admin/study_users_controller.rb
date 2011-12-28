class Admin::StudyUsersController < ApplicationController
  before_filter :find_user, :only => [:destroy]
    
  layout 'admin'
  
  def index
    
  end
  
  def new
    @user = StudyUser.new unless @user.present?
  end
  
  def create
    email_address = params["email_address"]
    success = false
    
    if !email_address.blank?
      @user = StudyUser.create( { :email_hash => (Digest::SHA1.hexdigest email_address) } )
      success = !@user.errors.any?
    end
    
    if success      
      redirect_to admin_study_users_path
    else
      render :new
    end
  end
  
  def destroy
    @user.delete
    redirect_to admin_study_users_path
  end
  
  
  protected
  
  def find_user
    @user = StudyUser.find( params[:id] )
  end
  
end