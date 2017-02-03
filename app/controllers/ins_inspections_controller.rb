class InsInspectionsController < ApplicationController
  before_action :set_model_instance,  only: [:show, :edit] #Call the method set_model_instance before every action, but the index method. The index method needs a model array
   
  MODEL_NAME = InsInspection #First letter uppercase
  SYMBOL_NAME = :ins_inspection #lowercase and separated by underscore
  PARAMETERS = :sys_city_id, :name, :request_date, :situation, :notes,  :address,
  :neighborhood, :ins_insurance_company_id,
 :zip_code, :inspection_date, :deliver_date, :key, :area, :recomendation, :scheduling_date,
 :ind_guider, :guider, :claimant, :ind_urgent, :deadline, :orientation_date, :activity, :ins_inspector_id, :risk_local_id  
  #Used by the getter, getting the params from specific models
 
  def index
    authorize! :show, params[:controller]     
     @grid = initialize_grid(MODEL_NAME.all, per_page: 4,order: 'ins_inspections.id', order_direction: 'desc') #wice grid, showing only the relatives of a specific employee
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
  
  def new_file
   @model_instance = MODEL_NAME.new
   
   @fields = InspectionFiles.new.to_hash(params[:import_file], params[:ins_inspection]["ins_insurance_company_id"])  
   
   @fields['import_file'] =  params[:import_file]
   
   ImportFileInspection.new.move_to_temp(params[:import_file]) # After importing, moves the files to the tp folder
     
   if !@fields # Read an invalid type of file
     flash[:msg_error] = "Tipo de arquivo inválido"
     redirect_to action: "new"
   end
  end
  
  def destroy
    authorize! :destroy, params[:controller]
    MODEL_NAME.find(params[:id]).destroy
    redirect_to :action=>'index'  
  end
  
  def delete_coverage
    InsInspectionXCoverage.find(params[:coverage_id]).destroy
    
    redirect_to action: 'edit', id: params[:ins_inspection_id]
  end
  
  def delete_phone
    InsInspectionPhone.find(params[:phone_id]).destroy
      
    redirect_to action: 'edit', id: params[:ins_inspection_id]
  end
  
  def not_temp
    ImportFileInspection.new.move_from_temp(params[:file_name])
  end
  
  def mark_as_received
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Recebida"
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 130, # Inspeção com subscritor
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    redirect_to action:"show", id: params[:ins_inspection_id]
  end  
  
  def first_analysis
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 4, # Subscrição (1a análise)
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Primeira Análise"

    redirect_to action:"show", id: params[:ins_inspection_id]
  end
  
  def final_analysis
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 15, # Subscrição (1a análise)
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Análise Final"
    redirect_to action:"show", id: params[:ins_inspection_id]
  end
 
  def sent
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 131, # Inspeção Enviada
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    # Inspeção Enviada
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    inspection.update(inspection_date: Date.today, situation: 3)
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Enviada"
    redirect_to action:"show", id: params[:ins_inspection_id]
  end
  
  def ending
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 5, # Baixa
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Baixa"
    redirect_to action:"show", id: params[:ins_inspection_id]
  end
  
  def ending_review
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 21, # Conferência baixa
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Convferência Baixa"
    redirect_to action:"show", id: params[:ins_inspection_id]
  end
  
  def e
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 132, # E (financeiro)
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    
      flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - E (Financeiro)"
    redirect_to action:"show", id: params[:ins_inspection_id]
  end
  
  def cancel
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 18, # 18 Inspeção Cancelada
      ins_inspection_id: params[:ins_inspection_id],
      record_seq: next_record_seq
    )
    
  # 18 Inspeção Cancelada
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    inspection.update(inspection_date: Date.today, situation: 9)
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Cancelada"
 
    record_type = InsRecordType.find(18)
    if record_type.ind_send == "t"
      InspectionRecordMailer.cancel(params[:ins_inspection_id], record_type).deliver_later
    end
    
    redirect_to action:"index"
  end
 
  def create
    @model_instance = MODEL_NAME.new(valid_params)
    @model_instance.situation = 0 # For new inspection 
    @model_instance.inspection_value = UnmaskMoney.new(params[:ins_inspection]["inspection_value"]).format
    
    new_inspection = @model_instance
    if @model_instance.save

      SaveFileInspection.new.move_to_created(params[:ins_inspection]['import_file'], new_inspection.id) # After importing, moves the files to the tp folder
