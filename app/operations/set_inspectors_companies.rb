class SetInspectorsCompanies
  def perform(id) # Set the inspector with all Companies. inspector_id as a parameter
     companies = InsInsuranceCompany.all
     companies.each do |company|
       if !InsInspectorXCompany.find_by(ins_insurance_company_id: company.id, ins_inspector_id: id) # if there is no relation already, it creates it
         InsInspectorXCompany.create(ins_insurance_company_id: company.id, ins_inspector_id: id, active: true)
       end
     end
  end
  
  def update(companies, inspector_id) # Get the hash from the controller, and update the database
    companies.each do |company| # get the hash from the checkboxes inside the view
      @edit = InsInspectorXCompany.find(company.first) # the first value of the hash has the ID of the current SysPermission
      @edit.update(active: company.second['active']) # The second has the rest: {active -> true}
    end
  end
end