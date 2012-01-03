class Admin::TestMetaController < ApplicationController
  
  def advance_to_next_week
    TestMeta.inc_week
    redirect_to admin_root_path
  end
  
  def revert_to_last_week
    TestMeta.dec_week
    redirect_to admin_root_path
  end
  
  def update_week_count
    study_weeks = params[:study_weeks]
    if study_weeks and study_weeks.to_i > 0
      meta = TestMeta.first
      meta.study_weeks = study_weeks.to_i
      meta.save
    end
     
    redirect_to admin_root_path
  end
  
end