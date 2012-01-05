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
      
      @condition = @test.get_condition
      
      if @test.condition == "none" or Question.where( :active => true ).empty?
        # There is no test this week        
        @test.complete = true              
      end
                    
      @test.started_at = DateTime.now
      @test.save
    end
                       
  end
  
  
  def step    
    @condition = @test.get_condition
    
    # Starting a new test. Initialize everything.
    if @test.state.blank?      
      @test.init_unanswered
      @test.init_queue
      @test.trial = 0
      @test.state = @test.get_condition == :exam ? "recall" : "study"
      @test.study_pass = 0
      @test.save      
    end
    
    @state = @test.get_state
    @question = @test.get_next_question_from_queue
    
    @correct_response_count = Response.get_correct_response_count_for_question( @question, @user, @test ) if @state == :recall
    @correct = flash[:correct]
    @correct = true    
  end
  
  
  def complete_step
    @condition = @test.get_condition
    @state = @test.get_state    
        
    # If studying, remove question from queue
    if @state == :study
      @question = @test.get_next_question_from_queue
      @test.remove_current_question_from_queue
      
      response = Response.new
      response.question = @question
      response.study_user = @user
      response.test = @test
      response.trial = @test.trial      
      response.test_period = @test.week
      response.response_type = "study"
      response.study_time = params["study_time"].to_i
      response.save
    end
    
    # If recalling, grade the answer and remove question from queue
    if @state == :recall
      @question = @test.get_next_question_from_queue
      
      response_str = params[:response]
      response = @question.grade_response( response_str )
      response.question = @question
      response.study_user = @user
      response.test = @test
      response.trial = @test.trial
      response.test_period = @test.week
      response.recall_reaction_time = params["recall_reaction_time"].to_i
      response.total_reaction_time = params["total_reaction_time"].to_i
      response.keystroke_count = params["keystroke_count"].to_i
      response.save
      
      correct_responses = Response.get_correct_response_count_for_question( @question, @user, @test )         
      if ( @condition == :exam and correct_responses == 1 ) or ( @condition == :study_recall and correct_responses == TestMeta.correct_response_passes )
        @test.remove_question_from_unanswered( @question )      
      end
      
      flash[:correct] = response.correct
      @test.remove_current_question_from_queue
    end
    
    
    # Finished study test
    if @condition == :study and @state == :study and @test.queue_size == 0

      @test.study_pass = @test.study_pass + 1
      
      if @test.study_pass == TestMeta.study_text_passes
        @test.complete = true
        @test.state = :finished
      else
        @test.init_queue
      end      

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
      @test.trial = @test.trial + 1
      @test.state = :study
    end

    # Finished recall portion of study/recall test and no unanswered questions remain
    # Reinitialize in study state
    if ( @condition == :study_recall or @condition == :exam ) and @state == :recall and @test.queue_size == 0 and @test.unanswered_size == 0
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