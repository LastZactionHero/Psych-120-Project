class AddActiveToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :active, :boolean
    
    Question.all.each do |question| 
      question.active = true
      question.save 
    end
  end

  def self.down
    remove_column :questions, :active
  end
end
