class Admin::ResponsesController < Admin::AdminController
  
  # Dump all tests, sorted by week and user
  def dump    
    @tests = Test.order( 'week ASC' ).order( 'study_user_id ASC' )  
  end
  
  # Delete all responses
  # Reset all tests to their original condition  
  def clear_all
    Test.all.each do |test|
      test.clear_all
      test.save
    end
           
    redirect_to admin_root_path
  end
  
end