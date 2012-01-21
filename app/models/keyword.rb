require 'fast_stemmer'

# Keyword
# Keywords are components of Questions
# Each Keyword reference its parent Question
# Keywords contain their original word and synonyms
# 
# Example:
# Question Study Text: The deltoid muscle is in awesome."
# Keywords: "awesome", synonyms: "cool, fantastic, neat" 
class Keyword < ActiveRecord::Base  
  
  belongs_to :question
  before_save :normalize_synonyms
  
  # Suggest synonyms for keyword
  # This is a blocking call to an API
  def suggested_synonyms
    query = Metanym.new self.original
    
    suggestions = query.synonyms
    suggestions.map!{ |suggestion| suggestion.strip.downcase.gsub( /[^[:alnum:]]/, "" ) }    
    suggestions.delete( self.original )
    
    suggestions    
  end

  # Set synonyms from string  
  def set_synonyms( synonym_str )
    self.synonyms = synonym_str.split( "," ).map!{ |suggestion| suggestion.downcase.gsub( /[^[:alnum:]]/, " " ).strip }.join( ", " )    
  end
  
  # Get synonyms as string array
  def synonyms_arr
    self.synonyms.split( "," ).collect{ |s| s.strip }
  end
  
  # Determine if string matches keyword
  # Checks original word and synonyms
  # All words are stemmed before comparison
  def matches_keyword?( compare )
    # Stem the keyword
    compare_stem = Stemmer::stem_word( compare )
    
    # Combine the original and synonym list, stem
    compare_list = self.synonyms_arr
    compare_list << String.new( self.original )
    compare_list_stems = compare_list.map{ |c| Stemmer::stem_word( c ) }
      
    # See if the stemmed comparison word exists in the list
    compare_list_stems.include?( compare_stem )
  end
  
  protected
  
  # Strip, downcase, string delimit synonym list
  def normalize_synonyms
    self.synonyms = self.synonyms.split( "," ).map!{ |suggestion| suggestion.downcase.gsub( /[^[:alnum:]]/, " " ).strip }.join( ", " ) if self.synonyms
  end
  
end
