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
  
  protected
  
  def normalize_synonyms
    self.synonyms = self.synonyms.split( "," ).map!{ |suggestion| suggestion.downcase.gsub( /[^[:alnum:]]/, " " ).strip }.join( ", " ) if self.synonyms
  end
  
end
