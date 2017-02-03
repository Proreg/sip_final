class InspectorDashboardController < ApplicationController
  def index
    
    authorize! :access_inspector_dashboard, InsInspector.find(params[:ins_inspector_id]) 

    # ins_record_type_id 6 or 7 | 6 = Escolha Inspetor | 7 = Problema Agendamento  | 10 - Troca inspetor    
    inbox_query = " select *
                    from ins_inspections insp,
                    ins_inspection_records rec
                    where insp.id = rec.ins_inspection_id
                    and insp.situation in ('0')
                    and rec.ins_record_type_id in ('6', '7', '10') 
                    and insp.ins_inspector_id = #{params[:ins_inspector_id]}
                    and rec.record_seq = ((select max(rec1.record_seq)
                                             from ins_inspection_records rec1
                                            where rec.ins_inspection_id = rec1.ins_inspection_id ))

"
          
    @inbox = ActiveRecord::Base.connection.exec_query(inbox_query)

    # ins_record_type_id 3 or 13 | 6 = Agendamento | 13 = Problema Execução
    in_progress_query = " select *
                        from ins_inspections insp,
                        ins_inspection_records rec
                        where insp.id = rec.ins_inspection_id
                        and insp.situation in ('0')
                        and rec.ins_record_type_id in ('3','13') 
                        and insp.ins_inspector_id = #{params[:ins_inspector_id]}
                        and rec.record_seq = ((select max(rec1.record_seq)
                                                 from ins_inspection_records rec1
                                                where rec.ins_inspection_id = rec1.ins_inspection_id))

