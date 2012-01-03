class AddKeystrokeCountToResponse < ActiveRecord::Migration
  def self.up
    add_column :responses, :keystroke_count, :integer
  end

  def self.down
    remove_column :responses, :keystroke_count
  end
end
