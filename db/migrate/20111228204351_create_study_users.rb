class CreateStudyUsers < ActiveRecord::Migration
  def self.up
    create_table :study_users do |t|
      t.string :email_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :study_users
  end
end
