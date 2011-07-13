$(function(){
  function updateSortable(event, ui){
    var self = $(ui.item),
          prev = $(self.prevAll('.can-drag')[0]),
          id   = prev.length > 0 ? prev.data('id') : ''
      $.post(self.data('put-url'), {reposition:id, _method: 'put'})
  }
  
  $("ul.sortable").sortable({
    containment: 'parent',
    update: updateSortable
  })
  
  $(".page-part-list").sortable({
    items: '.draggable-box',
    opacity: 0.3,
    containment: 'parent',
    handle: '.drag-handler',
    update: updateSortable
  })
  
  $(".page-part-list .drag-handler").mouseenter(function(){
    $(this).parent().parent().addClass("will-drag")
  })
  .mouseleave(function(){
    $(this).parent().parent().removeClass("will-drag")
  })
  $(".draggable-box").mouseleave(function(){
    $(this).removeClass("will-drag")
  })
  
  $('.colored-box textarea.text').elastic();
  
})