class StudyUser < ActiveRecord::Base
  validates :email_hash, :presence => true
  validates :email_hash, :uniqueness => true
end
