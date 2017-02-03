class InsCompanyPhone < ActiveRecord::Base
  belongs_to :sys_telephone_type
  belongs_to :ins_insurance_company
end
