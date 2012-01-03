class StudyUser < ActiveRecord::Base
  has_many :tests
  
  after_create :init_tests
  
  validates :email_hash, :presence => true
  validates :email_hash, :uniqueness => true
  
  
  def delete
    self.tests.each do |test|
      test.delete
    end
    
    Response.where( :study_user_id => self.id ).each do |response|
      response.delete    
    end
    
    super
  end
  
  def self.find_user_by_email( email )
    email_hash = Digest::SHA1.hexdigest email
    user = StudyUser.where( :email_hash => email_hash ).first  
  end
  
  protected
  
  def init_tests
    conditions = Test.generate_counterbalance_conditions_for_user( self, TestMeta.max_weeks - 1 )
    
    (0..(TestMeta.max_weeks - 1)).each do |week_idx|
      test = Test.create( { :week => week_idx, :complete => false, :condition => conditions[week_idx] } )
      self.tests << test
    end
    
    self.save
  end
  
end
