class CreateVisibleUsers < ActiveRecord::Migration
  def self.up
    create_table :visible_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :gender
      t.integer :year_in_school
      t.integer :age
      t.string :first_language

      t.timestamps
    end
  end

  def self.down
    drop_table :visible_users
  end
end
