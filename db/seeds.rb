# Populates the DB

#  HrRelativeType, HrBloodType, HrMaritalStatus, SysTelephoneType, HrSchoolingLevel, SysCountry, HrSector, SysGroup, HrPosition, HrInsurancePlan
models_one_description = [
  HrRelativeType,
  HrBloodType,
  HrMaritalStatus,
  SysTelephoneType,
  HrSchoolingLevel,
  SysCountry,
  HrSector,
  SysGroup,
  HrPosition,
  HrInsurancePlan, 
  SysDocumentType,
  InsCoverageType,
  InsSpendingType,
  InsRulesField
  ]

models_one_description_data = [
  ['Pai', 'Mãe'],
  ['O+', 'A+'],
  ['Solteiro(a)', 'Casado(a)'],
  ['Residencial', 'Celular'],
  ['Pós-Doutorado', 'Superior Completo'],
  ['Brasil', 'Argentina'],
  ['Tecnica', 'Operacional'],
  ['Administradores', 'Visualizar'],
  ['Supervisor', 'Analista de Ti'],
  ['Unimed', 'Circulo'],
  ['CPF', 'RG', 'CNH'],
  ['Alagamento', 'Incendio', 'Vendaval'],
  ['Honorario', 'KM', 'Passagem Aerea', 'Refeicao'],
  ['Nome', 'Cadastro do Pedido', 'Situacao',
 'Valor','Endereco', 'Bairro', 'CEP', 'Chave',
 'Solicitante', 'Atividade']
]
count=0
models_one_description.each do |m_one|
  models_one_description_data[count].each do |n1, n2|
    m_one.create( description: n1 )
    m_one.create( description: n2 )
  end
  count = count+1
end

#State
states_list = [
  [ 'Rio Grande do Sul', 'RS', 1 ],
  [ 'Santa Catarina', 'SC', 1 ]
]

states_list.each do |name,uf ,country|
  SysState.create( description: name, UF: uf, sys_country_id: country )
end

#City
cities_list = [
  [ 'Caxias do Sul', 1 ],
  ['Porto Alegre', 1],
  [ 'Marau', 2 ]
]

cities_list.each do |name, state|
  SysCity.create( description: name, sys_state_id: state )
end

#Employee
employee_list = [
  [ 1, 1, 1, 1, 1, 2, 1, 'Eduardo Fonseca', '45678912385', '1234567845',
    412, 334, 412, '12/12/2000', 'F', true, 322, 41242,312421,
    'dudu@bol', 'obs: OB dGGS SDF S FOSA FOKSA K', 443, 312,312, 'sadihoh@proeg.com.br',
    "Rua Marechal Floriano", "Centro", 95000851, 123, "Perto da Proreg", true],
   
   [ 1, 1, 1, 1, 1, 2, 1, 'João Vieira', '78523695147', '110325320515',
    4212, 3344, 4512, '12/12/2000', 'M', true, 3262, 481242,3192421,
    'joaoo@brturbo', 'obs:aa OB dGGS SDF S FOSA FOKSA K', 4423, 213,123, 'joaod12@proreg.con.br',
    "Rua Garibaldi", "Centro", 95111151, 124, "Perto ddo MC", false  ],
    
       [ 1, 1, 1, 1, 1, 2, 1, 'João Carlos Carlos Carlos  Vieira', '73523695147', '1525320515',
    42321, 334324, 442352, '12/12/2001', 'M', true, 322342, 41232442,334292421,
    'joaooca@brturbo', 'obs:aa OBADADS dGGS SDF S FOSA FOKSA K', 41143, 1113,2343, 'joao@proreg.con.br',
    "Rua GaradADSibaldi", "Centsro", 9511111423, 32414, "Perto ddo MC", false  ],
] 
employee_list.each do |sector, city, marital_status, blood_type, schooling_level, position, insurance_plan,
 name, cpf, rg, pis, cts, serie_cts,date_of_birth, gender, smoker, sus, titulo_eleitor,reservista, email,
 obs, extension_line, access_code, locker_code, email_proreg,address, neighborhood, zip_code ,house_number,
 complement, active|
  
  a=HrEmployee.create( hr_sector_id:sector, sys_city_id: city, hr_marital_status_id: marital_status,
  hr_blood_type_id: blood_type, hr_schooling_level_id: schooling_level, hr_position_id: position, 
  hr_insurance_plan_id: insurance_plan, name: name, cpf: cpf, rg: rg, pis: pis, cts: cts, 
  serie_cts: serie_cts, date_of_birth: date_of_birth, gender: gender, smoker: smoker,
  sus: sus, titulo_eleitor: titulo_eleitor,reservista: reservista, email: email, obs: obs,
  extension_line: extension_line, access_code: access_code, email_proreg: email_proreg, locker_code: locker_code,
  address: address, neighborhood: neighborhood, zip_code: zip_code, house_number: house_number, complement: complement,
  active: active
  )

  puts a.errors.messages
