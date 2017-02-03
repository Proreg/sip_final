class GetGeocode
  def initialize(search)
    @response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBAHIfoJx1NxIDkZIV-6Jp8P9YSE1aOGKwquit&address=cidade%20#{search}&component='location'")
  end
  
  def operate
    response = JSON.parse(@response.body)
    
   
    if response["status"] == "OK"
      geocode = response["results"].first["geometry"]["location"]
    end
    return geocode
  end  
end