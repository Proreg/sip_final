class InsInspection < ActiveRecord::Base
  belongs_to :ins_insurance_company
  belongs_to :sys_city
  belongs_to :risk_local
  belongs_to :ins_inspector
end
