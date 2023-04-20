require 'httparty'

def get_coordinates_by_zipcode(zipcode)
  url = "https://nominatim.openstreetmap.org/search?q=#{zipcode}&format=json"
  response = HTTParty.get(url)
  if response.empty?
    return nil
  else
    lat = response[0]['lat'].to_f
    lon = response[0]['lon'].to_f
    return [lat, lon]
  end
end

def haversine_distance(lat1, lon1, lat2, lon2)
  earth_radius = 6371 # km
  d_lat = (lat2 - lat1).to_rad
  d_lon = (lon2 - lon1).to_rad
  a = Math.sin(d_lat/2) * Math.sin(d_lat/2) + Math.cos(lat1.to_rad) * Math.cos(lat2.to_rad) * Math.sin(d_lon/2) * Math.sin(d_lon/2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  distance = earth_radius * c
  return distance
end

class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

def find_nearby_zipcodes(zipcodes, target_zipcode)
  target_coordinates = get_coordinates_by_zipcode(target_zipcode)
  if target_coordinates.nil?
    puts "Coordenadas não encontradas para o código postal #{target_zipcode}"
    return 0
  end

  nearby_zipcodes = 0
  zipcodes.each do |zipcode|
    begin
      coordinates = get_coordinates_by_zipcode(zipcode)
      distance = haversine_distance(target_coordinates[0], target_coordinates[1], coordinates[0], coordinates[1])
      if distance <= 5 
        nearby_zipcodes += 1
      end
    rescue NoMethodError
    end
  end

  return nearby_zipcodes
end
