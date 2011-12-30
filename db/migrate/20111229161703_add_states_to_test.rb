class AddStatesToTest < ActiveRecord::Migration
  def self.up
    add_column :tests, :unanswered, :string
    add_column :tests, :queue, :string
    add_column :tests, :state, :string
  end

  def self.down
    remove_column :tests, :state
    remove_column :tests, :queue
    remove_column :tests, :unanswered
  end
end
