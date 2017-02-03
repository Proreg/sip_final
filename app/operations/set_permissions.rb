class SetPermissions
  
  def perform(id) # Create the relations for permissions
     menu = SysMenu.all
     menu.each do |a|
       if !SysPermission.find_by(sys_group_id: id, sys_menu_id:a.id) # if there is no relation already, it creates it
         SysPermission.create(sys_group_id: id, sys_menu_id: a.id, show_it: false, edit_it:false, create_it: false, destroy_it: false)
       end
     end
  end
  
  def update(permissions) # Get the hash from the controller, and update the database
    permissions.each do |permission| # get the hash from the checkboxes inside the view
      @edit = SysPermission.find(permission.first) # the first value of the hash has the ID of the current SysPermission
      permission = permission.second # The second has the rest: {show_it -> true, destroy_it-> false,...}
     
      @edit.update(show_it: permission['show_it'], 
        edit_it: permission['edit_it'],
        destroy_it: permission['destroy_it'],
        create_it: permission['create_it'] )
    end
  end
end