class AddConditionToTests < ActiveRecord::Migration
  def self.up
    add_column :tests, :condition, :string
  end

  def self.down
  end
end
