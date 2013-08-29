#= require bootstrap
#= require_self
#= require_tree ./views
#= require ckeditor-jquery

$ ->
  $('.kuhsaft-text-brick').each ->
    new ReadMoreView($(this))
