class InsInspectionRecordsController < ApplicationController
  before_action :set_model_instance,  only: [:update, :edit] #Call the method set_model_instance before every action, but the index method. The index method needs a model array
 
  MODEL_NAME = InsInspectionRecord #First letter uppercase
  SYMBOL_NAME = :ins_inspection_record #lowercase and separated by underscore
  PARAMETERS =  :rec_datetime, :internal_notes, :external_notes, :ind_include, :ins_record_type_id,
   :ins_inspection_id,
   :sys_user_id #Used by the getter, getting the params from specific models
 
  def index
    authorize! :show, params[:controller]
     @grid = initialize_grid(MODEL_NAME.where(ins_inspection_id: params[:ins_inspection_id]).order("record_seq DESC").includes(:sys_user),
      per_page: 4,
     ) 
  end
  
  def edit
    authorize! :edit, params[:controller]
  end
  
  def update
        if @model_instance.update_attributes(valid_params)  
           redirect_to :action => 'edit', :id => @model_instance
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
