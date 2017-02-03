class InsInspectorFile < ActiveRecord::Base
  belongs_to :sys_document_type
  belongs_to :ins_inspector
  
  mount_uploader :inspector_file, InspectorFileUploader
end
