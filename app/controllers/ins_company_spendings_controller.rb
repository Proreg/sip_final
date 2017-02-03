class InsCompanySpendingsController < ApplicationController
  before_action :set_model_instance, except: [:index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the index method. The index method needs a model array

  MODEL_NAME = InsCompanySpending #First letter uppercase
  SYMBOL_NAME = :ins_company_spending #lowercase and separated by underscore
  PARAMETERS =  :description, :ins_insurance_company_id, :sys_state_id,:ins_product_id, :deductible
   
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
    @model_instance.spending_value = UnmaskMoney.new(params[:ins_company_spending]["spending_value"]).format
    
    if @model_instance.save
      redirect_to :action=>'show', :id=>@model_instance
    else
      redirect_to :action => 'index'
    end
    
  end
   
  def update
      @model_instance = MODEL_NAME.find(params[:id])
      if @model_instance.update_attributes(valid_params)  
         @model_instance.update(spending_value: UnmaskMoney.new(params[:ins_company_spending]["spending_value"]).format)
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
