class InsInspectorItem < ActiveRecord::Base
  belongs_to :ins_inspection
  belongs_to :ins_inspector_product
end
