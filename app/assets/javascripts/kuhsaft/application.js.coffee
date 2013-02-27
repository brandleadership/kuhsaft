#= require bootstrap
#= require_self
#= require_tree ./views

$ ->
  $('.kuhsaft-text-brick').each ->
    new ReadMoreView($(this))
