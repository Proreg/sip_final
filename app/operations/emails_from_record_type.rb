class EmailsFromRecordType
  def initialize(inspection, record_type)
    @inspection = InsInspection.find(inspection)
    @record_type = InsRecordType.find(record_type)
  end 
  
  def get
    emails = []
    if @record_type.employee == "t"
      emails.push(@inspection.ins_inspector.try(:hr_employee).try(:email_proreg))
    end

    if @record_type.inspector == "t"
      emails.push(@inspection.ins_inspector.email)
    end
    
    if @record_type.alternative
      @record_type.alternative.split(";").each do |email|
        emails.push(email)
      end
    end
    
    @record_type.sys_group_id&.split(";")&.each do |group|
      SysUserXGroup.where(sys_group_id: group).each do |relation|
        if relation.sys_user.type_person == "e"
          emails.push(relation.sys_user.hr_employee.email_proreg)
        else
          emails.push(relation.sys_user.ins_inspector.email)
        end
      end
    end
    
    emails.compact! #remove nil values
    emails.uniq! # remove duplicates
    return emails
  end
  
end