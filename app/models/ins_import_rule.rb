class InsImportRule < ActiveRecord::Base
  belongs_to :ins_insurance_company
  belongs_to :ins_rules_field
end
