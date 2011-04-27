$(function(){
  $('.has-datepicker').datepicker({
    dateFormat: 'dd.mm.yy'
  })
  $("ul.sortable").sortable({
    containment: 'parent',
    update: function(event, ui){
      var self = $(ui.item),
          prev = self.prev(),
          id   = prev.length > 0 ? prev.data('id') : '',
          sid  = self.data('id'),
          p    = window.location.pathname
          path = p[p.length-1] == '/' ? p : p + '/'
      $.post(path, {reposition:id, _method: 'put'})
    }
  })
})