class InsInspectorXCompany < ActiveRecord::Base
  belongs_to :ins_inspector
  belongs_to :ins_insurance_company
end
