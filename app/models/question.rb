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
    return false if response_str.blank?
    
    puts "Grade Response"
    puts "Response String: #{response_str}"
    
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
    success = ( found_keywords.length.to_f / self.keywords.length.to_f ) > 0.75    
  end
  
end
