class AddStudyUserToTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :study_user_id , :integer ,:references=>"study_users"
  end

  def self.down
    remove_column :tests, :study_user_id
  end
end
