class SaveFileInspection
  def move_to_created(filename, inspection)
    filename = filename.partition('.').first # Remove the extension (example.txt => example)
  
    files_folder = Dir.glob("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}/#{filename}*.*") # Search the related files in the same day's folder
    
    files_folder.each do |file|    
      file_source = file 
      file_destiny = file.sub("/#{Date.today.day}/", "/#{Date.today.day}/cadastradas/")
      File.rename file_source , file_destiny
      
      puts file_destiny
     
      a = InsInspectionFile.create(inspection_path: file_destiny,
       ins_inspection_id: inspection,description: "Solicitações",
       sys_document_type_id:  90,
       ind_inspector_view: "t",
       created_on: Date.today
       ) # save path to DB  
     
    end
    
  end
end