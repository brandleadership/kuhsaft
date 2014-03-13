#
# Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
# For licensing, see LICENSE.md or http://ckeditor.com/license
#
CKEDITOR.dialog.add "anchor", (c) ->
  d = (a) ->
    @_.selectedElement = a
    @setValueOf "info", "txtName", a.data("cke-saved-name") or ""
    return

  title: c.lang.link.anchor.title
  minWidth: 300
  minHeight: 60
  onOk: ->
    a = CKEDITOR.tools.trim(@getValueOf("info", "txtName"))
    a =
      id: a
      name: a
      "data-cke-saved-name": a

    if @_.selectedElement
      (if @_.selectedElement.data("cke-realelement") then (a = c.document.createElement("a",
        attributes: a
      )
      c.createFakeElement(a, "cke_anchor", "anchor").replace(@_.selectedElement)
      ) else @_.selectedElement.setAttributes(a))
    else
      b = c.getSelection()
      b = b and b.getRanges()[0]
      (if b.collapsed then (CKEDITOR.plugins.link.synAnchorSelector and (a["class"] = "cke_anchor_empty")
      CKEDITOR.plugins.link.emptyAnchorFix and (a.contenteditable = "false"
      a["data-cke-editable"] = 1
      )
      a = c.document.createElement("a",
        attributes: a
      )
      CKEDITOR.plugins.link.fakeAnchor and (a = c.createFakeElement(a, "cke_anchor", "anchor"))
      b.insertNode(a)
      ) else (CKEDITOR.env.ie and 9 > CKEDITOR.env.version and (a["class"] = "cke_anchor")
      a = new CKEDITOR.style(
        element: "a"
        attributes: a
      )
      a.type = CKEDITOR.STYLE_INLINE
      c.applyStyle(a)
      ))
    return

  onHide: ->
    delete @_.selectedElement

    return

  onShow: ->
    a = c.getSelection()
    b = a.getSelectedElement()
    if b
      (if CKEDITOR.plugins.link.fakeAnchor then ((a = CKEDITOR.plugins.link.tryRestoreFakeAnchor(c, b)) and d.call(this, a)
      @_.selectedElement = b
      ) else b.is("a") and b.hasAttribute("name") and d.call(this, b))
    else if b = CKEDITOR.plugins.link.getSelectedLink(c)
      d.call(this, b)
      a.selectElement(b)
    @getContentElement("info", "txtName").focus()
    return

  contents: [
    id: "info"
    label: c.lang.link.anchor.title
    accessKey: "I"
    elements: [
      type: "text"
      id: "txtName"
      label: c.lang.link.anchor.name
      required: not 0
      validate: ->
        (if not @getValue() then (alert(c.lang.link.anchor.errorName)
        not 1
        ) else not 0)
    ]
  ]
