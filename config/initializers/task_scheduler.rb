scheduler = Rufus::Scheduler.new

scheduler.cron '8 0 1 1 *' do  # do something every year  on the first day of the month, on january, 8 minutes after midnight
  Dir.mkdir("/samba_volumes/#{Date.today.year}")
end

scheduler.cron '9 0 1 * *' do  # do something on the first day of the month, 9 minutes after midnight
  Dir.mkdir("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES")
end

scheduler.cron '10 0 * * *' do  # do something every day, ten minutes after midnight
  Dir.mkdir("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}")
  Dir.mkdir("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}/tmp")
  Dir.mkdir("/samba_volumes/#{Date.today.year}/#{(I18n.t 'month_names')[Date.today.month]}/SOLICITAÇÕES/#{Date.today.day}/cadastradas")
end