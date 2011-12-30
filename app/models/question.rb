class Question < ActiveRecord::Base
  
  has_many :keywords
    
  def suggested_keywords
    self.study_text.strip.downcase.gsub( /[^[:alnum:]]/, " " ).split( ' ' )
  end
  
  def delete
    self.keywords.each do |keyword|
      keyword.delete
    end
    
    super
  end
  
  
  def grade_response( response_str )      
#    t.string :type
#    t.references :StudyUser
#    t.references :Question
#    t.references :Test
#    t.integer :test_period
#    t.integer :trial
    #    t.integer :study_time
#    t.string :response
    #    t.integer :recall_reaction_time
    #    t.integer :total_reaction_time
#    t.boolean :correct
#    t.integer :keyword_hit_count
#    t.integer :keyword_miss_count
#    t.integer :keyword_total_count
#    t.string :keyword_hits
#    t.string :keyword_misses
    
    puts "Grade Response"
    puts "Response String: #{response_str}"
    
    
    response = Response.new
    response.question = self
    response.response_type = "recall"
    response.response = response_str    
    
    return response if response_str.blank?
    
    # Split the response text into keywords
    response_keywords = response_str.strip.downcase.gsub( /[^[:alnum:]]/, " " ).split( ' ' ).map{ |k| k.strip } 
    
    found_keywords = Array.new
    
    # Check every response keyword to see if it matches a question keyword or synonym
    response_keywords.each do |response_keyword|
      
      # Comparing to each question keyword
      self.keywords.each do |question_keyword|
        next if found_keywords.include?( question_keyword )
                               
        if question_keyword.matches_keyword?( response_keyword )
          found_keywords << question_keyword
          break
        end        
      end      
    end
    
    # Success is > 0.75 matching keywords
    response.keyword_hit_count = found_keywords.length
    response.keyword_miss_count = self.keywords.length - found_keywords.length
    response.keyword_total_count = self.keywords.length
    response.keyword_hits = found_keywords.map{ |k| k.original }.join( ", " )
    response.keyword_misses = self.keywords.map { |k| found_keywords.include?( k ) ? nil : k }.compact.map{ |k| k.original }.join( ", " )
    response.correct = ( found_keywords.length.to_f / self.keywords.length.to_f ) > 0.75
    response.save
    response    
  end
  
end
