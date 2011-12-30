class AddTrialToTest < ActiveRecord::Migration
  def self.up
    add_column :tests, :trial, :integer
  end

  def self.down
    remove_column :tests, :trial
  end
end
