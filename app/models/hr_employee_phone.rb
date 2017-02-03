class HrEmployeePhone < ActiveRecord::Base
  belongs_to :sys_telephone_type
  belongs_to :hr_employee
  
  validates :phone_number, :area_code, :sys_telephone_type_id, :hr_employee_id, presence: true
  validates :sys_telephone_type, :hr_employee, presence: true
end