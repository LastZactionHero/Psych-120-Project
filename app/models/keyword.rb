require 'fast_stemmer'

class Keyword < ActiveRecord::Base  
  
  belongs_to :question
  before_save :normalize_synonyms
  
  def suggested_synonyms
    query = Metanym.new self.original
    
    suggestions = query.synonyms
    suggestions.map!{ |suggestion| suggestion.strip.downcase.gsub( /[^[:alnum:]]/, "" ) }    
    suggestions.delete( self.original )
    
    suggestions    
  end
  
  def set_synonyms( synonym_str )
    self.synonyms = synonym_str.split( "," ).map!{ |suggestion| suggestion.downcase.gsub( /[^[:alnum:]]/, " " ).strip }.join( ", " )    
  end
  
  def synonyms_arr
    self.synonyms.split( "," ).collect{ |s| s.strip }
  end
  
  def matches_keyword?( compare )
    # Stem the keyword
    compare_stem = Stemmer::stem_word( compare )
    
    # Combine the original and synonym list, stem
    compare_list = self.synonyms_arr
    compare_list << self.original
    compare_list_stems = compare_list.map{ |c| Stemmer::stem_word( c ) }
      
    # See if the stemmed comparison word exists in the list
    compare_list_stems.include?( compare_stem )
  end
  
  protected
  
  def normalize_synonyms
    self.synonyms = self.synonyms.split( "," ).map!{ |suggestion| suggestion.downcase.gsub( /[^[:alnum:]]/, " " ).strip }.join( ", " ) if self.synonyms
  end
  
end
