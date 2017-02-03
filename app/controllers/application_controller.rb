class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  before_action :authenticate_sys_user! # Authenticates SysUser
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :is_active # Checks if SysUser is active
  before_action :belongs_to_group
   before_action :external_access

  def external_access
    if current_sys_user # session has been started
      current = current_sys_user.current_sign_in_ip.split(".")
      current.delete_at(3)
      current = current.join(".")

     if current != "10.0.0" && current_sys_user.external_access != 't'
        sign_out current_sys_user

        flash[:alert] = 'Acesso externo não permitido para este usuário.'
        redirect_to :action => 'new', :controller => 'devise/sessions' # Redirect to sign in page
      end
    end
  end

  
  def current_ability # changes cancan default from user to sys_user
    @current_ability ||= Ability.new(current_sys_user)
  end
  
  rescue_from CanCan::AccessDenied do |exception| # when cancan thorws an exeption
    flash[:teste] = exception.message
    if current_sys_user.ins_inspector_id # check if it's an inspector
        redirect_to controller: 'inspector_dashboard', action: 'index', ins_inspector_id: current_sys_user.ins_inspector_id
    else
      redirect_to controller: 'welcome', action: 'main'
    end
  end
  
 
  
  def is_active
    if current_sys_user # session has been started
      if !current_sys_user.active #checks if user is active
        sign_out current_sys_user
        flash[:alert] = 'Usuário inativo'  
        redirect_to :action => 'new', :controller => 'devise/sessions' # Redirect to sign in page
      end  
    end
  end
  
  # checks if user belgons to at least one group
  def belongs_to_group
   if current_sys_user # session has been started 
     if current_sys_user.hr_employee_id #only check groups for employee users, not inspectors
      # checks if employee user belongs to any group
       if !SysUserXGroup.find_by(sys_user_id: (SysUser.find_by(username: current_sys_user.username)))
         sign_out current_sys_user
         flash[:alert] = 'Usuário não pertence a nenhum grupo'  
         redirect_to :action => 'new', :controller => 'devise/sessions' # Redirect to sign in page
       end
     end
    end
  end   
  
  protected

  # Allows user to have a username and log in with it 
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
