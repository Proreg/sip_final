class InsInspectionItem < ActiveRecord::Base
  belongs_to :ins_product
  belongs_to :ins_inspection
  belongs_to :ins_classification
end
