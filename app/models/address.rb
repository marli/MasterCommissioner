class Address < ActiveRecord::Base

  require 'geokit'

  Maximum_Fayette_Latitude = 38.11
  Minimum_Fayette_Latitude = 37.94
  Maximum_Fayette_Longitude = -84.38 
  Minimum_Fayette_Longitude = -84.65

  before_create :find_lat_long_and_zip

  def latlong
    "#{lat}, #{long}"
  end

  def full_address
    [street_line_1, city, state, zip].join(', ')
  end

  private

  def find_lat_long_and_zip
    address = Geokit::Geocoders::GoogleGeocoder.geocode full_address
    self.lat = address.lat
    self.long = address.lng
    self.zip = address.zip
    if lat_or_long_outside_deviation
      self.success = false
    else
      self.success = true
    end
    logger.debug "VALID? "+self.valid?.to_s
  end

  def lat_or_long_outside_deviation
    if self.lat.to_f > Maximum_Fayette_Latitude || self.lat.to_f < Minimum_Fayette_Latitude
      logger.debug "LAT BAD"
      return true
    elsif self.long.to_f > Maximum_Fayette_Longitude || self.long.to_f < Minimum_Fayette_Longitude
      logger.debug "LONG BAD"
      return true
    else
      logger.debug "NONE BAD"
      return false
    end
  end

end

