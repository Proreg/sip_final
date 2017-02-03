class HrEmployeesController < ApplicationController
  before_action :set_model_instance, except: [:index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the index method. The index method needs a model array

  MODEL_NAME = HrEmployee #First letter uppercase
  SYMBOL_NAME = :hr_employee #lowercase and separated by underscore
  
  def index
    authorize! :show, params[:controller]
    @grid = initialize_grid(MODEL_NAME, per_page: 4) #wice grid
  end
  
  def show  #Variable @model_instance is already being set inside the setter method: set_model_instance
     authorize! :show, params[:controller]
  end
  
  def edit
     authorize! :edit, params[:controller]
  end

  def new  
    @model_instance = MODEL_NAME.new
    authorize! :create, params[:controller]
  end
    
  def destroy
    authorize! :destroy, params[:controller]
    MODEL_NAME.find(params[:id]).destroy
    redirect_to :action=>'index'
  end
  
  def create
    @model_instance= MODEL_NAME.new(valid_params)
    if @model_instance.save
      flash[:msg_success] = "Funcionário(a) #{@model_instance.name} cadastrado com sucesso."
      redirect_to :action=>'show', :id=>@model_instance
    else
      puts @model_instance.errors.messages
      redirect_to :action => 'index'
    end
    
  end
   
  def update
      @model_instance = MODEL_NAME.find(params[:id])

     
      if @model_instance.update_attributes(valid_params)  
         redirect_to :action => 'show', :id => @model_instance
      else
         render :action => 'index'
      end    
  end
  
  private #Setters and getters
  
  def valid_params
    params.require(SYMBOL_NAME).permit(:hr_sector_id, :sys_city_id, :hr_marital_status_id,
  :hr_blood_type_id, :hr_schooling_level_id, :hr_position_id, :hr_insurance_plan_id, :name,
  :cpf, :rg, :pis, :cts, :serie_cts, :date_of_birth, :gender, :smoker,  :sus, :titulo_eleitor,
  :reservista, :email, :obs, :extension_line, :locker_code, :access_code, :email_proreg, :address, 
  :neighborhood, :zip_code, :house_number, :complement, :active)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
  end
end
