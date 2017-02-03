class GenerateMenu 
  def operate(group_id)
    menu_list = SysPermission.where(sys_group_id: group_id, show_it: true)
    SysMenu.where(id: menu_list)      
  end
end