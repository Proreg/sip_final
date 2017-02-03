class DashboardInsInspectorItemsController < ApplicationController
  before_action :set_model_instance, except: [:index, :new, :update, :create, :destroy] #Call the method set_model_instance before every action, but the list method. The list method needs a model array
  before_action :set_models, except: [:index] #Call the method set_model_instance before every action, but the list method. The list method needs a model array

  MODEL_NAME = InsInspectorItem #First letter uppercase
  SYMBOL_NAME = :ins_inspector_item #lowercase and separated by underscore
  PARAMS = :ins_inspector_product_id, :amount, :unitary_value, :total_value
  
  def edit
  end

  def new  
    @model_instance = MODEL_NAME.new
  end
  
  def destroy
    MODEL_NAME.find(params[:id]).destroy
    redirect_to :action=>'index'  
  end
  
  def create
    @model_instance= MODEL_NAME.new(valid_params)
    @model_instance.ins_inspection_id = @inspection.id
    @model_instance.total_value = UnmaskMoney.new(params[:ins_inspector_item]["total_value"]).format
    @model_instance.unitary_value = UnmaskMoney.new(params[:ins_inspector_item]["unitary_value"]).format
    
    a = @model_instance
    if @model_instance.save
      flash[:msg_success] = 'Item adicionado com sucesso.'
      if params[:commit] == "Salvar" 
        redirect_to :action=>'index', :controller=> "inspector_dashboard" 
      else
        redirect_to :action => 'new', :controller=> "inspector_dashboard" 
      end
    else
      flash[:msg_error] = a.errors.messages[:description].first
      redirect_to :action=>'index'
    end 
  end
   
  def update
      @model_instance = MODEL_NAME.find(params[:id])
           
      if @model_instance.update_attributes(valid_params)  
         @model_instance.update(ins_inspection_id: @inspection.id)
         @model_instance.update(total_value: UnmaskMoney.new(params[:ins_inspector_item]["total_value"]).format)
         @model_instance.update(unitary_value: UnmaskMoney.new(params[:ins_inspector_item]["unitary_value"]).format)

         redirect_to :action => 'index', :controller=> "inspector_dashboard" 
      else
         render :action => 'index', :controller=> "inspector_dashboard" 
      end    
  end
  
  private #Setters and getters
  
  def valid_params
    params.require(SYMBOL_NAME).permit(PARAMS)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end
  
  def set_models
    @inspection = InsInspection.find(params[:ins_inspection_id])
    @inspector = @inspection.ins_inspector
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
    
  end
end