end

#Employee Phone
employee_phone_list = [[ '99999999', 54, 1, 2 ], [ '969999999', 21, 2, 1]] 
employee_phone_list.each do |number, area, employee, type|
  HrEmployeePhone.create( phone_number: number, area_code: area, hr_employee_id: employee, sys_telephone_type_id: type )
end

#Relative   Date format: 
relative_list = [
  [1, 1, 'NOME DA MAE DE ALGUEM', '25-10-1994', false, 'F', '154.641.521-84', '215454545'],
  [1, 2, 'NOME Do pai DE ALGUEM', '25-1-1924', false, 'M', '144.543.411-44', '2151545']] 
relative_list.each do |employee, type, name, dob, dependente, gender, cpf, rg|
  a=HrRelative.create( hr_employee_id: employee, name: name, gender: gender, cpf: cpf,rg: rg,
  dependente: dependente, hr_relative_type_id: type,date_of_birth: dob)
end

#Relative_phone
relative_phone_list = [[ '94572399', 51, 2, 2 ], [ '96997799', 41, 1, 1]] 
relative_phone_list.each do |number, area, relative, type|
  HrRelativePhone.create( phone_number: number, area_code: area, hr_relative_id: relative, sys_telephone_type_id: type )
end

#sys_user
user_list = [[2, 'joao.vieira', 'employee', 'A12345', false, true, 'joaoo@brturbo']] 
user_list.each do |fk_id, user, type_person ,  pw, ext, active, email|
  if type_person == 'employee'
    a=SysUser.create( hr_employee_id: fk_id, username: user, type_person: type_person, password: pw, external_access: ext,    active: active, email: email)
  else
    a=SysUser.create( ins_inspector_id: fk_id, username: user, type_person: type_person, password: pw, external_access: ext,
    active: active, email: email)  
  end
   puts a.errors.messages
end

#user x group
user_group_list = [[1, 1], [1, 2], [2, 2]] 
user_group_list.each do |user, group|
  SysUserXGroup.create(sys_group_id: group, sys_user_id: user)
end


