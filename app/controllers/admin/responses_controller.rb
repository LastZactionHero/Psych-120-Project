class Admin::ResponsesController < Admin::AdminController
  
  def dump    
    @tests = Test.order( 'week ASC' ).order( 'study_user_id ASC' )  
  end
  
  def clear_all
    Test.all.each do |test|
      test.clear_all
      test.save
    end
           
    redirect_to admin_root_path
  end
  
end