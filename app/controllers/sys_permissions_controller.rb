class SysPermissionsController < ApplicationController
  MODEL_NAME = SysPermission #First letter uppercase
  SYMBOL_NAME = :sys_permission #lowercase and separated by underscore
  
  def show  #Variable @model_instance is already being set inside the setter method: set_model_instance
    authorize! :show, params[:controller]
  end
  
  def edit 
    authorize! :edit, params[:controller]
    SetPermissions.new.perform(params[:group_id]) # check if the relations between menus and group are set
    @permissions= SysPermission.where(sys_group_id: params[:group_id])
  end
  
  def change
    SetPermissions.new.update(params[:permission]) # Send parameters to update the DB
        
    redirect_to :action=>'edit'  
  end
  
end
