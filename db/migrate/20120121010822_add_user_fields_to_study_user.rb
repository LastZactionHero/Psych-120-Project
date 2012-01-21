class AddUserFieldsToStudyUser < ActiveRecord::Migration
  def self.up
    add_column :study_users, :gender, :integer
    add_column :study_users, :year_in_school, :integer
    add_column :study_users, :first_language, :string
    add_column :study_users, :age, :integer
  end

  def self.down
    remove_column :study_users, :age
    remove_column :study_users, :first_language
    remove_column :study_users, :year_in_school
    remove_column :study_users, :gender
  end
end
