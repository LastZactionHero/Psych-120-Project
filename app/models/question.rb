class Question < ActiveRecord::Base
  
  has_many :keywords    

  # Suggest keywords for this question from the study text  
  def suggested_keywords
    self.study_text.strip.downcase.gsub( /[^[:alnum:]]/, " " ).split( ' ' )
  end
  
  # Overrides delete to remove all associated keywords
  def delete
    self.keywords.each do |keyword|
      keyword.delete
    end
    
    super
  end
  
  # Grade a response string for this question by matching to keywords
  # Returns a new Response
  def grade_response( response_str )          
    # Create a new response
    response = Response.new
    response.question = self
    response.response_type = "recall"
    response.response = response_str        
    
    # Split the response text into keywords
    response_keywords = response_str.strip.downcase.gsub( /[^[:alnum:]]/, " " ).split( ' ' ).map{ |k| k.strip } 
    
    # Add spelling corrections if necessary
    corrected_keywords = Array.new
    response_keywords.each { |response_keyword| corrected_keywords << Question.check_spelling( response_keyword ) }
    response_keywords = ( response_keywords + corrected_keywords ).compact!
            
    # Check every response keyword to see if it matches a question keyword or synonym
    found_keywords = Array.new
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
    
    # Fill up the response
    response.keyword_hit_count = found_keywords.length
    response.keyword_miss_count = self.keywords.length - found_keywords.length
    response.keyword_total_count = self.keywords.length
    response.keyword_hits = found_keywords.map{ |k| k.original }.join( ", " )
    response.keyword_misses = self.keywords.map { |k| found_keywords.include?( k ) ? nil : k }.compact.map{ |k| k.original }.join( ", " )
    response.correct = ( found_keywords.length.to_f / self.keywords.length.to_f ) > 0.75 # Success is > 0.75 matching keywords
    response.save
    response    
  end
  
    
  protected
  
  @@spell_checker = nil
  
  # Check Spelling
  def self.check_spelling( word )
    @@spell_checker = SpellingBee.new :source_text => "./public/wordlist.txt" if @@spell_checker == nil  
    corrections = @@spell_checker.correct word    
    ( corrections.length > 0 and corrections[0] != word ) ? corrections[0] : nil    
  end
  
end
