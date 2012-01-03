class AddStudyWeeksToTestMeta < ActiveRecord::Migration
  def self.up
    add_column :test_meta, :study_weeks, :integer
  end

  def self.down
    remove_column :test_meta, :study_weeks
  end
end
