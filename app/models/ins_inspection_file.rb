class InsInspectionFile < ActiveRecord::Base
  belongs_to :sys_document_type
  belongs_to :ins_inspection
  
  mount_uploader :inspector_upload, InspectionUploader
end
