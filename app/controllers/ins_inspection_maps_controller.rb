class InsInspectionMapsController < ApplicationController
  def choose_inspector
    authorize! :show, params[:controller] 
    inspection = InsInspection.find(params[:ins_inspection_id])
    if inspection.risk_local_id
      city = SysCity.find(inspection.risk_local_id)
      state = city.sys_state.id
    else
      city = inspection.sys_city
      state = inspection.sys_city.sys_state.id
    end
    
    
    @cities_inspectors = GetNearbyCities.new(city.id, state).operate(20)
 
    @origins = ""
    @cities_inspectors.each do |c|
      current = SysCity.find(c.first)
      @origins <<  current.description + "%20" + current.sys_state.description + "%20CENTRO|"
    end
    @destinations = city.description + " " + SysState.find(state).description
    response = HTTParty.get("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{@origins}&destinations=CIDADE%20#{@destinations}%20CENTRO&key=AIzaSyDrVoLs3dEJstD5F0r0wutZoqXeehdGs9g")
    @response = JSON.parse(response.body)

  end
  
  def inspector_chosen
    inspection = InsInspection.find(params[:ins_inspection_id])
    
    current_inspector = inspection.ins_inspector
    
    if params[:inspector] == "custom_inspector"
      inspector_id = params[:inspector_select].split("|").first

      inspection.update(ins_inspector_id: inspector_id)   
      
      km = params[:km].chomp(" km").to_f

      flash[:msg_success] = "Inspeção encaminhada ao inspetor #{ InsInspector.find(inspector_id).name}"
    else  
      inspector = params[:inspector].split("|").first # inspector id

      km = params[:inspector].split("|").second.chomp(" km").to_f # distance

      inspection.update(ins_inspector_id: inspector)
      flash[:msg_success] = "Inspeção encaminhada ao inspetor #{ InsInspector.find(params[:inspector]).name}"
    end

     
    # Km Spending - Despesa KM
    if inspection.sys_city_id != inspection.ins_inspector.sys_city_id

      km_product = InsProduct.find_by(ins_spending_type: 2, # "KM"
        ins_insurance_company_id: inspection.ins_insurance_company.id
      )

      if km_product
        km_spending = InsCompanySpending.find_by(ins_product_id: km_product.id,
        ins_insurance_company_id: inspection.ins_insurance_company.id)

        if km_spending
          InsInspectionItem.create(ins_inspection_id: inspection.id, ins_product_id: km_product.id,
          amount: km,
          unitary_value: km_spending.spending_value ,
          total_value: (params[:km].chomp(" km").to_i) * (km_spending.spending_value),
          deductible: km_spending.deductible
          )
          
        else # km spending not found, only km_product
          InsInspectionItem.create(ins_inspection_id: inspection.id, ins_product_id: km_product.id,
           amount: km,
           unitary_value: 0 ,
           total_value: 0
          )
  
        end
      end

    end

    # end Km Spending - Despesa KM
  

    if current_inspector # if there is an inspector already chosen for the inspection
      ins_inspector_item = InsInspectorItem.find_by(
      ins_inspector_product_id: (InsInspectorProduct.where(ins_spending_type_id: 1).pluck(:id)),
      ins_inspection_id: inspection.id)

      inspector_honorarium = InsInspectorHonorarium.find_by(
      ins_inspector_product_id: ins_inspector_item.ins_inspector_product_id,
       ins_inspector_id: inspection.ins_inspector_id)

      ins_inspector_item.update(unitary_value:inspector_honorarium.honorarium_value, 
      total_value: inspector_honorarium.honorarium_value)


    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    
      flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Troca Inspetor"
    
      InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 10, #troca de inspetor
      ins_inspection_id: params[:ins_inspection_id],
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq)

      record_type = InsRecordType.find(10)
      if record_type.ind_send == "t"
        InspectionRecordMailer.inspector_canceled(inspection, record_type).deliver_later
      end
      
    else # If it's the first inspector chosen
      # Select inspector honorarium
      product = InsProduct.where(ins_spending_type_id: 1).pluck(:id)
        
      product_id = InsInspectionItem.where(ins_product_id: product,
      ins_inspection_id: inspection.id).pluck(:ins_product_id)
      
      inspector_product_id = InsProduct.find_by(id: product_id).try(:ins_inspector_product_id) 
      
      inspector_honorarium = InsInspectorHonorarium.find_by(ins_inspector_id: inspection.ins_inspector_id,
      ins_inspector_product_id: inspector_product_id)
      
      if inspector_honorarium 
        InsInspectorItem.create(ins_inspection_id: inspection.id,
        unitary_value: inspector_honorarium.honorarium_value, 
        amount: 1, 
        total_value: inspector_honorarium.honorarium_value,
        ins_inspector_product_id: inspector_product_id
        ) #Create the first Item
      else
        InsInspectorItem.create(ins_inspection_id: inspection.id,
          unitary_value: 0, 
          amount: 1, 
          total_value: 0,
          ins_inspector_product_id: inspector_product_id
        ) #Create the first Item
      end 
    #  end Select inspector honorarium


    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
      
      flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Escolha Inspetor"
      
      InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 6, #Escolha inspetor
      ins_inspection_id: params[:ins_inspection_id],
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq)

    end
  
    record_type = InsRecordType.find(6)
    if record_type.ind_send == "t"
      InspectionRecordMailer.inspector_chosen(inspection, record_type).deliver_later 
    end
    
    redirect_to :controller=> "ins_inspection_files", :action=> "index"
  end
  
end
