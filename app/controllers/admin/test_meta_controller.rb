class Admin::TestMetaController < ApplicationController
  
  def advance_to_next_week
    TestMeta.inc_week
    redirect_to admin_root_path
  end
  
  def revert_to_last_week
    TestMeta.dec_week
    redirect_to admin_root_path
  end
  
end