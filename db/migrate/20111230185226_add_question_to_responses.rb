class AddQuestionToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :question_id, :integer ,:references=>"questions"
  end

  def self.down
    remove_column :responses, :question_id
  end
end