=begin
      honorarium = InsCompanyHonorarium.where(ins_product_id: params[:ins_product], 
       ins_insurance_company_id: params[:ins_inspection]["ins_insurance_company_id"]).where("initial_value < ?", UnmaskMoney.new(params[:ins_inspection]["inspection_value"]).format).where("final_value > ?", UnmaskMoney.new(params[:ins_inspection]["inspection_value"]).format).first

      if honorarium
        InsInspectionItem.create(ins_product_id: params[:ins_product],
        ins_inspection_id: @model_instance.id,
        amount: 1,
        unitary_value: honorarium.honorarium_value, 
        total_value: honorarium.honorarium_value,
        ) #Create the first Item
      else
        InsInspectionItem.create(ins_product_id: params[:ins_product],
        ins_inspection_id: @model_instance.id,
        amount: 1,
        unitary_value: 0, 
        total_value: 0,
        ) #Create the first Item
      end 
=end
       
      InspectionCoverages.new.create(params[:coverages], @model_instance.id) #Get InspectionCoverages and create
      
      InspectionPhones.new.create(params[:phones], @model_instance.id) #Get InspectionCoverages and create
           
      # use record_seq field to keep track of the last record for inspection
      
      InsInspectionRecord.create(rec_datetime: Time.now,
      ind_include: 'e', # who created the record: employee/inspector 
      sys_user_id: current_sys_user.id, 
      ins_record_type_id: 58, # Cadastro Inspeção
      ins_inspection_id: new_inspection.id,
      record_seq: 0
      )
      
      flash[:msg_success] = "Cadastrada inspeção número #{ new_inspection.id} "  
           
      redirect_to :controller => 'ins_inspections', :action=>'index', :ins_inspection_id => @model_instance.id  
    else
      puts a.errors.messages
      flash[:msg_error] = a.errors.messages[:description].first
      redirect_to :action=>'index'
    end
  end
   
  def update

      @model_instance = MODEL_NAME.find(params[:id])
      if @model_instance.update_attributes(valid_params) 
         @model_instance.update(inspection_value: UnmaskMoney.new(params[:ins_inspection]["inspection_value"]).format)
         @coverages = InsInspectionXCoverage.where(ins_inspection_id: params[:id])
         @phones = InsInspectionPhone.where(ins_inspection_id: params[:id])
         
         coverages = InspectionCoverages.new
         coverages.edit(@coverages, params[:coverages]) # Params: current coverages, coverages from view and inspection id 
         if params[:new_coverages]
           coverages.create(params[:new_coverages], @model_instance.id) #Get InspectionCoverages and create
         end
         
         phones = InspectionPhones.new
         phones.edit(@phones, params[:phones]) # Params: current coverages, coverages from view and inspection id 
         if params[:new_phones]
           phones.create(params[:new_phones], @model_instance.id) #Get InspectionCoverages and create
         end
         
         redirect_to :action => 'show', :id => @model_instance
      else
         render :action => 'index'
      end    
  end
  
  def simplified_inspection
=begin
 It uses wkhtmltopdf
 it's necessary to install 'sudo apt-get install wkhtmltopdf'
 then run 'which wkhtmltopdf'  to find path and add the path  to config/initializers/wicked_types.rb if necessary  
=end
    @inspection = InsInspection.find(params[:ins_inspection_id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "pedido_"+ params[:ins_inspection_id],
        :layout => 'pdf.html.erb' # uses views/layouts/pdf.html
        #:layout => 'pdf', # uses views/layouts/pdf.haml
        #:show_as_html => params[:debug].present? # renders html version if you set debug=true in URL
      end
    end
  end
  
  
  private #Setters and getters
  
  def valid_params
    params.require(SYMBOL_NAME).permit(PARAMETERS)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_model_instance
    @model_instance = MODEL_NAME.find(params[:id]) # Set variable with the value return by the ID call
    @coverages = InsInspectionXCoverage.where(ins_inspection_id: params[:id])
    @phones = InsInspectionPhone.where(ins_inspection_id: params[:id])
  end
end
