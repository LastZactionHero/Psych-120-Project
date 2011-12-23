class Admin::QuestionsController < ApplicationController
  before_filter :get_question_or_fail, :only => [ :edit, :update, :destroy, :keywords_wizard_select_new ]
    
  layout 'admin'
  
  def index

  end

  def new
    
  end
  
  def edit
    
  end
  
  def create
    question = Question.create( params[:question] )      
    redirect_to keywords_wizard_select_new_admin_question_path( question )
  end
    
  def update
    @question.update_attributes( params[:question] )    
    redirect_to admin_questions_path
  end
  
  def destroy
    @question.delete
    redirect_to admin_questions_path    
  end
  
  def keywords_wizard_select_new
  end
  
  protected
  
  def get_question_or_fail
    @question = Question.find( params[:id] )
  end
  
end