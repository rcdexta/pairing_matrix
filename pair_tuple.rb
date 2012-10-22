class PairTuple
  attr_accessor :date, :authors
  
  def initialize(date, authors)
    @date = date
    @authors = authors
  end
  
  def eql?(other)
    (@date == other.date and @authors == other.authors)
  end
  
  def hash
    [@date, @authors].hash
  end
  
  def to_s
    "#{@date}: #{@authors}"
  end
end