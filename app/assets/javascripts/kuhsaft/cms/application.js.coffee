# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require bootstrap
#= require ckeditor/init
#= require_tree .

loadTextEditor = ->
  CKEDITOR.replaceAll('editor')

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
        idList = $(this).find("> .brick-item")
          .each (idx, elem) ->
            $(this).find("input.position-field").val(idx+1)
          .map ->
            $(this).data('id')

        sortForm = $('#bricks-sort-form form')
        sortForm.find('input[name="bricks[ids]"]').val(idList.toArray().join(','))
        sortForm.trigger('submit')
      )

window.initSubmitLinks = (selector = null)->
  selector ||= $('body')

  selector.find('a.submit')
    .click (e)->
      form = $(this).closest('form')

      form.find('.editor').each (index, elem) ->
        CKEDITOR.instances[elem.id].updateElement()

      form.submit()
      e.preventDefault()

window.initSavePopover = (selector) ->
  link = selector.find('a.submit')
  link.popover(placement: 'top', trigger: 'manual')

  # initial delay
  setTimeout ->
    link.popover('show')
    # fade out delay
    setTimeout ->
      link.popover('hide')
    , 1500
  , 50

window.initCKEditor = (selector) ->
  CKEDITOR.replace(selector)

$(document).ajaxSuccess ->
  sortableBrick()

$(document).ready ->
  loadTextEditor()
  checkPageType()
  sortableBrick()
  initSubmitLinks()

  $('#page_page_type').change ->
    checkPageType()
