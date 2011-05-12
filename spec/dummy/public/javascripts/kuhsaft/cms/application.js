$(function(){
  $('.has-datepicker').datepicker({
    dateFormat: 'dd.mm.yy'
  })
  $("ul.sortable").sortable({
    containment: 'parent',
    update: function(event, ui){
      var self = $(ui.item),
          prev = self.prev(),
          id   = prev.length > 0 ? prev.data('id') : ''
      $.post(self.data('put-url'), {reposition:id, _method: 'put'})
    }
  })
})