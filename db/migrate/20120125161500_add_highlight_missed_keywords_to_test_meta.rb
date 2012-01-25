class AddHighlightMissedKeywordsToTestMeta < ActiveRecord::Migration
  def self.up
    add_column :test_meta, :highlight_missed_keywords, :boolean

    TestMeta.all.each do |testmeta|
      testmeta.highlight_missed_keywords = true
      testmeta.save
    end
  end

  def self.down
    remove_column :test_meta, :highlight_missed_keywords
  end
end
