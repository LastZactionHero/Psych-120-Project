class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.string :response_type
      t.integer :test_period
      t.integer :trial
      t.integer :study_time
      t.string :response
      t.integer :recall_reaction_time
      t.integer :total_reaction_time
      t.boolean :correct
      t.integer :keyword_hit_count
      t.integer :keyword_miss_count
      t.integer :keyword_total_count
      t.string :keyword_hits
      t.string :keyword_misses

      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
