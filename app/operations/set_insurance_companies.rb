class SetInsuranceCompanies
  def perform(id) # Set company with all Inspectors. Company_id as a parameter
     inspectors = InsInspector.all
     inspectors.each do |inspector|
       if !InsInspectorXCompany.find_by(ins_insurance_company_id: id, ins_inspector_id: inspector.id) # if there is no relation already, it creates it
         InsInspectorXCompany.create(ins_insurance_company_id: id, ins_inspector_id: inspector.id, active: true)
       end
     end
  end
  
  def update(inspectors, company_id) # Get the hash from the controller, and update the database
    inspectors.each do |inspector| # get the hash from the checkboxes inside the view
      @edit = InsInspectorXCompany.find(inspector.first) # the first value of the hash has the ID of the current SysPermission
      @edit.update(active: inspector.second['active']) # The second has the rest: {active -> true}
    end
  end
end