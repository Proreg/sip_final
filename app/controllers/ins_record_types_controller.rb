class InsRecordTypesController < ApplicationController
  before_action :set_model_instance, except: [:index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the index method. The index method needs a model array

  MODEL_NAME = InsRecordType #First letter uppercase
  SYMBOL_NAME = :ins_record_type #lowercase and separated by underscore
  PARAMETERS = :description, :situation, :scheduling, :inspector, :ind_map, :estimated_time, :ind_send,
     :default_email, :employee, :alternative, :sys_group_id, :subject, :email_body_path, :email, :message_without_record,
     :subject_without_record, :ind_delay, :days
  
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
    params[:ins_record_type]["sys_group_id"].shift # remove the first element of the array which is blank
    @model_instance.sys_group_id = params[:ins_record_type]["sys_group_id"].join(";")
    
    a = @model_instance
    if @model_instance.save
      flash[:msg_success] = 'Tipo de despesa cadastrado com sucesso.'
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
         params[:ins_record_type]["sys_group_id"].shift # remove the first element of the array which is blank
         @model_instance.update(sys_group_id: params[:ins_record_type]["sys_group_id"].join(";"))
                   
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

end
