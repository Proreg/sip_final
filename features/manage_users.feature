Feature: Manage Users
  In order to generate an user to an employee
  As an user
  I want to create and manage users
  
  Scenario: Users List
  	Given I have a sys_user with username and email joao, joao
  	When I go to list of sys_users
  	Then I should see joao.vieira in username in sys_users