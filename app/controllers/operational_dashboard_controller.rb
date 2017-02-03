class OperationalDashboardController < ApplicationController
  before_action :set_employee
  def index  
    authorize! :show, params[:controller]  
    #@inspections = InsInspection.joins(:ins_inspector).where(:ins_inspectors => {:hr_employee_id => @employee.id})

    if params[:request_start_date] != "" && params[:request_end_date] != "" && params[:request_start_date] != nil && params[:request_end_date] != nil
      @request_start_date = params[:request_start_date]
      @request_end_date = params[:request_end_date]

      inspections_query="
      SELECT inspection.id AS inspection_id, inspection.scheduling_date AS scheduling_date, inspection.key AS key, city.description AS city, inspector.name AS inspector_name, inspection.name AS inspection_name, inspection.situation, inspection.request_date, record.ins_record_type_id AS record_type
        FROM sys_cities city, ins_inspections inspection, ins_inspectors inspector, hr_employees employee, ins_inspection_records record
       WHERE employee.id = #{@employee.id.to_s}
         AND city.id = inspection.sys_city_id
         AND inspection.ins_inspector_id = inspector.id
         AND inspector.hr_employee_id = employee.id
         AND record.ins_inspection_id = inspection.id
         AND inspection.request_date BETWEEN '#{@request_start_date.to_date.iso8601}' AND '#{@request_end_date.to_date.iso8601}'
         AND record.rec_datetime = (select max(rec1.rec_datetime)
            from ins_inspection_records rec1
            where inspection.id = rec1.ins_inspection_id)
       "

      if params[:inspector] != "" && params[:inspector] != nil 
        inspections_query << " AND inspector.id = #{params[:inspector]}" 
        @inspector = params[:inspector]
      end

      if params[:record_type] != "" && params[:record_type] != nil 
        inspections_query << " AND record.ins_record_type_id = #{params[:record_type]}" 
        @record_type = params[:record_type]
      end

      if params[:situation] != "" && params[:situation] != nil 
        inspections_query << " AND inspection.situation = #{params[:situation]}" 
        @situation = params[:situation]  
      end

     @inspections = ActiveRecord::Base.connection.exec_query(inspections_query)

    if @inspections.first == nil
      inspections_query = inspections_query.sub('AND inspector.hr_employee_id = employee.id', '')
      @inspections = ActiveRecord::Base.connection.exec_query(inspections_query)
    end

    end

  end

  private

  def set_employee
    @employee = current_sys_user.hr_employee
  end
end