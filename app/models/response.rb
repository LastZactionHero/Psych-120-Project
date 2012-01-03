class Response < ActiveRecord::Base
  belongs_to :question
  belongs_to :study_user
  belongs_to :test
  
  def self.get_correct_response_count_for_question( question, user, test )
    correct_count = Response.where( :question_id => question.id, :study_user_id => user.id, :test_id => test.id, :correct => true ).count
  end
  
end
