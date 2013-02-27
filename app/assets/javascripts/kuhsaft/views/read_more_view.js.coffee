class window.ReadMoreView

  constructor: (readMoreElem)->
    @readMoreElem = readMoreElem
    @readMoreElem.on 'show', @handleShow
    @readMoreElem.on 'hide', @handleClose
    @readMoreElem.find('.button-read-more').on 'click', @handleClick

  handleShow: (e) =>
    @readMoreElem.addClass('is-open')

  handleClose: (e) =>
    @readMoreElem.removeClass('is-open')

  handleClick: (e) =>
    if e.preventDefault
      e.preventDefault()
