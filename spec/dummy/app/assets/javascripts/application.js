// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require moment
//= require moment/ru
//= require bootstrap
//= require bootstrap-datetimepicker
//= require activestorage
//= require turbolinks
//= require noty_flash
//= require best_in_place
//= require_tree .

document.addEventListener("turbolinks:load", function() {
  $('div.datetimepicker').datetimepicker({ locale: 'ru', format: 'DD-MM-YYYY' });
});

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});
