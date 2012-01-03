class TestMeta < ActiveRecord::Base  
    
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
    TestMeta.first.study_weeks ? TestMeta.first.study_weeks : 15 
  end
  
end
