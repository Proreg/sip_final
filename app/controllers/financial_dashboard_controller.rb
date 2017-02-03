class FinancialDashboardController < ApplicationController
  before_action :set_employee
  def index  
    authorize! :show, params[:controller]  
    #@inspections = InsInspection.joins(:ins_inspector).where(:ins_inspectors => {:hr_employee_id => @employee.id})

     session[:inspector] = params[:inspector] if params[:inspector] 
     @inspector = session[:inspector]

     session[:inspection_date_start] = params[:inspection_date_start] if params[:inspection_date_start]
     @inspection_date_start = session[:inspection_date_start]

     session[:inspection_date_end] = params[:inspection_date_end] if params[:inspection_date_end]
     @inspection_date_end = session[:inspection_date_end]
  
    if session[:inspection_date_start] != "" && session[:inspection_date_end] != "" &&
      session[:inspection_date_start] != nil && session[:inspection_date_end] != nil &&
      session[:inspector] != "" && session[:inspector] != nil 

      inspections_query="
      SELECT insp.id, insp.name
      , insp.inspection_date
      , comp.commercial_name
      , city.description city_name
      , (select sum(total_value)
           from ins_inspector_items item
          where ITEM.INS_INSPECTION_ID = insp.id
            and ins_inspector_product_id in (select prod.id
                                               from INS_INSPECTOR_PRODUCTS prod
                                              where ins_spending_type_id   = 1)
         ) honorario
      , (select sum(amount)
           from ins_inspector_items item
          where ITEM.INS_INSPECTION_ID = insp.id
            and ins_inspector_product_id in (select prod.id
           from INS_INSPECTOR_PRODUCTS prod
          where ins_spending_type_id = 2)
        ) QTE_KM
      , (select sum(total_value)
           from ins_inspector_items item
          where ITEM.INS_INSPECTION_ID = insp.id
            and ins_inspector_product_id in (select prod.id
           from INS_INSPECTOR_PRODUCTS prod
          where ins_spending_type_id = 2)
        ) Valor_KM
      , (select sum(total_value)
           from ins_inspector_items item
          where ITEM.INS_INSPECTION_ID = insp.id
            and ins_inspector_product_id in (select prod.id
           from INS_INSPECTOR_PRODUCTS prod
          where ins_spending_type_id not in ('2','1'))
        ) Valor_Outros
      FROM ins_inspections insp
      , ins_insurance_companies comp
      , sys_cities city    WHERE comp.id = insp.ins_insurance_company_id
      AND city.id = insp.sys_city_id
      AND insp.ins_inspector_id =  #{@inspector}
      AND insp.inspection_date BETWEEN '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}' 
                                "

      @inspections = ActiveRecord::Base.connection.exec_query(inspections_query)

      top = "
      select inspector.name, count(*) inspection_amount
           , (select sum(total_value)
                from ins_inspections insp1
                   , ins_inspector_items item
               where insp1.ins_inspector_id = #{@inspector}
                 and insp1.id = ITEM.INS_INSPECTION_ID
                 and INSP1.INSPECTION_DATE between '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}'
                 and INSP1.SITUATION in ('2','3','8')) total_value 
           , (select sum(total_value)           
                from ins_inspections insp1
                   , ins_inspector_items item
               where insp1.ins_inspector_id = #{@inspector}
                 and insp1.id = ITEM.INS_INSPECTION_ID
                 and INSP1.INSPECTION_DATE between '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}'
                 and INSP1.SITUATION in ('2','3','8')
                 and item.ins_inspector_product_id in (select prod.id
                                                         from INS_INSPECTOR_PRODUCTS prod
                                                        where ins_spending_type_id = 1)) total_honorarium
                   , (select sum(amount)
                        from ins_inspections insp1
                           , ins_inspector_items item
                       where insp1.ins_inspector_id = #{@inspector}
                         and insp1.id = ITEM.INS_INSPECTION_ID     
                         and INSP1.INSPECTION_DATE between '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}'
                         and INSP1.SITUATION in ('2','3','8')    
                         and item.ins_inspector_product_id in (select prod.id   
                                                                 from INS_INSPECTOR_PRODUCTS prod            
                                                                where ins_spending_type_id = 2)) km_amount 
                   , (select sum(total_value)
                        from ins_inspections insp1
                           , ins_inspector_items item
                       where insp1.ins_inspector_id = #{@inspector}
                         and insp1.id = ITEM.INS_INSPECTION_ID
                         and INSP1.INSPECTION_DATE between '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}'
                         and INSP1.SITUATION in ('2','3','8')
                         and item.ins_inspector_product_id in (select prod.id
                                                                 from INS_INSPECTOR_PRODUCTS prod    
                                                                where ins_spending_type_id = 2)) km_value
                   , (select sum(total_value)
                        from ins_inspections insp1
                           , ins_inspector_items item
                       where insp1.ins_inspector_id = #{@inspector}
                         and insp1.id = ITEM.INS_INSPECTION_ID
                         and INSP1.INSPECTION_DATE between '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}'
                         and INSP1.SITUATION in ('2','3','8')
                         and item.ins_inspector_product_id in (select prod.id
                                                                 from INS_INSPECTOR_PRODUCTS prod
                                                                where ins_spending_type_id = 1)) total_others
                from ins_inspections insp         
                   , ins_inspectors inspector
               where insp.ins_inspector_id = #{@inspector}
                 and inspector.id = INSP.INS_INSPECTOR_ID
                 and INSP.INSPECTION_DATE between '#{@inspection_date_start.to_date.iso8601}' AND '#{@inspection_date_end.to_date.iso8601}'                 and INSP.SITUATION in ('3','8')      
               group by inspector.name
              "
      
      @top = ActiveRecord::Base.connection.exec_query(top).first
      
    end   
  end
  
  def inspector_items
    @items = InsInspectorItem.where(ins_inspection_id: params[:ins_inspection_id])
    @inspection = InsInspection.find(params[:ins_inspection_id])
    @inspector = @inspection.ins_inspector
  end
  
  def check
    InsInspection.find(params[:ins_inspection_id]).update(financial_check: "t")
    redirect_to action: "index"
  end
  
  def delete_inspector_items
    InsInspectorItem.find(params[:id]).destroy
    redirect_to action: "inspector_items"
  end
  
  def change
    current_items = InsInspectorItem.where(ins_inspection_id: params[:ins_inspection_id])
    items = EditInspectorItems.new
    items.update(current_items, params[:items]) # Send parameters to update the DB
    if params[:new_items]
      flash[:msg_error] = 'Tipo de Despesa já existe para inspeção' if items.create(params[:new_items], params[:ins_inspection_id]) == -1
    end

    redirect_to action: 'inspector_items'
  end

  private

  def set_employee
    @employee = current_sys_user.hr_employee
  end
end
