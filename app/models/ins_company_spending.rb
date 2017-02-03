class InsCompanySpending < ActiveRecord::Base
  belongs_to :ins_product
  belongs_to :ins_insurance_company
  belongs_to :sys_state
  belongs_to :sys_region
end
