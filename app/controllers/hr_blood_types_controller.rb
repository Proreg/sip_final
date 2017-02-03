class HrBloodTypesController < ApplicationController
  before_action :set_model_instance, except: [:index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the list method. The list method needs a model array

  MODEL_NAME = HrBloodType #First letter uppercase
  SYMBOL_NAME = :hr_blood_type #lowercase and separated by underscore
  
  def index
    @grid = initialize_grid(MODEL_NAME, per_page: 4) #wice grid
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
    authorize! :destroy, params[:controller]
    MODEL_NAME.find(params[:id]).destroy
    redirect_to :action=>'index'  
  end
  
  def create
    @model_instance= MODEL_NAME.new(valid_params)
    
    a = @model_instance
    if @model_instance.save
      flash[:msg_success] = 'Tipo sanguíneo cadastrado com sucesso.'
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
      @model_instance = Sector.find(params[:id])
      if @model_instance.update_attributes(valid_params)  
         redirect_to :action => 'show', :id => @model_instance
      else
         render :action => 'list'
      end    
  end
  
  private #Setters and getters
  
  def valid_params
    params.require(SYMBOL_NAME).permit(:description)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
  end
end
