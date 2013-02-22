# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require redactor
#= require bootstrap
#= require_tree .

loadTextEditor = (elem) ->
  elem.find(".js-editor").redactor()

checkPageType = ->
  redirect_url_input = $('#page_url')
  if ($('#page_page_type option:selected').val() == 'redirect')
    redirect_url_input.removeAttr('disabled')
  else
    redirect_url_input.attr('disabled', 'disabled')

sortableBrick = ->
  $(".brick-list").each (idx, elem) ->
    $(elem).sortable(
      handle: '.brick-item-header',
      axis: "y",
      update: (event, ui) ->
         #$(this).find(".brick-item").each (idx, elem) ->
            #$(this).find("input.position-field").val(idx+1)
            #$(this).children('form').trigger('submit')
      )

$(document).ajaxSuccess ->
  loadTextEditor($("body"))
  sortableBrick()

$(document).ready ->
  loadTextEditor($(document))
  checkPageType()
  sortableBrick()
  $('#page_page_type').change ->
    checkPageType()