#menus
menu_list = [
['RH', '1', '', ''],
['Funcionários', '1.1', 'index', 'hr_employees'],
['Geral RH', '1.1', '', ''],
['Tipos Sanguíneos', '1.1.1', 'index', 'hr_blood_types'],
['Estados Civis', '1.1.2', 'index', 'hr_marital_statuses'],
['Planos de Saúde', '1.1.3', 'index', 'hr_insurance_plans'],
['Parentesco', '1.1.4', 'index', 'hr_relative_types'],
['Setores', '1.1.5', 'index', 'hr_sectors'],

['Locais', '2', '', ''],
['Estados', '2.1', 'index', 'sys_states'],
['Países', '2.2', 'index', 'sys_countries'],
['Cidades', '2.3', 'index', 'sys_cities'],
['Tipos Telefone', '2.4', 'index', 'sys_telephone_types'],

['Inspeção Prévia', '3', '', ''],
['Inspetor', '3.1', 'index', 'ins_inspectors'],
['SubInspetor', '3.2', 'list', 'ins_sub_inspectors'],
['Produtos Inspetor', '3.3', 'index', 'ins_inspector_products'],
['Tipos de Cobertura', '3.4', 'index', 'ins_coverage_types'],
['Seguradoras', '3.5', 'index', 'ins_insurance_companies'],
['Tipos de Despesa', '3.6', 'index', 'ins_spending_types'],
['Produtos', '3.7', 'index', 'ins_products'],
['Inspeções', '3.8', 'index', 'ins_inspections'],
['Regras Importação', '3.9', 'index', 'ins_import_rules'],
['Campos Regras Importação', '3.10', 'index', 'ins_rules_fields'],

['Configuração', '4', '', ''],
['Usuário', '4.1', 'index', 'sys_users'],
['Menus', '4.2', 'index', 'sys_menus'],
['Grupos', '4.3', 'index', 'sys_groups'],
['Tipo Documento', '4.4', 'index', 'sys_document_types'],

#que não estão no menu
['Permissões', '', '', 'sys_permissions'],
['Arquivos inspetor', '', '', 'ins_inspector_files'],
['Arquivo SubInspetor', '', '', 'ins_sub_inspector_files'],
['Tipo Documento', '', '', 'ins_inspector_honorariums'],
['Telefone Subinspetor', '', '', 'ins_sub_inspector_phones'],
['Telefone Seguradora', '', '', 'ins_company_phones'],
['Telefone Inspetor', '', '', 'ins_inspector_phones'],
['Itens Inspeção', '', '', 'ins_inspection_items'],


] 
menu_list.each do |desc, order_menu, action, controller|
  SysMenu.create(description: desc, order_menu: order_menu, action: action, controller: controller)
end


#permissions
permission_list = [
[1, 1, true, true, true, true ],
[2, 1, true, true, true, true ], 
[3, 1, true, false, false, false], 
[4, 1, true, false, false, false], 
[5, 1, true, false, false, false], 
[6, 1, true, false, false, false],
[7,1,true, true, true, true],
[8,1,true, true, true, true],
[9,1,true, true, true, true],
[10,1,true, true, true, true],
[11,1,true, true, true, true],
[12,1,true, true, true, true],
[13,1,true, true, true, true],
[14,1,true, true, true, true],
[15,1,true, true, true, true],
[16,1,true, true, true, true],
[17,1,true, true, true, true],
[18,1,true, true, true, true],
[19,1,true, true, true, true],
[20,1,true, true, true, true],
[21,1,true, true, true, true],
[22,1,true, true, true, true],
[23,1,true, true, true, true],
[24,1,true, true, true, true],
[25,1,true, true, true, true],
[26,1,true, true, true, true],
[27,1,true, true, true, true],
[28,1,true, true, true, true],
[29,1,true, true, true, true],
[30,1,true, true, true, true],
[31,1,true, true, true, true],
[32,1,true, true, true, true],
[33,1,true, true, true, true],
[34,1,true, true, true, true],
[35,1,true, true, true, true],
[36,1,true, true, true, true],
[37,1,true, true, true, true]
] 
permission_list.each do |menu, group, s, e, c, d|
  SysPermission.create(sys_menu_id:menu, sys_group_id: group, show_it: s, edit_it: e,
  create_it: c, destroy_it: d)
end

