class InsInspectorPhonesController < ApplicationController
  before_action :set_model_instance,  except: [:index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the index method. The index method needs a model array
  before_action :set_employee, only: [:index, :new, :show, :edit]
  
  
  MODEL_NAME = InsInspectorPhone #First letter uppercase
  SYMBOL_NAME = :ins_inspector_phone #lowercase and separated by underscore
  PARAMETERS = :area_code, :phone_number, :sys_telephone_type_id, :ins_inspector_id  #Used by the getter, getting the params from specific models
 
  def index
    authorize! :show, params[:controller]     
     @grid = initialize_grid(MODEL_NAME.where(ins_inspector_id: params[:inspector_id]), per_page: 4) #wice grid, showing only the relatives of a specific employee
  end
  
  def show  #Variable @model_instance is already being set inside the setter method: set_model_instance
    authorize! :show, params[:controller]
  end
  
  def edit
    authorize! :edit, params[:controller]
  end

  def new  
    authorize! :create, params[:controller]
    @model_instance = MODEL_NAME.new
  end
  
  def destroy
    authorize! :destroy, params[:controller]
    MODEL_NAME.find(params[:id]).destroy
    redirect_to :action=>'index'  
  end
  
  def create
    @model_instance= MODEL_NAME.new(valid_params)
    @model_instance.ins_inspector_id = params[:inspector_id] #SAve relative record with its employee
    a = @model_instance
    if @model_instance.save
      flash[:msg_success] = 'Telefone do inspetor cadastrado com sucesso.'
      if params[:commit] == "Salvar" 
        redirect_to :action=>'index'  
      else
        redirect_to :action => 'new' 
      end
    else
      flash[:msg_error] = a.errors.messages[:description].first
      redirect_to :action=>'index'
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
    params.require(SYMBOL_NAME).permit(PARAMETERS)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
  end
  
  def set_employee #set foreign keys variable descriptions
    @inspector = InsInspector.find(params[:inspector_id]) 
  end
end
