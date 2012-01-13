class Test < ActiveRecord::Base
  belongs_to :study_user
  
  def responses
    Response.where( :test_id => self.id,  ).order( 'created_at ASC' )
  end
  
  def self.generate_counterbalance_conditions_for_user( user, max_weeks )
    conditions = Array.new
    
    possible_conditions = [ :study, :study_recall ]
    conditions << possible_conditions[ user.id % 2 ]
    conditions << :exam
    conditions
  end
  
  def self.condition_symbol_to_int( symbol )
    conversion = { :study => 0, :study_recall => 1, :none => 2 }
    conversion[symbol]
  end
  
  def get_condition
    if self.condition == "none"
      condition = :none        
    elsif self.condition == "study"
      condition = :study      
    elsif self.condition == "study_recall"    
      condition = :study_recall
    else
      condition = :exam    
    end
    condition  
  end
  
  def get_state
    if self.state == "study"
      state = :study
    elsif self.state == "recall"
      state = :recall
    else
      state = :finished
    end
    state
  end
  
  def init_unanswered
    self.unanswered = Question.where( :active => true ).map{ |q| q.id }.join( "," )
  end
  
  def unanswered_arr
    self.unanswered.blank? ? Array.new : self.unanswered.split( "," )
  end
  
  def init_queue
    unanswered_arr = self.unanswered_arr
    
    (0..( unanswered_arr.size - 1 ) ).each do |i|
      move_question = unanswered_arr[i]
      unanswered_arr.delete_at( i )            
      unanswered_arr.insert( Random.new.rand( unanswered_arr.length ), move_question )      
    end if unanswered_arr.size > 1    
    
    self.queue = unanswered_arr.join( "," )
  end
  
  def get_next_question_from_queue
    queue_arr = self.queue.split( "," )
    
    question = nil
    if queue_arr.size > 0
      question = Question.find( queue_arr[0] )
    end
  end
  
  def remove_current_question_from_queue
    queue_arr = self.queue.split( "," )
    queue_arr.delete_at(0) if queue_arr.size > 0
    self.queue = queue_arr.join( "," )
  end
  
  def queue_size
    self.queue.blank? ? 0 : self.queue.split( "," ).size
  end
  
  def unanswered_size
    self.unanswered.blank? ? 0 : self.unanswered.split( "," ).size
  end
  
  def remove_question_from_unanswered( question )
    unanswered_arr = self.unanswered_arr
    unanswered_arr.delete( question.id.to_s )
    self.unanswered = unanswered_arr.join( "," )
  end
  
  def clear_all
    Response.where( :test_id => self.id ).each do |response|
      response.delete
    end
    
    self.complete = false
    self.unanswered = nil
    self.queue = nil
    self.state = nil
    self.started_at = nil
    self.trial = nil
    self.study_pass = nil    
  end
  
end
