class Ability
  include CanCan::Ability

  def initialize(user)
     if user.ins_inspector_id # Is an inspector
        inspections_in_dashboard_query = "select insp.id
                                          from ins_inspections insp,
                                          ins_inspection_records rec
                                          where insp.id = rec.ins_inspection_id
                                          and insp.situation in ('0')
                                          and rec.ins_record_type_id in ('3','6','7','13','20') 
                                          and insp.ins_inspector_id = #{user.ins_inspector.id}
                                          and rec.record_seq = ((select max(record_seq)
                                          from ins_inspection_records rec1
                                          where rec.ins_inspection_id = rec1.ins_inspection_id )) "
          
        inspections_in_dashboard = ActiveRecord::Base.connection.exec_query(inspections_in_dashboard_query)
        can :access_inspector_dashboard, InsInspector.find(user.ins_inspector.id) 
        
        inspections_in_dashboard.each do |inspection|
          can :access_inspector_dashboard_inspection, InsInspection.find(inspection["id"])
          
        end
     
      else # Employee
          groups = SysUserXGroup.where(sys_user_id: user).pluck(:sys_group_id) # selects all the groups that a user belongs to
    
          groups.each do |group|
            permissions = SysPermission.where(sys_group_id: group) # gets all permissions related to the group
            permissions.each do |permission|
              can [[
                if permission.show_it == "t"
                  :show
                end
                ],[
                if permission.edit_it== "t"
                  :edit
                end
                   ],[
                if permission.create_it== "t"
                  :create
                end
                ],[
                if permission.destroy_it== "t"
                  :destroy 
                end
                ]
                ],
                SysMenu.find(permission.sys_menu_id).controller  # name of the menu being authorized to symbol


                if SysMenu.find(permission.sys_menu_id).controller == "inspector_dashboard" && permission.show_it== "t"
                  can :access_inspector_dashboard, :all
                  can :access_inspector_dashboard_inspection, :all
                end    
          end  
      end
    end
 #   if SysPermission.find(SysUserXGroup.find(sys_user.id).sys_group.id).show_it # checks if in the groups allows you to...
        
  #  end
        
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
