//= require jquery-1.12.4
//= require foundation
//= require foundation/foundation.offcanvas
//= require foundation/foundation.magellan
//= require vendor/modernizr
//= require foundation/dataTables.foundation.min.js
//= require dataTables/jquery.dataTables
//= require vendor/jquery.maskedinput.min
//= require vendor/jquery.maskMoney
//= require vendor/moment.min
//= require vendor/custom
//= require vendor/zip_code_validator
//= require vendor/validate_cpf
//= require wice_grid
//= require semantic.min
//= require jquery_ujs
//= require dataTables/jquery.dataTables
$('.ui.dropdown')
  .dropdown()
;
$( "#datepicker" ).datepicker();

$(function(){
	$(document).foundation(); 
});
