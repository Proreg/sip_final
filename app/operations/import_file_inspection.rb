class ImportFileInspection
  def move_to_temp(filename)
    filename = File.basename(filename, File.extname(filename)) # Remove the extension (example.txt => example)
    
    files_folder = Dir.glob("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}/#{filename}*.*")
    if files_folder.empty? # If files are not in the day's folder, checks the previous day
      files_folder = Dir.glob("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{(Date.today.day)-1}/#{filename}*.*") # Search the related files in the same day's folder
    end 
    
    files_folder.each do |file|
      file_source = file 
      #file_destiny = file.sub("/#{(Date.today.day) -1}/", "/#{Date.today.day}/tmp/") 
      file_destiny = file.sub("/#{Date.today.day}/", "/#{Date.today.day}/tmp/")
      puts File.rename file_source , file_destiny #move file from the folder to /tmp     
    end
  end
  
  def move_from_temp(filename)
    filename = File.basename(filename, File.extname(filename)) # Remove the extension (example.txt => example)

    files_folder = Dir.glob("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}/tmp/#{filename}*.*") # Search the related files in the same day's folder
    
    files_folder.each do |file|
      file_source = file 
      file_destiny = file.sub("/#{Date.today.day}/tmp/", "/#{Date.today.day}/")
      File.rename file_source , file_destiny #move file from the folder to /tmp     
    end    
  end
end