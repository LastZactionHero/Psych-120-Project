class TestController < ApplicationController
  before_filter :get_user_or_redirect, :only => [:welcome, :step, :complete_step]
  before_filter :get_test, :only => [:welcome, :step, :complete_step]
    
  layout 'standard'
  
  # Sign In Page
  def home
    if session[:user].present?
      redirect_to welcome_test_index_path
    end
  end
  
  # Sign In the User by Email
  def sign_in
    @error = nil
    email = params[:login][:email]    
    
    # Make sure an email address was provided
    @error = :no_email if email.blank?

    # Find the user
    user = StudyUser.find_user_by_email( email ) unless @error      
    @error = :user_not_found if user.blank?
    session[:user] = user.id if user.present?      
            
    # Forward the user
    if @error.blank?
      redirect_to welcome_test_index_path
    else
      render :home
    end
  end
      
  # First page after logging in
  def welcome
    week = TestMeta.week
    
    # Get the user's test for this week
    @test = Test.where( { :study_user_id => @user, :week => week } ).first
    
    @welcome_state = nil
        
    if @test.complete
      # User has already completed this week's test
      @welcome_state = :already_finished
    
    elsif false # Check if in the middle of an existing test      
      # User is returning in the middle of an existing test
      @welcome_state = :already_started
      
      
        # Time has no expired
      
        # Time has expired
      
    else    
      # User is starting a new test
      @welcome_state = :new_test
      
      
      if @test.condition == "none"
        # There is no test this week
        @condition = :none
          
      elsif @test.condition == "study"
        # This is a study week
        @condition = :study
        
      else
        # This is a study-recall week
        @condition = :study_recall
        
      end
                    
    end
                       
  end
  
  
  def step
    
  end
  
  def complete_step
    
  end
  
  
  protected
  
  def get_user_or_redirect
    redirect_to root_path unless session[:user].present?
    @user = StudyUser.find( session[:user] ) if session[:user].present?
  end

  def get_test
    week = TestMeta.week
    @test = Test.where( { :study_user_id => @user, :week => week } ).first
    redirect_to root_path unless @test.present? 
  end
  
  
end