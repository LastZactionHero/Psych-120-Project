class Response < ActiveRecord::Base
  belongs_to :question
  belongs_to :study_user
  belongs_to :test
end
