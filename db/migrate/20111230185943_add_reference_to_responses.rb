class AddReferenceToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :test_id, :integer ,:references=>"tests"
    add_column :responses, :study_user_id, :integer ,:references=>"study_users"
  end

  def self.down
    remove_column :responses, :test_id
    remove_column :responses, :study_user_id    
  end
end
