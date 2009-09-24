class Address < ActiveRecord::Base

  require 'geokit'

  before_create :find_lat_long

  def latlong
    "#{lat}, #{long}"
  end

  def full_address
    [street_line_1, city, state, zip].join(', ')
  end

  def find_lat_long
    address = Geokit::Geocoders::GoogleGeocoder.geocode full_address
    self.lat = address.lat
    self.long = address.lng
  end
end
