class AddStudyPassToTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :study_pass, :integer
  end

  def self.down
    remove_column :tests, :study_pass
  end
end
