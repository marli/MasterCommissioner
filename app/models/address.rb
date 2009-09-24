class Address < ActiveRecord::Base

  def latlong
    "#{lat}, #{long}"
  end

  def full_address
    [street_line_1, street_line_2, city, state, zip].join(', ')
  end

end
