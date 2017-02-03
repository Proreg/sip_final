class ReportsController < ApplicationController
  def index
    authorize! :show, params[:controller] 
  end
  
  def inspections_by_insurance_companies
    # Convert date to iso8601, to be accepted by oracle
    query = "select INSP.INS_INSURANCE_COMPANY_ID,
     count(insp.ins_insurance_company_id),
     to_char(sum(total_value),'FM999G999G999D90', 'nls_numeric_characters='',.''') total from ins_inspections insp, 
     ins_inspection_items item where insp.id = item.ins_inspection_id 
     and insp.deliver_date between '#{params[:start_date].to_date.iso8601}' and '#{params[:end_date].to_date.iso8601}'  
     and insp.situation in ('3', '8') group by INSP.INS_INSURANCE_COMPANY_ID order by sum(total_value) desc"
    @companies = ActiveRecord::Base.connection.exec_query(query)
    
    query_totals = "select count(insp.ins_insurance_company_id),
     to_char(sum(total_value),'FM999G999G999D90', 'nls_numeric_characters='',.''') total 
     from ins_inspections insp, 
     ins_inspection_items item where insp.id = item.ins_inspection_id 
     and insp.deliver_date between '#{params[:start_date].to_date.iso8601}' and '#{params[:end_date].to_date.iso8601}'  
     and insp.situation in ('3', '8')"
    @totals = ActiveRecord::Base.connection.exec_query(query_totals)
    
   respond_to do |format|
     format.html
     format.pdf do
       render :pdf => "Relatório de Inspeção por Seguradora",
       :layout => 'pdf.html.erb' # uses views/layouts/pdf.html
     end
    end
  end
end
