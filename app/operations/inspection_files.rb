class InspectionFiles
  def to_hash(file_name, company)
    fields = InsImportRule.where(ins_insurance_company_id: company) # Gets all fields related to the insurance company
     
    content = {}
    file_content = ''
    
    file_type = file_name.partition('.').last #get extension name
    
   path = Dir.glob("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}/#{file_name}").first # Search the related files in the same day's folder
   if path.empty? # if files are not in the day's folder, checks the previous day
     path = Dir.glob("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{(Date.today.day)-1}/#{file_name}").first # Search the related files in the same day's folder
   end 
    
   if file_type == "txt" # .txt
      file_content = IO.binread(path).bytes.to_a.pack('U*').tr( # Read in binary and convert it to UTF-8, then remove latin chars
        "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
        "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
    elsif file_type == "pdf" # .pdf
       reader = PDF::Reader.new(path)
       reader.pages.each do |page| # read the content of each page
         file_content = file_content + page.text 
       end
    else
      return false # invalid file
    end   
    fields.each do |field| 
      content_field = file_content[/#{field.limit_begin}(.*?)#{field.limit_end}/m, 1] # Gets the string between the two limiters
      content[field.ins_rules_field.description] = content_field  # save it to a hash  ["field_name" => "value from file"]
    end
    return content 
 end
end