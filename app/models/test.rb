class Test < ActiveRecord::Base
  belongs_to :study_user
  
  # Get all responses, sorted by created date
  def responses
    Response.where( :test_id => self.id ).order( 'created_at ASC' )
  end
  
  # Generate counterbalance conditions for all tests for a user
  # max_weeks: Depreciated, current experiment has only two weeks
  # Week 1: Either study or study/recall
  # Week 2: Exam
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
  
  # Get the test condition
  # None, Study, Study/Recall, Exam
  def get_condition
    conversion = { "none" => :none, "study" => :study, "study_recall" => :study_recall, "exam" => :exam }
    conversion[self.condition]  
  end
  
  # Get the test state
  # Some tests have multiple states, like study/recall.
  # Study, Recall, Finished
  def get_state
    conversion = { "study" => :study, "study_intro" => :study_intro, "recall" => :recall, "recall_intro" => :recall_intro, "finished" => :finished }      
    conversion[self.state]
  end
  
  # Initialized unanswered question list
  # CSV string of all question IDs that have not been answered
  def init_unanswered
    self.unanswered = Question.where( :active => true ).map{ |q| q.id }.join( "," )
  end
  
  # Get unanswered question ids
  def unanswered_arr
    self.unanswered.blank? ? Array.new : self.unanswered.split( "," )
  end
  
  # Initialize question queue
  # Set up a random array of all unanswered questions, CSV string
  def init_queue
    unanswered_arr = self.unanswered_arr
    
    (0..( unanswered_arr.size - 1 ) ).each do |i|
      move_question = unanswered_arr[i]
      unanswered_arr.delete_at( i )            
      unanswered_arr.insert( Random.new.rand( unanswered_arr.length ), move_question )      
    end if unanswered_arr.size > 1    
    
    self.queue = unanswered_arr.join( "," )
  end
  
  # Get next question from the question queue
  def get_next_question_from_queue
    queue_arr = self.queue.split( "," )
    
    question = nil
    if queue_arr.size > 0
      question = Question.find( queue_arr[0] )
    end
  end
  
  # Remove the current question from the question queue
  def remove_current_question_from_queue
    queue_arr = self.queue.split( "," )
    queue_arr.delete_at(0) if queue_arr.size > 0
    self.queue = queue_arr.join( "," )
  end
  
  # Length of the question queue
  def queue_size
    self.queue.blank? ? 0 : self.queue.split( "," ).size
  end
  
  # Length of the list of unanswered questions
  def unanswered_size
    self.unanswered.blank? ? 0 : self.unanswered.split( "," ).size
  end
  
  # Remove a question from the unanswered list
  def remove_question_from_unanswered( question )
    unanswered_arr = self.unanswered_arr
    unanswered_arr.delete( question.id.to_s )
    self.unanswered = unanswered_arr.join( "," )
  end
  
  # Clear All Test Info
  # Reset test to its original unset state, delete responses  
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
