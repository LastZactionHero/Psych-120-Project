class AddStartedAtToTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :started_at, :datetime
  end

  def self.down
    remove_column :tests, :started_at
  end
end
