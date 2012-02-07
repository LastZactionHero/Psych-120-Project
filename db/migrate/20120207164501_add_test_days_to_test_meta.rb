class AddTestDaysToTestMeta < ActiveRecord::Migration
  def self.up
    add_column :test_meta, :test_days, :string

    TestMeta.all.each do |test_meta|
      test_meta.test_days = "true, true, true, true, true, true, true"
      test_meta.save
    end
  end

  def self.down
    remove_column :test_meta, :test_days
  end
end
