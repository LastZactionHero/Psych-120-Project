class EmailDomainValidator < ActiveModel::Validator
  def validate(record)
    unless record.email.end_with? '@purdue.edu'
      record.errors[:email] << "must be a 'purdue.edu' address"
    end
  end
end

class VisibleUser < ActiveRecord::Base
  validates_with EmailDomainValidator
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :age, :presence => true
  validates :gender, :presence => true
  validates :year_in_school, :presence => true
  validates :first_language, :presence => true
  
  def delete
    study_user = StudyUser.find_user_by_email( self.email )
    study_user.delete if study_user
    
    super
  end
    
  def tests_completed
    study_user = find_study_user
    study_user ? Test.where( :study_user_id => study_user.id, :complete => true ).count : 0 
  end

  def tests_started
    study_user = find_study_user    
    study_user ? Test.where( "study_user_id IS #{study_user.id} AND started_at IS NOT NULL" ).count : 0    
  end
  
  def test_for_week( week )
    study_user = find_study_user
    study_user ? Test.where( :study_user_id => study_user.id, :week => week ).first : nil
  end

  def self.registration_closed?
    VisibleUser.count >= 100
  end  
    
  private
  
  def find_study_user
    email_hash = (Digest::SHA1.hexdigest self.email)
    study_user = StudyUser.where( :email_hash => email_hash ).first
  end
  
end