#inspector
inspector_list = [['Junior Selau', 95000000, 'Rua  dasopd asjd ajop','bairro asjsaojd ado', '312', 
  'perto da aasdfag', 'junior.selau@proreg.com.br', 
13414152343, '133211233\  ', 'A', 'A', 'O inspetor Junior gosta de ', '25-10-1994', 'S', 1 ],

['Joao Silva', 95100000, 'Rua  dpd asfd ajop','baiadsr asads ssaj ado', '3142', 
  'perto da aasdfag', 'junior.selu@proreg.com.br', 
13414198343, '1336112397', 'A', 'A', 'O inspetor João gosta de ', '25-10-1992', 'S', 2 ],

['Eduardo Silva', 95200000, 'Rua  dasosdsas ads  ds p','baaddasda  as a  adsasjsaojd ado', '3112', 
  'peds  as da asdt o da aasdfag', 'jun@proreg.com.br', 
13414176343, '133211873', 'A', 'A', 'O inspeto g de ', '25-10-1992', 'S', 1 ],

['Silva Joao', 95000500, 'Rua ads  dasopd asjd ajop','bairro asjsaojd ado', '3142', 
  'perto da aasdfag', 'silva@proreg.com.br', 
13414145343, '133211875', 'A', 'A', 'O inspetor Junior gosta de ', '25-10-1994', 'S', 1 ],

['Silva Eduardo', 91000000, 'Rua dsa dasopd asjd ajop','bai dasg rro assjsaojd ado', '33512', 
  'perto dasa aasdfag', 'juni@proreg.com.br', 
13414123363, '133665233', 'A', 'A', 'O inspetor Junior gosta de ', '25-10-1994', 'S', 1 ],
] 
inspector_list.each do |name, zip_code, address, neighborhood, house_number, complement, email,
 cpf, rg, status, ind_save , obs, date_of_birth, mei, sys_city|
  a=InsInspector.create(name: name, zip_code: zip_code, address: address, neighborhood: neighborhood,
  house_number: house_number, complement: complement, email: email, cpf: cpf, rg: rg, status: status,
  ind_save: ind_save, obs: obs, date_of_birth: date_of_birth, mei: mei, sys_city_id: sys_city)
  puts a.errors.messages
end

      
#sub_inspector
sub_inspector_list = [['carlos joao', 95000000, 'Rua asda dasopd asjd ajop','bairro asjsaojd ado', '312', 
  'perto da aasdfag', 'jaooa.carlos@proreg.', 
13414152343, '133211233', 'A', 'A', 'OA AS DAS DA  D G GA ', '25-10-1994', 1 ]
] 
sub_inspector_list.each do |name, zip_code, address, neighborhood, house_number, complement, email,
 cpf, rg, status, ind_save , obs, date_of_birth,  sys_city|
  a=InsSubInspector.create(name: name, zip_code: zip_code, address: address, neighborhood: neighborhood,
  house_number: house_number, complement: complement, email: email, cpf: cpf, rg: rg, status: status,
  ind_save: ind_save, obs: obs, date_of_birth: date_of_birth,  sys_city_id: sys_city)
  puts a.errors.messages
end

#inspectorxsubinspector
 inspectorxsubinspector = [[1,1]
] 
inspectorxsubinspector.each do |inspector, sub_inspector|
  InsInspectorXSubInspector.create(ins_inspector_id: inspector, ins_sub_inspector_id: sub_inspector)
end

#ins_insurance_company
 ins_insurance_company_list = [['Bradesco Seguraos balblablabla', 'Bradesco Seguros', '11110709000134',
   '132321', 'Rua RAasdopsd ARadafas', '95000000', 'Centro', 'bradesco@bradesco.com.br','25-10-1994', 
   'a empresa sdasa asd a jdoad joa a', 'A', 1],
   
   ['Porto Seguro', 'Proto Seguro', '1110709600134',
   '132621', 'Rua RAasdopsd ARadafas', '95000500', 'Cento', 'bradfaSFesco@bradesco.com.br','25-10-1994', 
   'a empresa sdasa asd a jdoad joa a', 'A', 1],
   
   ['Tokio asdjidsa as sa sa', 'Tokio Seguros', '11230709000134',
   '131321', 'Rua RAasdopsd ARadafas', '95000000', 'Centro', 'brades@bradesco.com.br','25-10-1934', 
   'a empresa sdasa asd a jdoad joa a', 'A', 1],
   
   ['Mitsui as', 'Mitsui', '33110709000134',
   '132324', 'Rua RAasdopsd ARadafas', '950000200', 'Centro', 'mitsui@bradesco.com.br','22-10-1994', 
   'a empresa sdasa asd a jdoad joa a', 'A', 1]  
] 
ins_insurance_company_list.each do |corporate_name, commercial_name, cnpj, state_registration, address,
                                    zip_code, neighborhood, email, register_date, notes, status, sys_city_id|
  InsInsuranceCompany.create(corporate_name: corporate_name, commercial_name: commercial_name,
                                   cnpj: cnpj, state_registration: state_registration, address: address,
                                   zip_code: zip_code, neighborhood: neighborhood, email: email,
                                   register_date: register_date, notes: notes, status: status,
                                   sys_city_id: sys_city_id)
