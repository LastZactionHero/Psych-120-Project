class AddSynonymsToKeywords < ActiveRecord::Migration
  def self.up
    add_column :keywords, :synonyms, :text
  end

  def self.down
    remove_column :keywords, :synonyms
  end
end
