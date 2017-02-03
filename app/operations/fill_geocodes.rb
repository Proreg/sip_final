class FillGeocodes
  def operate
    cities = SysCity.where(longitude: nil)
    
    cities.each do |city|
      params = city.description + " " + city.sys_state.description  
      
      geocode = GetGeocode.new(params).operate
        
      if geocode != nil 
        city.update(latitude: geocode['lat'], longitude: geocode['lng'])
      end    
    end
  end
end