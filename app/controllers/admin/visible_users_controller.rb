class Admin::VisibleUsersController < Admin::AdminController
  before_filter :find_user, :only => [ :destroy ]
    
  def index
    
  end
  
  def destroy
    @user.delete
    
    redirect_to admin_visible_users_path
  end
  
  
  private
  
  def find_user
    @user = VisibleUser.find( params[:id] )
  end
  
end