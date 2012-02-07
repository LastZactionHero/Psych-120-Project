class TestMeta < ActiveRecord::Base  
  
  # Current week
  def self.week
    TestMeta.first.week
  end

  def self.inc_week
    meta = TestMeta.first
    meta.week += 1
    meta.save    
  end
  
  def self.dec_week
    meta = TestMeta.first
    meta.week -= 1
    meta.save    
  end
    
  
  def self.max_weeks
    # Depreciated:
    #TestMeta.first.study_weeks ? TestMeta.first.study_weeks : 15   
    2 
  end
  
  def self.study_text_passes
    TestMeta.first.study_text_passes
  end
  
  def self.correct_response_passes
    TestMeta.first.correct_response_passes
  end
  
  def self.highlight_missed_keywords
    TestMeta.first.highlight_missed_keywords
  end
  
  def self.registration_mode
    TestMeta.first.registration_mode
  end
  
  def self.test_enabled_on_day( day )
    days_arr = TestMeta.first.test_days.split( "," ).map{ |day| day.strip }
    conversion = { :monday => 0, :tuesday => 1, :wednesday => 2, :thursday => 3, :friday => 4, :saturday => 5, :sunday => 6 }
        
    days_arr[ conversion[day] ] == "true"
  end
  
  def self.test_enabled_today?
    days_arr = TestMeta.first.test_days.split( "," ).map{ |day| day.strip }
    days_arr[Time.now.wday - 1] == "true"
  end
  
end
