class AddPassesFieldsToTestMeta < ActiveRecord::Migration
  def self.up
    add_column :test_meta, :correct_response_passes, :integer
    add_column :test_meta, :study_text_passes, :integer

    meta = TestMeta.first
    meta.correct_response_passes = 3
    meta.study_text_passes = 3
    meta.save
  end

  def self.down
    remove_column :test_meta, :study_text_passes
    remove_column :test_meta, :correct_response_passes
  end
end
