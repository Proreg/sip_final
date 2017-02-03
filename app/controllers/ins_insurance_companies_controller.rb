class InsInsuranceCompaniesController < ApplicationController
  before_action :set_model_instance,  except: [:index, :new, :update, :create, :destroy, :inspectors_edit, :inspectors_change] #Call the method set_model_instance before every action, but the index method. The index method needs a model array
   
  MODEL_NAME = InsInsuranceCompany #First letter uppercase
  SYMBOL_NAME = :ins_insurance_company #lowercase and separated by underscore
  PARAMETERS = :corporate_name, :commercial_name, :cnpj, :state_registration, :address,
               :zip_code, :neighborhood, :email, :register_date, :notes, :status, :sys_city_id
  #Used by the getter, getting the params from specific models
 
  def inspectors_edit
    authorize! :edit, params[:controller]
    SetInsuranceCompanies.new.perform(params[:ins_insurance_company_id])
    @inspectors_company = InsInspectorXCompany.where(ins_insurance_company_id: params[:ins_insurance_company_id])
  end
  
  def inspectors_change
    SetInsuranceCompanies.new.update(params[:inspector], params[:ins_insurance_company_id])
        
    redirect_to :action=>'inspectors_edit'  
  end
 
  def index
    authorize! :show, params[:controller]     
     @grid = initialize_grid(MODEL_NAME.all, per_page: 4) #wice grid, showing only the relatives of a specific employee
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
    a = @model_instance
    if @model_instance.save
      flash[:msg_success] = 'Telefone do inspetor cadastrado com sucesso.'
      if params[:commit] == "Salvar" 
        redirect_to :action=>'index'  
      else
        redirect_to :action => 'new' 
      end
    else
      puts a.errors.messages
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
end
