class SysUsersController < ApplicationController
  before_action :set_model_instance,  only: [ :edit, :update, :show] #Call the method set_model_instance before every action, but the index method. The index method needs a model array
  
  MODEL_NAME = SysUser #First letter uppercase
  SYMBOL_NAME = :sys_user#lowercase and separated by underscore
    
  def index
    authorize! :show, params[:controller]
    @grid = initialize_grid(SysUser, per_page: 4) #wice grid
  end  
    
  def show
    authorize! :show, params[:controller]
  end

  def new
    authorize! :create, params[:controller]
  end
  
  def create   
    if params[:employee_id] #generate employee user
      @user = GenerateUser.new.perform(params[:employee_id], 'e') 
    else # Inspector user
      @user = GenerateUser.new.perform(params[:inspector_id], 'i')   
    end
    
    if @user.save
      SysUserMailer.login_info(@user, @user.password).deliver_later
      flash[:notice] = 'Login e senha enviados ao e-mail' 
      redirect_to :action => 'show', :id => @user.id
    
    else
      flash[:notice] = 'Erro ao criar e-mail' 
      if params[:employee_id] #generate employee user
        redirect_to :action => 'index', :controller => 'hr_employees'
      else
        redirect_to :action => 'index', :controller => 'ins_inspector'
      end
      
    end
  end
  
  def new_password
    ChangeUserPassword.new(params[:id]).perform
    
    flash[:msg_success] = 'Login e senha enviados ao e-mail' 
    redirect_to :action => 'show'
  end  
  
  def update     
     if @model_instance.update_attributes(valid_params)  
       redirect_to :action => 'show', :id => @model_instance
     else
       render :action => 'index'
     end
  end
  
  def edit    
    authorize! :edit, params[:controller]
  end
  
  def included_groups
    @groups= SysGroup.all
  end
  
  def update_groups
    SetGroups.new.update(params[:group], params[:id]) # Send parameters to update the DB

    redirect_to :action=>'included_groups'
  end
  
  private #Setters and getters
  
  def valid_params
    params.require(SYMBOL_NAME).permit(:active, :external_access)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
  end
  
end
