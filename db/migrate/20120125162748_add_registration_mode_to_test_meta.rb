class AddRegistrationModeToTestMeta < ActiveRecord::Migration
  def self.up
    add_column :test_meta, :registration_mode, :boolean

    TestMeta.all.each do |testmeta|
      testmeta.registration_mode = false
      testmeta.save
    end
  end

  def self.down
    remove_column :test_meta, :registration_mode
  end
end
