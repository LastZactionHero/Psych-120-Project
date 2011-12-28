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
end
