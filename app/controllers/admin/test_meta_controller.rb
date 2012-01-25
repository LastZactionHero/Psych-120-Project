class Admin::TestMetaController < Admin::AdminController
  
  def advance_to_next_week
    TestMeta.inc_week
    redirect_to admin_root_path
  end
  
  def revert_to_last_week
    TestMeta.dec_week
    redirect_to admin_root_path
  end
  
  def update_passes
    meta = TestMeta.first
    meta.study_text_passes = params[:study_text_passes].to_i
    meta.correct_response_passes = params[:correct_response_passes].to_i
    meta.highlight_missed_keywords = params[:highlight_missed_keywords].present?
    meta.registration_mode = params[:registration_mode].present?
    meta.save
    
    redirect_to admin_root_path
  end
  
#  DEPRECIATED
#
#  def update_week_count
#    study_weeks = params[:study_weeks]
#    if study_weeks and study_weeks.to_i > 0
#      meta = TestMeta.first
#      meta.study_weeks = study_weeks.to_i
#      meta.save
#    end
#     
#    redirect_to admin_root_path
#  end
  
end