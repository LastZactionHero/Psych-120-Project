class RemoveSynonymsFromKeywords < ActiveRecord::Migration
  def self.up
    remove_column :keywords, :synonyms
  end

  def self.down
    add_column :keywords, :synonyms, :string
  end
end
