class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.string :original
      t.string :synonyms
      t.references :question

      t.timestamps
    end
  end

  def self.down
    drop_table :keywords
  end
end
