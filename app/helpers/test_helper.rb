module TestHelper
  
  def highlight_question_keyword_misses( question_text, keyword_misses )
    keyword_misses.each do |keyword|
      question_text.gsub!(  keyword, "<span class='study-text-missing-keyword'>" + keyword + "</span>" )
    end         
    
    raw question_text
  end
  
end
