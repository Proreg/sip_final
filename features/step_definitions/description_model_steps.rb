Given /^I have sectors described (.+)$/ do |descriptions|
   descriptions.split(', ').each do |description|
     HrSector.create!(:description => description)
   end
end

When /^I go to list of (.+)$/ do |model|
  model.classify.all
end

Then /^I should see "([^"]*)"$/ do |arg|
  HrSector.find_by(description: arg)
end
