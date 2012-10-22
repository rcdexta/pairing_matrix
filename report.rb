require 'rubygems'
require 'builder'

class Reports
  
  def self.draw_lines(value)
    return "&nbsp;" if value == 0
    value.times.inject("") { |count| count += "|" }
  end
  
  def self.generate_html(xm)
    File.open("pairing_matrix.html", 'w') do |f| 
      f.write("<link type='text/css' rel='stylesheet' href='style.css'/>")
      f.write(xm) 
    end
  end
  
  def self.generate_table(author_headers, data)
    
    xm = Builder::XmlMarkup.new(:indent => 2)
    xm.table(border: 2) do
      xm.tr { xm.th(" "); author_headers.each { |key| xm.th(key)}}
      author_headers.each do |row_author| 
        row_data = data[row_author]
        xm.tr do 
          xm.td(row_author)
          author_headers.each do |col_author|
            value = (col_author == row_author ? 0 : row_data[col_author])
            xm.td { xm << draw_lines(value) }
          end
        end
      end
    end
    
    generate_html xm
    
  end
  

  
  
end