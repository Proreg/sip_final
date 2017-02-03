class InsSubInspectorsController < ApplicationController
  before_action :set_model_instance, :set_foreignkey, except: [:list, :index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the index method. The index method needs a model array

  MODEL_NAME = InsSubInspector #First letter uppercase
  SYMBOL_NAME = :ins_sub_inspector #lowercase and separated by underscore
  
  def list #index all sub_inspectors
    @grid = initialize_grid(MODEL_NAME.where(status: "A"), per_page: 4) #wice grid
    authorize! :show, params[:controller]      
  end
  
  def index #index for a specific inspector
    sub_inspectors = ListSubInspectors.new.perform(params[:inspector_id]) # Get all sub inspectors of a inspector
   
    @grid = initialize_grid(MODEL_NAME.where(id: sub_inspectors), per_page: 4) #wice grid
    authorize! :show, params[:controller]
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
    MODEL_NAME.find(params[:id]).destroy
    redirect_to :action=>'index'
    authorize! :destroy, params[:controller]
  end
  
  def create
    @model_instance= MODEL_NAME.new(valid_params)
    
    a = @model_instance
    if @model_instance.save
      InsInspXSubInspector.create(ins_inspector_id: params[:inspector_id], ins_sub_inspector_id: @model_instance.id)  
      flash[:msg_success] = 'Cadastrado com sucesso'
      redirect_to :action=>'show', :id=>@model_instance
    else
      flash[:msg_error] = a.errors.messages[:description].first
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
    params.require(SYMBOL_NAME).permit(:sys_city_id, :name, :zip_code, :address, :neighborhood,
    :house_number, :complement, :email, :cpf, :rg, :status, :ind_save, :ins_notes, :date_of_birth, :mei)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
  end
  
  def set_foreignkey #set foreign keys variable descriptions
    @city = SysCity.find(@model_instance.sys_city_id)
  end
end
