class GetCityOptions
  def format
    states = [50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77]
    h = Hash.new{|hsh,key| hsh[key] = {} }

    states.each do |state|
      SysCity.where(sys_state_id: state).each do |city|
        (h[state].store(city.description, city.id))
      end
    end
    return @cities_select = h.to_json
  end
end