class SetGroups
  def update(groups, user_id) # Get the hash from the controller, and update the database
    groups.each do |group| # get the hash from the checkboxes inside the view
      if (r = SysUserXGroup.find_by(sys_group_id: group.first, sys_user_id: user_id)) != nil # The permission already exists        
        if group.second['description'] == 'false' # if checked, do nothing. If not checked, remove form DB 
          r.destroy # destroy record on DB 
        end
      else #the permisson doesn't exist
        if group.second['description'] =="true" # if not checked, do nothing. If checked, add record to DB 
          SysUserXGroup.create(sys_user_id: user_id.to_i, sys_group_id: group.first.to_i) # add record to DB DB 
        end
      end  
    end
  end
end