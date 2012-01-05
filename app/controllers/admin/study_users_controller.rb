class Admin::StudyUsersController < Admin::AdminController
  before_filter :find_user, :only => [:destroy, :edit, :update, :clear_test]
    
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
  
  def edit
  end
  
  def update      
    params["condition"].keys.each do |week_key|
      test = Test.where( :study_user_id => @user.id, :week => week_key.to_i ).first
      unless ( test.condition == params["condition"][week_key] )
        test.condition = params["condition"][week_key]
        test.save
      end
    end
    
    redirect_to edit_admin_study_user_path( @user )
  end

  def clear_test
    test = Test.find( params[:test] )
      
    Response.where( :test_id => test.id ).each do |response|
      response.delete
    end
    
    test.complete = false
    test.unanswered = nil
    test.queue = nil
    test.state = nil
    test.started_at = nil
    test.trial = nil
    test.study_pass = nil
    test.save
      
    redirect_to edit_admin_study_user_path( @user )
  end
    
  protected
  
  def find_user
    @user = StudyUser.find( params[:id] )
  end
  
end