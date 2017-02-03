Rails.application.routes.draw do
  
  get '/'=>'welcome#main'
  get '/loaderio-63f16d0b4321daab1223441c2491d07c/'=>'welcome#loader_token'
  
  
   get '/PRG'=>'welcome#main'
  
  resources :hr_sectors, path: 'setores', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_relative_types, path: 'tipos_parente', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_blood_types, path: 'tipos_sanguineos', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_marital_statuses, path: 'estados_civis', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_telephone_types, path: 'tipos_telefone', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_countries, path: 'paises', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_states, path: 'estados', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_cities, path: 'cidades', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_menus, path: 'menus', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_relatives,path: 'funcionarios/:employee_id/parentes', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_employees,path: 'funcionarios', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_employee_phones,path: 'funcionarios/:employee_id/telefones', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_relative_phones,path: 'funcionarios/:employee_id/parentes/:relative_id/telefones', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_insurance_plans,path: 'planos_saude', path_names: { new: 'novo', edit: 'editar' }
  resources :hr_schooling_levels ,path: 'escolaridade', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_groups ,path: 'grupos', path_names: { new: 'novo', edit: 'editar' }
  post 'grupos/:group_id/permissoes/alterar' => 'sys_permissions#change'
  get 'grupos/:group_id/permissoes/editar' => 'sys_permissions#edit'
  
  devise_for :sys_users, path_names: { new: 'novo', edit: 'editar' }
  resources :sys_users ,path: 'usuarios', path_names: { new: 'novo', edit: 'editar' }
  get 'usuario/:id/nova_senha' => 'sys_users#new_password'
  get 'usuario/:id/grupos' => 'sys_users#included_groups'
  post 'usuario/:id/grupos/atualizar' => 'sys_users#update_groups'
 
  resources :ins_inspectors, path: 'inspetores', path_names: { new: 'novo', edit: 'editar' } do
    post 'seguradoras/alterar'=> 'ins_inspectors#companies_change'
    get 'seguradoras/editar'=> 'ins_inspectors#companies_edit'
  end
  resources :ins_inspector_phones, path: 'inspetores/:inspector_id/telefones', path_names: { new: 'novo', edit: 'editar' }
  resources :ins_sub_inspectors, path: 'inspetores/:inspector_id/sub_inspetores', path_names: { new: 'novo', edit: 'editar' }
  get 'sub_inspetores' => 'ins_sub_inspectors#list'
  resources :ins_sub_inspector_phones, path: 'inspetores/:inspector_id/sub_inspetores/:sub_inspector_id/telefones', path_names: { new: 'novo', edit: 'editar' }
  
  resources :ins_sub_inspector_files, path: 'sub_inspetores/:sub_inspector_id/arquivos', path_names: { new: 'novo', edit: 'editar' }
  get 'sub_inspetores/:sub_inspector_id/arquivos/:id/downloads' => 'ins_sub_inspector_files#download'
  
  resources :sys_document_types, path: 'tipos_documentos', path_names: { new: 'novo', edit: 'editar' }
 
  resources :ins_inspector_files, path: 'inspetores/:inspector_id/arquivos', path_names: { new: 'novo', edit: 'editar' }
  get 'ins_inspetores/:inspector_id/arquivos/:id/downloads' => 'ins_inspector_files#download'
  
  get 'inspecoes/:ins_inspection_id/arquivos' => 'ins_inspection_files#index'
  get 'inspecoes/:ins_inspection_id/arquivos/:ins_inspection_file_id/download' => 'ins_inspection_files#download'
  get 'inspecoes/:ins_inspection_id/arquivos/selecionar_arquivos' => 'ins_inspection_files#add'
  post 'inspecoes/:ins_inspection_id/arquivos/arquivos_selecionados' => 'ins_inspection_files#selected_files'
  
  resources :ins_inspector_products, path: 'produtos_inspetor', path_names: { new: 'novo', edit: 'editar' }
  resources :ins_inspector_honorariums, path: 'inspetores/:inspector_id/honorarios', path_names: { new: 'novo', edit: 'editar' }
  resources :ins_coverage_types, path: 'tipos_coberturas', path_names: { new: 'novo', edit: 'editar' }
  resources :ins_insurance_companies, path: 'seguradoras', path_names: { new: 'novo', edit: 'editar' } do
    post 'inspetores/alterar'=> 'ins_insurance_companies#inspectors_change'
    get 'inspetores/editar'=> 'ins_insurance_companies#inspectors_edit'
    resources :ins_company_phones, path: 'telefones', path_names: { new: 'novo', edit: 'editar' } 
  end
  
  resources :ins_spending_types, path: 'tipos_despesas', path_names: { new: 'novo', edit: 'editar' }
  resources :ins_products, path: 'produtos', path_names: { new: 'novo', edit: 'editar' }
  

  resources :ins_inspections, path: 'inspecoes', path_names: { new: 'novo', edit: 'editar'} do
    get 'coberturas' => 'ins_inspections#delete_coverage'
    get 'telefones' => 'ins_inspections#delete_phone'
    get 'mapa' => 'ins_inspection_maps#choose_inspector'
    post 'escolha_inspector' => 'ins_inspection_maps#inspector_chosen'
    get 'coberturas' => 'ins_inspections#delete_coverage'
    get 'inspeção_simplificada' => 'ins_inspections#simplified_inspection'
    
    resources :ins_inspection_records, path: 'apontamentos', only: [:index, :new, :edit, :update], path_names: { new: 'novo', edit: 'editar' }

    get 'recebida_tecnica'=> 'ins_inspections#mark_as_received'
    get 'subscricao_primeira_analise'=> 'ins_inspections#first_analysis'
    get 'subscricao_analise_final'=> 'ins_inspections#final_analysis'
    get 'inspecao_enviada'=> 'ins_inspections#sent'
    get 'baixa'=> 'ins_inspections#ending'
    get 'conferencia_baixa'=> 'ins_inspections#ending_review'
    get 'E'=> 'ins_inspections#e'
    get 'cancelar'=> 'ins_inspections#cancel'
  end
  post 'inspecoes/novo/arquivo'=> 'ins_inspections#new_file'
  get 'inspecoes/not_temp/:file_name'=> 'ins_inspections#not_temp'
  
  
  resources :ins_company_honoraria ,path: 'honorarios_cia', path_names: { new: 'novo', edit: 'editar' }
  resources :ins_company_spendings ,path: 'despesas_cia', path_names: { new: 'novo', edit: 'editar' }
  
    
  post 'inspecoes/:ins_inspection_id/itens/alterar' => 'ins_inspection_items#change'
  get 'inspecoes/:ins_inspection_id/itens/editar' => 'ins_inspection_items#edit'
  get 'inspecoes/:ins_inspection_id/itens/create' => 'ins_inspection_items#add'
  get 'inspecoes/:ins_inspection_id/itens/deletar' => 'ins_inspection_items#delete'
  
  resources :ins_rules_fields, path: 'campos_regra', path_names: { new: 'novo', edit: 'editar' } 
  resources :ins_import_rules, path: 'regras_importacao', path_names: { new: 'novo', edit: 'editar' }
    
  
  resources :ins_record_types, path: 'tipos_apontamento', path_names: { new: 'novo', edit: 'editar' }
  
  get 'funcionarios/listar' => 'employees#list'
  get 'funcionarios/visualizar' => 'employees#show'
  get 'funcionarios/editar' => 'employees#edit'
  patch 'funcionarios/atualizar'=> 'employees#update'
  get 'funcionarios/novo/:id' => 'employees#new'
  post 'funcionarios/criar' => 'employees#create'
  get 'funcionarios/atualizar'=> 'employees#update'
  get 'funcionarios/apagar' => 'employees#destroy'

  get 'painel_inspetor/:ins_inspector_id' => 'inspector_dashboard#index'
  get 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id' => 'inspector_dashboard#inspection'
  get 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/download' => 'inspector_dashboard#download'
  post 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/agendamento' => 'inspector_dashboard#scheduling'
  get 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/pedido_simplificado' => 'inspector_dashboard#simplified_inspection'
  post 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/problema_agendamento' => 'inspector_dashboard#scheduling_problem'
  get 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/executar' => 'inspector_dashboard#run'
  post 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/enviar_laudo' => 'inspector_dashboard#send_report'
  post 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/problema_execucao' => 'inspector_dashboard#run_problem'
  post 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/inspecao_frustrada' => 'inspector_dashboard#inspection_frustated'
  post 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/inspecao_rejeitada' => 'inspector_dashboard#reject_inspection'
  
  resources :dashboard_ins_inspector_items, path: 'painel_inspetor/:ins_inspector_id/inspecao/:ins_inspection_id/item', path_names: { new: 'novo', edit: 'editar' }
  
  get 'painel_operacional' => 'operational_dashboard#index'
  get 'painel_financeiro' => 'financial_dashboard#index'
  get 'painel_financeiro/inspecao_conferida/:ins_inspection_id' => 'financial_dashboard#check'
  get 'painel_financeiro/inspecao/:ins_inspection_id/itens_inspetor' => 'financial_dashboard#inspector_items'
  get 'painel_financeiro/inspecao/:ins_inspection_id/itens_inspetor/:id' => 'financial_dashboard#delete_inspector_items'
  post 'painel_financeiro/inspecao/:ins_inspection_id/itens_inspetor' => 'financial_dashboard#change'
  
  resources :sys_regions, path: 'regioes', path_names: { new: 'novo', edit: 'editar' }
  resources :sys_state_x_regions, path: 'regioes_estados', path_names: { new: 'novo', edit: 'editar' }
  
  get 'relatorios'=> 'reports#index'
  post 'relatorios'=> 'reports#inspections_by_insurance_companies'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
