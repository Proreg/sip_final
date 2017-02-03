class GenerateUser
  
  
  def perform(id, type)  
    if type == 'e' # Employee
      user = HrEmployee.find(id).name
    else # inspector
      user = InsInspector.find(id).name
    end
    
    user = (user.split.first + '.' + user.split.last).downcase # Gets first name and last lastname to generate a user
    user = SpecialChars.new.remove(user)
    counter=0
    while SysUser.find_by(username: user) # Checks if username has already been taken and adds a number after it ex: john.doe, john.doe1, john.doe2...
      counter = counter+1
      user = user + counter.to_s
    end
    
    pass = password_generator 
    
    if type == 'e' # Employee
      @user = SysUser.new(hr_employee_id: id, type_person: 'e', active:true, external_access: false,  username: user, password: pass)
    else # inspector
      @user = SysUser.new(ins_inspector_id: id, type_person: 'i', active:true, external_access: false,  username: user, password: pass)
    end
    return @user
  end
   
  # Generates password 6 chars long, 1 uppercase char, 5 integers. ex: D42134, G42142 
  def password_generator
    pw='' # instanciate string
    while pw.length <6
      t = Devise.friendly_token.first(1) # Generates token, 1 char
      if (pw.length==0) && !(t =~ /\d/) # first char && not a number 
        t = t.upcase  
        pw = pw + t
      elsif (pw.length!=0) && (t =~ /\d/) # Not first char || is a number  
        pw = pw + t
      end
    end
    return pw # password
  end
end