end

#inspectorxcompany
  
inspectorxcompany= [[1,1, true]] 
inspectorxcompany.each do |inspector, company, active|
  InsInspectorXCompany.create(ins_inspector_id: inspector, ins_insurance_company_id: company,
  active: active)
end


# InsInspectorProduct  
inspector_product= [['Condominio', 'S'],
                    ['Empresa', 'S'],
                    ['Equipamento','S']] 
inspector_product.each do |description, ind_status|
  InsInspectorProduct.create(description: description,
   ind_status: ind_status)
end


# InsProduct  
product= [[1, 1, 'Condominio - Bradesco', 1, 'S',1],
          [1, 1, 'Empresa - Bradesco', 1, 'S',2],
          [1, 1, 'Equipamento - Bradesco', 1, 'S',3],
          [1, 3, 'Condominio - Tokio', 1, 'S',1],
          [1, 3, 'Empresa - Tokio', 1, 'S',2],
          [1, 3, 'Equipamento - Tokio', 1, 'S',3]] 
product.each do |ins_spending_type_id, ins_insurance_company_id, description, unit, ind_active, ins_inspector_product_id|
  InsProduct.create(ins_spending_type_id: ins_spending_type_id,
   ins_insurance_company_id: ins_insurance_company_id, description: description, unit: unit,
    ind_active: ind_active, ins_inspector_product_id: ins_inspector_product_id)
end

# InsImportRules 
import= [
#Bradesco  
['Nome;', ';Nome contato', 1 , 1],
['Cadastro do Pedido;', ';Seguradora', 1 , 2],
#['Valor Do Risco', 'CEP do EndInspeção', 1 , 3], Don't use number 3, Which is "Situação and it's not present in the file"
['Valor Do Risco;', ';Tipo Moeda', 1 , 4],
['Endereço Inspeção;', ';Número', 1 , 5],
['Bairro;', ';Cidade', 1 , 6],
['CEP do End Inspeção;', ';Endereço Inspeção', 1 , 7],
['Ano/Pedido;', ';Cadastro do Pedido', 1 , 8],
#['Endereço Inspeção;', ';Número', 1 , 9],  Don't use number 3, Which is "Solicitante" and it's not present in the file"
['Atividade/Ocupação;', ';Coberturas', 1 , 10],

# Porto
['Segurado:', '\n', 2 , 1],
['Proposta: ', '\n', 2 , 2],
#['Valor Do Risco', 'CEP do EndInspeção', 1 , 3], Don't use number 3, Which is "Situação and it's not present in the file"
['Valor Do Risco;', ';Tipo Moeda', 2 , 4],
['Logradouro: ', '\n', 2 , 5],
['Bairro: ', '\n', 2 , 6],
['Cep: ', '\n', 2 , 7],
['Pedido de inspeção - ', '\n', 2 , 8],
#['Endereço Inspeção;', ';Número', 1 , 9 ],  Don't use number 3, Which is "Solicitante" and it's not present in the file"
['Atividade/Ocupação;', ';Coberturas', 2 , 10]

]
 

import.each do |limit_begin, limit_end, ins_insurance_company_id, ins_rules_field_id|
  InsImportRule.create(limit_begin: limit_begin, limit_end: limit_end,
  ins_insurance_company_id: ins_insurance_company_id, ins_rules_field_id: ins_rules_field_id)
end


# InsClassification 
classification= [['IC1', 1],
                 ['IC2', 1],
                 ['IC3', 1]] 
classification. each do |descripiton, ins_insurance_company_id|
  InsClassification.create(description: description, ins_insurance_company_id: ins_insurance_company_id)
end  

