class Test < ActiveRecord::Base
  belongs_to :study_user
  
  
  
  def self.generate_counterbalance_conditions_for_user( user, max_weeks )
    conditions = Array.new
    possible_conditions = [ :study, :study_recall, :none ]
    
    condition_idx = user.id % possible_conditions.size
    (0..max_weeks).each do |week_ids|
      conditions << possible_conditions[condition_idx]
      condition_idx = ( condition_idx + 1 ) % possible_conditions.size
    end
    
    conditions    
  end
  
  def self.condition_symbol_to_int( symbol )
    conversion = { :study => 0, :study_recall => 1, :none => 2 }
    conversion[symbol]
  end
  
end
