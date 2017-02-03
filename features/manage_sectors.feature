Feature: Manage Sectors
  In order to add a sector to an employee
  As an user
  I want to create and manage sectors
  
  Scenario: Sectors List
  	Given I have HrSector described RH, TI
  	When I go to list of HrSector
  	Then I should see TI in the model HrSector
  	And I should see RH in the model HrSector