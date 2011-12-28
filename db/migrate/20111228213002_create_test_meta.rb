class CreateTestMeta < ActiveRecord::Migration
  def self.up
    create_table :test_meta do |t|
      t.integer :week

      t.timestamps
    end
  end

  def self.down
    drop_table :test_meta
  end
end
