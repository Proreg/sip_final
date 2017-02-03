class InsInspectorHonorarium < ActiveRecord::Base
  belongs_to :ins_inspector
  belongs_to :ins_inspector_product
end
