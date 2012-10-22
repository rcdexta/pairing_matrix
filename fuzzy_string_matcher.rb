require 'amatch'

class FuzzyStringMatcher
  
  include Amatch  
    
  def initialize(seed)
    @seed = seed
  end
  
  def match(name)
    name = name.capitalize
    @seed.max_by do |item|
      item.levenshtein_similar name
    end
  end
end