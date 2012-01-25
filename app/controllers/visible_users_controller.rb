class VisibleUsersController < ApplicationController
  
  layout 'standard'
  
  def sign_up
    @new_user = VisibleUser.new
        
    redirect_to root_path unless TestMeta.registration_mode
  end
  
  def create
    @new_user = VisibleUser.new( params[:visible_user] )
    @new_user.first_language = "English" unless @new_user.first_language.present?
    
    if @new_user.save
      
      # Create corresponding study user
      study_user = StudyUser.create( { :email_hash => (Digest::SHA1.hexdigest @new_user.email), :age => @new_user.age, :first_language => @new_user.first_language, :year_in_school => @new_user.year_in_school, :gender => @new_user.gender } )     
      redirect_to :sign_up_complete
    else
      render :sign_up
    end
    
  end
  
  def sign_up_complete
  end
  
end