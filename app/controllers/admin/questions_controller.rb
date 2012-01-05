class Admin::QuestionsController < Admin::AdminController
  before_filter :check_admin_flag
  before_filter :get_question_or_fail, :only => [ 
      :edit, 
      :update, 
      :destroy, 
      :keywords_wizard_select_new, 
      :keywords_wizard_update_new, 
      :keywords_wizard_synonyms_select_new, 
      :keywords_wizard_synonyms_select_update_new, 
      :edit_keyword, 
      :update_keyword, 
      :keywords_create, 
      :destroy_keyword,
      :deactivate ]
  before_filter :get_keyword, :only => [:edit_keyword, :update_keyword, :destroy_keyword]
      
  layout 'admin'
  
  
  #------------------------------------------------------------------------
  # Basic Question Editing
  #------------------------------------------------------------------------
  
  # List all test questions
  def index
    @questions = Question.where( :active => true )
  end

  # Create a new test question
  def new
    
  end
  
  # Edit an existing test question
  def edit
    
  end
  
  # Create a new test question
  # Forward to Keyword Selection Wizard
  def create
    question = Question.new( params[:question] )
    question.active = true
    question.save      
    redirect_to keywords_wizard_select_new_admin_question_path( question )
  end
  
  # Update an existing question
  def update
    @question.update_attributes( params[:question] )    
    redirect_to edit_admin_question_path( @question )
  end
  
  # Delete a question
  def destroy
    @question.delete
    redirect_to admin_questions_path    
  end
  
  
  
  #------------------------------------------------------------------------
  # Keyword Selection Wizard
  #------------------------------------------------------------------------
  
  # Pick keywords for a new question
  def keywords_wizard_select_new
  
  end
  
  # Update keywords for a new question
  def keywords_wizard_update_new  
    @question.keywords = Array.new
    
    # Create new keywords
    keywords = params["form-keywords"].strip.downcase.gsub( /[^[:alnum:]]/, " " ).split( ' ' )        
    keywords.each do |keyword_str|
      keyword = Keyword.create( { :original => keyword_str } )
      @question.keywords << keyword
    end
    @question.save    
    
    redirect_to keywords_wizard_synonyms_select_new_admin_question_path( @question ) 
  end
  
  # Pick synonyms for each keyword
  def keywords_wizard_synonyms_select_new    
  end
  
  # Add synonyms to each keyword
  def keywords_wizard_synonyms_select_update_new
    @question.keywords.each do |keyword|
      synonyms = params["synonyms-#{keyword.id}"]      
      keyword.set_synonyms( synonyms )
      keyword.save      
    end
    
    redirect_to admin_questions_path( @question )
  end

  
  #------------------------------------------------------------------------
  # Editing Existing Keywords or Adding New Keywords
  #------------------------------------------------------------------------
  
  # Edit an existing keyword
  def edit_keyword
    
  end  
  
  # Update an existing keyword
  def update_keyword
    synonyms = params["synonyms"]
    @keyword.set_synonyms( synonyms )
    @keyword.save
    redirect_to edit_admin_question_path( @question )
  end

  # New keyword form
  def keywords_new
    
  end
  
  # Create a new keyword
  def keywords_create
    keyword = Keyword.create( params[:keyword] )
    @question.keywords << keyword
    @question.save
    redirect_to edit_admin_question_path( @question )
  end

  # Destroy an existing keyword
  def destroy_keyword
    @question.keywords.delete( @keyword )
    @keyword.delete
    redirect_to edit_admin_question_path( @question )
  end 
  
  #------------------------------------------------------------------------
  # Activiating and Deactivating
  #------------------------------------------------------------------------
  def deactivate_all
    Question.where( :active => true ).each do |question|
      question.active = false
      question.save
    end
    
    redirect_to admin_root_path
  end
    
  def inactive
    @inactive_questions = Question.where( :active => false )
  end
  
  def activate
    questions = params[:questions].keys().map{ |q| Question.find( q.to_i ) }
    questions.each do |question|
      question.active = true
      question.save
    end
    
    redirect_to admin_root_path      
  end  
  
  def deactivate
    @question.active = false
    @question.save
    
    redirect_to admin_questions_path
  end

  def activate_all
    Question.where( :active => false ).each do |question|
      question.active = true
      question.save
    end
    
    redirect_to admin_root_path
  end  
  
  protected
  
  def get_question_or_fail
    @question = Question.find( params[:id] )
  end 
  
  def get_keyword
    @keyword = Keyword.find( params[:keyword] )
  end

  
end