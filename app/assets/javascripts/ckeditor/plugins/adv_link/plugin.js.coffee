###
@license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.md or http://ckeditor.com/license
###
CKEDITOR.plugins.add "adv_link",
  requires: "dialog,fakeobjects"
  lang: "en,es,fr,it" # %REMOVE_LINE_CORE%
  icons: "anchor,anchor-rtl,link,unlink" # %REMOVE_LINE_CORE%
  hidpi: true # %REMOVE_LINE_CORE%
  onLoad: ->
    cssWithDir = (dir) ->
      template.replace(/%1/g, (if dir is "rtl" then "right" else "left")).replace /%2/g, "cke_contents_" + dir
    iconPath = CKEDITOR.getUrl(@path + "images" + ((if CKEDITOR.env.hidpi then "/hidpi" else "")) + "/anchor.png")
    baseStyle = "background:url(" + iconPath + ") no-repeat %1 center;border:1px dotted #00f;background-size:16px;"
    template = ".%2 a.cke_anchor," + ".%2 a.cke_anchor_empty" + ",.cke_editable.%2 a[name]" + ",.cke_editable.%2 a[data-cke-saved-name]" + "{" + baseStyle + "padding-%1:18px;" + "cursor:auto;" + "}" + ((if CKEDITOR.env.ie then ("a.cke_anchor_empty" + "{" + "display:inline-block;" + "}") else "")) + ".%2 img.cke_anchor" + "{" + baseStyle + "width:16px;" + "min-height:15px;" + "height:1.15em;" + "vertical-align:" + ((if CKEDITOR.env.opera then "middle" else "text-bottom")) + ";" + "}"
    CKEDITOR.addCss cssWithDir("ltr") + cssWithDir("rtl")
    return

  init: (editor) ->
    allowed = "a[!href]"
    required = "a[href]"
    allowed = allowed.replace("]", ",accesskey,charset,dir,id,lang,name,rel,tabindex,title,type]{*}(*)")  if CKEDITOR.dialog.isTabEnabled(editor, "link", "advanced")
    allowed = allowed.replace("]", ",target,onclick]")  if CKEDITOR.dialog.isTabEnabled(editor, "link", "target")

    # Add the link and unlink buttons.
    editor.addCommand "link", new CKEDITOR.dialogCommand("link",
      allowedContent: allowed
      requiredContent: required
    )
    editor.addCommand "anchor", new CKEDITOR.dialogCommand("anchor",
      allowedContent: "a[!name,id]"
      requiredContent: "a[name]"
    )
    editor.addCommand "unlink", new CKEDITOR.unlinkCommand()
    editor.addCommand "removeAnchor", new CKEDITOR.removeAnchorCommand()
    editor.setKeystroke CKEDITOR.CTRL + 76, "link" #L
    if editor.ui.addButton
      editor.ui.addButton "Link",
        label: editor.lang.link.toolbar
        command: "link"
        toolbar: "links,10"

      editor.ui.addButton "Unlink",
        label: editor.lang.link.unlink
        command: "unlink"
        toolbar: "links,20"

      editor.ui.addButton "Anchor",
        label: editor.lang.link.anchor.toolbar
        command: "anchor"
        toolbar: "links,30"

    CKEDITOR.dialog.add "link", @path + "dialogs/link.js"
    CKEDITOR.dialog.add "anchor", @path + "dialogs/anchor.js"
    editor.on "doubleclick", (evt) ->
      element = CKEDITOR.plugins.link.getSelectedLink(editor) or evt.data.element
      unless element.isReadOnly()
        if element.is("a")
          evt.data.dialog = (if (element.getAttribute("name") and (not element.getAttribute("href") or not element.getChildCount())) then "anchor" else "link")
          editor.getSelection().selectElement element
        else evt.data.dialog = "anchor"  if CKEDITOR.plugins.link.tryRestoreFakeAnchor(editor, element)
      return

    # If the "menu" plugin is loaded, register the menu items.
    if editor.addMenuItems
      editor.addMenuItems
        anchor:
          label: editor.lang.link.anchor.menu
          command: "anchor"
          group: "anchor"
          order: 1

        removeAnchor:
          label: editor.lang.link.anchor.remove
          command: "removeAnchor"
          group: "anchor"
          order: 5

        link:
          label: editor.lang.link.menu
          command: "link"
          group: "link"
          order: 1

        unlink:
          label: editor.lang.link.unlink
          command: "unlink"
          group: "link"
          order: 5

    # If the "contextmenu" plugin is loaded, register the listeners.
    if editor.contextMenu
      editor.contextMenu.addListener (element, selection) ->
        return null  if not element or element.isReadOnly()
        anchor = CKEDITOR.plugins.link.tryRestoreFakeAnchor(editor, element)
        return null  if not anchor and not (anchor = CKEDITOR.plugins.link.getSelectedLink(editor))
        menu = {}
        if anchor.getAttribute("href") and anchor.getChildCount()
          menu =
            link: CKEDITOR.TRISTATE_OFF
            unlink: CKEDITOR.TRISTATE_OFF
        menu.anchor = menu.removeAnchor = CKEDITOR.TRISTATE_OFF  if anchor and anchor.hasAttribute("name")
        menu

    return

  afterInit: (editor) ->
    # Register a filter to displaying placeholders after mode change.
    dataProcessor = editor.dataProcessor
    dataFilter = dataProcessor and dataProcessor.dataFilter
    htmlFilter = dataProcessor and dataProcessor.htmlFilter
    pathFilters = editor._.elementsPath and editor._.elementsPath.filters
    if dataFilter
      dataFilter.addRules elements:
        a: (element) ->
          attributes = element.attributes
          return null  unless attributes.name
          isEmpty = not element.children.length
          if CKEDITOR.plugins.link.synAnchorSelector

            # IE needs a specific class name to be applied
            # to the anchors, for appropriate styling.
            ieClass = (if isEmpty then "cke_anchor_empty" else "cke_anchor")
            cls = attributes["class"]
            attributes["class"] = (cls or "") + " " + ieClass  if attributes.name and (not cls or cls.indexOf(ieClass) < 0)
            if isEmpty and CKEDITOR.plugins.link.emptyAnchorFix
              attributes.contenteditable = "false"
              attributes["data-cke-editable"] = 1
          else return editor.createFakeParserElement(element, "cke_anchor", "anchor")  if CKEDITOR.plugins.link.fakeAnchor and isEmpty
          null

    if CKEDITOR.plugins.link.emptyAnchorFix and htmlFilter
      htmlFilter.addRules elements:
        a: (element) ->
          delete element.attributes.contenteditable

          return

    if pathFilters
      pathFilters.push (element, name) ->
        "anchor"  if CKEDITOR.plugins.link.tryRestoreFakeAnchor(editor, element) or (element.getAttribute("name") and (not element.getAttribute("href") or not element.getChildCount()))  if name is "a"

    return