"

    @in_progress = ActiveRecord::Base.connection.exec_query(in_progress_query)
    
    # ins_record_type_id 20 | 20 = Inspeção executada
    to_send_query = "select *
                    from ins_inspections insp,
                    ins_inspection_records rec
                    where insp.id = rec.ins_inspection_id
                    and insp.situation in ('0')
                    and rec.ins_record_type_id in ('20') 
                    and insp.ins_inspector_id = #{params[:ins_inspector_id]}
                    and rec.record_seq = ((select max(rec1.record_seq)
                                             from ins_inspection_records rec1
                                            where rec.ins_inspection_id = rec1.ins_inspection_id ))  "
                    
    @to_send = ActiveRecord::Base.connection.exec_query(to_send_query)
    
    spendings_query = "select insp.id, ins_inspection_id, insp.name, insp.inspection_date,  item.INS_INSPECTION_ID, sum(item.total_value), ins_notes
                        from ins_inspections insp, ins_inspector_items item
                        where insp.id = item.ins_inspection_id
                          and  insp.ins_inspector_id = #{params[:ins_inspector_id]}
                        and insp.inspection_date between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'
                        group by item.INS_INSPECTION_ID, insp.name, insp.inspection_date, insp.id, ins_notes"
    @spendings = ActiveRecord::Base.connection.exec_query(spendings_query)
    
    top = "
      select inspector.name, count(*) inspection_amount
           , (select sum(total_value)
                from ins_inspections insp1
                   , ins_inspector_items item
               where insp1.ins_inspector_id = #{params[:ins_inspector_id]}
                 and insp1.id = ITEM.INS_INSPECTION_ID
                 and INSP1.INSPECTION_DATE between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'
                 and INSP1.SITUATION in ('2','3','8')) total_value 
           , (select sum(total_value)           
                from ins_inspections insp1
                   , ins_inspector_items item
               where insp1.ins_inspector_id = #{params[:ins_inspector_id]}
                 and insp1.id = ITEM.INS_INSPECTION_ID
                 and INSP1.INSPECTION_DATE between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'
                 and INSP1.SITUATION in ('2','3','8')
                 and item.ins_inspector_product_id in (select prod.id
                                                         from INS_INSPECTOR_PRODUCTS prod
                                                        where ins_spending_type_id = 1)) total_honorarium
                   , (select sum(amount)
                        from ins_inspections insp1
                           , ins_inspector_items item
                       where insp1.ins_inspector_id = #{params[:ins_inspector_id]}
                         and insp1.id = ITEM.INS_INSPECTION_ID     
                         and INSP1.INSPECTION_DATE between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'
                         and INSP1.SITUATION in ('2','3','8')    
                         and item.ins_inspector_product_id in (select prod.id   
                                                                 from INS_INSPECTOR_PRODUCTS prod            
                                                                where ins_spending_type_id = 2)) km_amount 
                   , (select sum(total_value)
                        from ins_inspections insp1
                           , ins_inspector_items item
                       where insp1.ins_inspector_id = #{params[:ins_inspector_id]}
                         and insp1.id = ITEM.INS_INSPECTION_ID
                         and INSP1.INSPECTION_DATE between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'
                         and INSP1.SITUATION in ('2','3','8')
                         and item.ins_inspector_product_id in (select prod.id
                                                                 from INS_INSPECTOR_PRODUCTS prod    
                                                                where ins_spending_type_id = 2)) km_value
                   , (select sum(total_value)
                        from ins_inspections insp1
                           , ins_inspector_items item
                       where insp1.ins_inspector_id = #{params[:ins_inspector_id]}
                         and insp1.id = ITEM.INS_INSPECTION_ID
                         and INSP1.INSPECTION_DATE between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'
                         and INSP1.SITUATION in ('2','3','8')
                         and item.ins_inspector_product_id in (select prod.id
                                                                 from INS_INSPECTOR_PRODUCTS prod
                                                                where ins_spending_type_id = 1)) total_others
                from ins_inspections insp         
                   , ins_inspectors inspector
               where insp.ins_inspector_id = #{params[:ins_inspector_id]}
                 and inspector.id = INSP.INS_INSPECTOR_ID
                 and INSP.INSPECTION_DATE between '#{Date.today.beginning_of_month.to_date.iso8601}' and '#{Date.today.end_of_month.to_date.iso8601}'                 
                 and INSP.SITUATION in ('3','8')      
               group by inspector.name"
      
      @top = ActiveRecord::Base.connection.exec_query(top).first
      
    
  end
  
  def inspection
    authorize! :access_inspector_dashboard_inspection, InsInspection.find(params[:ins_inspection_id])  
    
    @inspection = InsInspection.find(params[:ins_inspection_id])
    @files = InsInspectionFile.where(ins_inspection_id: params[:ins_inspection_id])
    @external_notes = InsInspectionRecord.where(ins_inspection_id: 150).where.not(external_notes: nil)
    @inspector = @inspection.ins_inspector

    @inspector_items = InsInspectorItem.where(ins_inspection_id: params[:ins_inspection_id])
  end
    
  def scheduling
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    
      flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Agendamento"
     
    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 3, # agendamento
    ins_inspection_id: params[:ins_inspection_id], 
    sys_user_id: current_sys_user.id,
    external_notes: "Inspeção agendada com " + params[:person],
    record_seq: next_record_seq
    ) # saves current sys_user
    
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    
    inspection.update(scheduling_date: params[:inspector_scheduling_date])
    
    record_type = InsRecordType.find(3)
    if record_type.ind_send == "t"
      InspectionRecordMailer.inspector_scheduling(inspection, record_type).deliver_later 
    end
    redirect_to action: "index"
  end
  
  def scheduling_problem
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
  
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Problema Agendamento"  
    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 7, # problema de agendamento
    ins_inspection_id: params[:ins_inspection_id], 
    external_notes: params[:reason], 
    sys_user_id: current_sys_user.id,
    record_seq: next_record_seq) # saves current sys_user
    
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    record_type = InsRecordType.find(7)
    if record_type.ind_send == "t"
      InspectionRecordMailer.inspector_scheduling_problem(inspection, record_type).deliver_later 
    end
    
    redirect_to action: "index"
  end

  def download
    send_file InsInspectionFile.find(params[:ins_inspection_file_id]).inspection_path.gsub('\\10.0.0.80\e\E-MAIL', '\inspection_files').gsub('\\10.0.0.80\e\e-mail', '\inspection_files').gsub('\\server2\e\EMAIL', '\inspection_files').gsub("\\\\10.0.0.80\\c\\doc\\rodolfo 010101\\GRASI\\Relatórios", "\\system_reports").tr("\\", "//") 
  end
  
  def run
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1

    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Vistoria Executada"  
    
    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 20, # Vistoria Executada
      ins_inspection_id: params[:ins_inspection_id], 
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq) # saves current sys_user
      
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    record_type = InsRecordType.find(20)
    if record_type.ind_send == "t"
      InspectionRecordMailer.run_inspection(inspection, record_type).deliver_later 
    end
    
    redirect_to action: "index"
  end
  
  def run_problem
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Problema Execução"

    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 13, # Problema Execução
      ins_inspection_id: params[:ins_inspection_id], 
      external_notes: params[:reason], 
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq) # saves current sys_user
      
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    record_type = InsRecordType.find(13)
    if record_type.ind_send == "t"
      InspectionRecordMailer.inspection_run_problem(inspection, record_type).deliver_later 
    end
    
    redirect_to action: "index"
  end
  
  def reject_inspection
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Inspeção Rejeitada"  

    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 19, # Inspeção rejeitada pelo inspetor
      ins_inspection_id: params[:ins_inspection_id], 
      internal_notes: params[:reason], 
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq) 
    
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    
    inspection.update(ins_inspector_id: nil)
    record_type = InsRecordType.find(19)
    if record_type.ind_send == "t"
      InspectionRecordMailer.reject_inspection(inspection, record_type).deliver_later 
    end
    
    redirect_to action: "index"
  end  
  
  def send_report
    if params[:new_items]
      grouped = params[:new_items].group_by{|row| [row["ins_inspector_product"]]}
      
      if grouped.count != params[:new_items].count
        
        flash[:msg_error] = 'Selecionar apenas uma despesa de cada tipo'
        redirect_to action: "index"
        return
      end

      InspectorItems.new.create(params[:new_items], params[:ins_inspection_id]) 
    end
    
    params[:files].each do |file|
      InsInspectionFile.create(inspector_upload: file, ins_inspection_id: params[:ins_inspection_id],
      created_on: Date.today,
      description: file.original_filename)  
    end
    
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Laudo Enviado"

    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 110, # Laudo Enviado
      ins_inspection_id: params[:ins_inspection_id], 
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq) 

    inspection = InsInspection.find(params[:ins_inspection_id ])  
    inspection.update(inspection_date: Date.today, situation: 2)
    
        
    record_type = InsRecordType.find(110)
    if record_type.ind_send == "t"
      InspectionRecordMailer.send_report(inspection, record_type).deliver_later 
    end
    
    redirect_to action: "index"
  end
  
  def inspection_frustated
    params[:files_frustrated].each do |file|
      InsInspectionFile.create(inspector_upload: file, ins_inspection_id: params[:ins_inspection_id],
      description: file.original_filename)  
    end
    
    # use record_seq field to keep track of the last record for inspection
    next_record_seq = InsInspectionRecord.where(ins_inspection_id: params[:ins_inspection_id]).pluck(:record_seq).max + 1
    
    flash[:msg_success] = "#{params[:ins_inspection_id]} - #{InsInspection.find(params[:ins_inspection_id]).name} - Inspeção Frustrada"
    
    InsInspectionRecord.create(rec_datetime: Time.now, ins_record_type_id: 16, # Inspeção Frustrada
      ins_inspection_id: params[:ins_inspection_id], 
      sys_user_id: current_sys_user.id,
      record_seq: next_record_seq) 
      
      # Inspeção Frustrada
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    inspection.update(inspection_date: Date.today, situation: 2)
        
    inspection = InsInspection.find(params[:ins_inspection_id ])  
    record_type = InsRecordType.find(16)
    if record_type.ind_send == "t"
      InspectionRecordMailer.inspection_frustated(inspection, record_type).deliver_later 
    end

    redirect_to action: "index"
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
  
end
