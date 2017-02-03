class SetReportFiles
  def perform(files, inspection) # Set the inspector with all Companies. inspector_id as a parameter
     files.each do |file|
       if file.second.count == 2 # true
         path_helper = InsReportFile.find(file.first).report_path
         
         InsInspectionFile.create(description: File.basename(path_helper),
         sys_document_type_id: nil, 
         ins_inspection_id: inspection,
         ind_inspector_view: "t",
         ins_report_file_id: file.first,
         inspection_path: path_helper
         ) 
       else
         InsInspectionFile.where(ins_inspection_id: inspection,
         ins_report_file_id: file
         ).each do |insp_file|
           insp_file.destroy
         end  
       end
       
     end
  end
end