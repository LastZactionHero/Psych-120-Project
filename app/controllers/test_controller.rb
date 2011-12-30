class TestController < ApplicationController
  before_filter :get_user_or_redirect, :only => [:welcome, :step, :complete_step, :finished]
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
      
  def sign_out
    session[:user] = 0
    redirect_to welcome_test_index_path
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
    
    elsif @test.state and !@test.complete      
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
    @condition = @test.get_condition
    
    # Starting a new test. Initialize everything.
    if @test.state.blank?      
      @test.init_unanswered
      @test.init_queue
      @test.state = "study"
      @test.save      
    end
    
    @state = @test.get_state
    @question = @test.get_next_question_from_queue
  end
  
  
  def complete_step
    @condition = @test.get_condition
    @state = @test.get_state
    
    # If studying, remove question from queue
    if @state == :study
      @test.remove_current_question_from_queue      
    end
    
    # If recalling, grade the answer and remove question from queue
    if @state == :recall
      @question = @test.get_next_question_from_queue
      
      response_str = params[:response]
      correct = @question.grade_response( response_str )
      @test.remove_question_from_unanswered( @question ) if correct
      @test.remove_current_question_from_queue
    end
    
    
    # Finished study test
    if @condition == :study and @state == :study and @test.queue_size == 0
      @test.complete = true
      @test.state = :finished
    end
    
    
    # Finished study portion of study/recall test
    # Reinitialize in recall state
    if @condition == :study_recall and @state == :study and @test.queue_size == 0
      @test.init_queue
      @test.state = :recall
    end
    
    # Finished recall portion of study/recall test and unanswered questions remain
    # Reinitialize in study state
    if @condition == :study_recall and @state == :recall and @test.queue_size == 0 and @test.unanswered_size > 0
      @test.init_queue
      @test.state = :study
    end

    # Finished recall portion of study/recall test and no unanswered questions remain
    # Reinitialize in study state
    if @condition == :study_recall and @state == :recall and @test.queue_size == 0 and @test.unanswered_size == 0
      @test.complete = true
      @test.state = :finished
    end
            
    @test.save
    
    redirect_to step_test_index_path
  end
  
  def finished
    
  end
  
  protected
  
  def get_user_or_redirect    
    begin
      @user = StudyUser.find( session[:user] ) if session[:user].present?      
    rescue
      session[:user] = nil
      @user = nil
      redirect_to root_path
    end
  end

  def get_test
    week = TestMeta.week
    if week >= TestMeta.max_weeks
      redirect_to finished_test_index_path
    else
      @test = Test.where( { :study_user_id => @user, :week => week } ).first
      redirect_to root_path unless @test.present?      
    end
 
  end
  
  
end