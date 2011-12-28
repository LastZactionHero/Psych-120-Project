class RemoveTypeFromTests < ActiveRecord::Migration
  def self.up
    remove_column :tests, :type
  end

  def self.down
  end
end
