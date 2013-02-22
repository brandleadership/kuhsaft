sortableBrick = ->
  $(".brick-list").each (idx, elem) ->
    $(elem).sortable(
      handle: '.brick-item-header',
      axis: "y",
      update: (event, ui) ->
         $(this).find(".brick-item").each (idx, elem) ->
            $(this).find("input.position-field").val(idx+1)
            $(this).children('form').trigger('submit')
      )

