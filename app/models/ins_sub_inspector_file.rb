class InsSubInspectorFile < ActiveRecord::Base
  belongs_to :sys_document_type
  belongs_to :ins_sub_inspector
  
  mount_uploader :sub_inspector_file, SubInspectorFileUploader
end
