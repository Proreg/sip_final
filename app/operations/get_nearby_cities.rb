class GetNearbyCities
  def initialize(destination_id, state)
    @destination = SysCity.find_by(id: destination_id, sys_state_id: state)
    @cities = Hash.new  
  end
  
  def operate(distance)
    destination = @destination
    cities = @cities

    h = Hash.new{|hsh,key| hsh[key] = {} }
   # h['k1'].store 'a',1
   # h['k1'].store 'b',1
    cities = Hash.new{|hsh,key| hsh[key] = [] }
    
    VwInspSubInspector.all.each do |inspector_sub_inspector| # View with Inspector and SubInspectors
      city = SysCity.find(inspector_sub_inspector.city)
      
      if city.latitude != nil
        if Haversine.distance(destination.latitude,
           destination.longitude,
            city.latitude, 
            city.longitude).to_km < distance
          cities[city.id.to_s].push inspector_sub_inspector.id.to_s + "|"+  inspector_sub_inspector.ind_type
        end
      end
    end  
    
    if cities.empty?
      self.operate(distance*2)
    else
      return cities  
    end
      
  end
end