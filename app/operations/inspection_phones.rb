class InspectionPhones
  def create(phones, inspection)    
    phones.each do |p| 
      InsInspectionPhone.create(sys_telephone_type_id: p['sys_telephone_type'].to_i,
       phone_number: p['phone_number'], ins_inspection_id: inspection)
    end
  end
  
  def edit(current_phones, update_phones)
    current_phones.each do |c|
      c.update(sys_telephone_type_id: update_phones[c.id.to_s]['sys_telephone_type'].to_i,
      phone_number: update_phones[c.id.to_s]['phone_number'])  
    end
  end
end