###
Set of link plugin's helpers.

@class
@singleton
###
CKEDITOR.plugins.link =

  ###
  Get the surrounding link element of current selection.

  CKEDITOR.plugins.link.getSelectedLink( editor );

  // The following selection will all return the link element.

  <a href="#">li^nk</a>
  <a href="#">[link]</a>
  text[<a href="#">link]</a>
  <a href="#">li[nk</a>]
  [<b><a href="#">li]nk</a></b>]
  [<a href="#"><b>li]nk</b></a>

  @since 3.2.1
  @param {CKEDITOR.editor} editor
  ###
  getSelectedLink: (editor) ->
    selection = editor.getSelection()
    selectedElement = selection.getSelectedElement()
    return selectedElement  if selectedElement and selectedElement.is("a")
    range = selection.getRanges(true)[0]
    if range
      range.shrink CKEDITOR.SHRINK_TEXT
      return editor.elementPath(range.getCommonAncestor()).contains("a", 1)
    null

  ###
  Opera and WebKit don't make it possible to select empty anchors. Fake
  elements must be used for them.

  @readonly
  @property {Boolean}
  ###
  fakeAnchor: CKEDITOR.env.opera or CKEDITOR.env.webkit

  ###
  For browsers that don't support CSS3 `a[name]:empty()`, note IE9 is included because of #7783.

  @readonly
  @property {Boolean}
  ###
  synAnchorSelector: CKEDITOR.env.ie

  ###
  For browsers that have editing issue with empty anchor.

  @readonly
  @property {Boolean}
  ###
  emptyAnchorFix: CKEDITOR.env.ie and CKEDITOR.env.version < 8

  ###
  @param {CKEDITOR.editor} editor
  @param {CKEDITOR.dom.element} element
  @todo
  ###
  tryRestoreFakeAnchor: (editor, element) ->
    if element and element.data("cke-real-element-type") and element.data("cke-real-element-type") is "anchor"
      link = editor.restoreRealElement(element)
      link  if link.data("cke-saved-name")


# TODO Much probably there's no need to expose these as public objects.
CKEDITOR.unlinkCommand = ->

CKEDITOR.unlinkCommand:: =
  exec: (editor) ->
    style = new CKEDITOR.style(
      element: "a"
      type: CKEDITOR.STYLE_INLINE
      alwaysRemoveElement: 1
    )
    editor.removeStyle style
    return

  refresh: (editor, path) ->

    # Despite our initial hope, document.queryCommandEnabled() does not work
    # for this in Firefox. So we must detect the state by element paths.
    element = path.lastElement and path.lastElement.getAscendant("a", true)
    if element and element.getName() is "a" and element.getAttribute("href") and element.getChildCount()
      @setState CKEDITOR.TRISTATE_OFF
    else
      @setState CKEDITOR.TRISTATE_DISABLED
    return

  contextSensitive: 1
  startDisabled: 1
  requiredContent: "a[href]"

CKEDITOR.removeAnchorCommand = ->

CKEDITOR.removeAnchorCommand:: =
  exec: (editor) ->
    sel = editor.getSelection()
    bms = sel.createBookmarks()
    anchor = undefined
    if sel and (anchor = sel.getSelectedElement()) and ((if CKEDITOR.plugins.link.fakeAnchor and not anchor.getChildCount() then CKEDITOR.plugins.link.tryRestoreFakeAnchor(editor, anchor) else anchor.is("a")))
      anchor.remove 1
    else
      if anchor = CKEDITOR.plugins.link.getSelectedLink(editor)
        if anchor.hasAttribute("href")
          anchor.removeAttributes
            name: 1
            "data-cke-saved-name": 1

          anchor.removeClass "cke_anchor"
        else
          anchor.remove 1
    sel.selectBookmarks bms
    return

  requiredContent: "a[name]"

CKEDITOR.tools.extend CKEDITOR.config,

  ###
  @cfg {Boolean} [linkShowAdvancedTab=true]
  @member CKEDITOR.config
  @todo
  ###
  linkShowAdvancedTab: true

  ###
  @cfg {Boolean} [linkShowTargetTab=true]
  @member CKEDITOR.config
  @todo
  ###
  linkShowTargetTab: true
