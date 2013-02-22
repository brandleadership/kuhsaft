// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require redactor
//= require bootstrap
//= require_tree .

function loadTextEditor(elem){
  elem.find(".js-editor").redactor({
    buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', 'deleted', '|',
'unorderedlist', 'orderedlist', 'outdent', 'indent', '|',
'table', 'link'],
    formattingTags: ['h1', 'h2', 'h3', 'p']
  })
}

function checkPageType() {
  var redirect_url_input = $('#page_url');
  if ($('#page_page_type option:selected').val() == 'redirect') {
    redirect_url_input.removeAttr('disabled');
  } else {
    redirect_url_input.attr('disabled', 'disabled');
  }
}

$(function(){
  loadTextEditor($(document));
});

$(document).ajaxSuccess(function() {
  loadTextEditor($("body"));
});

$(document).ready(function() {
  checkPageType();
  $('#page_page_type').change(function() {
    checkPageType();
  });
});
