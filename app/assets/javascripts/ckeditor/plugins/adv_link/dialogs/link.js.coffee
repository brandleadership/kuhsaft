###
@license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.md or http://ckeditor.com/license
###

#
# Function to get current content locale
#
getParameterByName = (name, href) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regexS = "[\\?&]" + name + "=([^&#]*)"
  regex = new RegExp(regexS)
  results = regex.exec(href)
  unless results?
    ""
  else
    decodeURIComponent results[1].replace(/\+/g, " ")

CKEDITOR.dialog.add "link", (editor) ->

  unescapeSingleQuote = (str) ->
    str.replace /\\'/g, "'"

  escapeSingleQuote = (str) ->
    str.replace /'/g, "\\$&"

  # Compile the protection function pattern.
  protectEmailLinkAsFunction = (email) ->
    retval = undefined
    name = compiledProtectionFunction.name
    params = compiledProtectionFunction.params
    paramName = undefined
    paramValue = undefined
    retval = [
      name
      "("
    ]
    i = 0

    while i < params.length
      paramName = params[i].toLowerCase()
      paramValue = email[paramName]
      i > 0 and retval.push(",")
      retval.push "'", (if paramValue then escapeSingleQuote(encodeURIComponent(email[paramName])) else ""), "'"
      i++
    retval.push ")"
    retval.join ""

  protectEmailAddressAsEncodedString = (address) ->
    charCode = undefined
    length = address.length
    encodedChars = []
    i = 0

    while i < length
      charCode = address.charCodeAt(i)
      encodedChars.push charCode
      i++
    "String.fromCharCode(" + encodedChars.join(",") + ")"

  getLinkClass = (ele) ->
    className = ele.getAttribute("class")
    (if className then className.replace(/\s*(?:cke_anchor_empty|cke_anchor)(?:\s*$)?/g, "") else "")

  plugin = CKEDITOR.plugins.link

  targetChanged = ->
    dialog = @getDialog()
    popupFeatures = dialog.getContentElement("target", "popupFeatures")
    targetName = dialog.getContentElement("target", "linkTargetName")
    value = @getValue()
    return  if not popupFeatures or not targetName
    popupFeatures = popupFeatures.getElement()
    popupFeatures.hide()
    targetName.setValue ""
    switch value
      when "frame"
        targetName.setLabel editor.lang.link.targetFrameName
        targetName.getElement().show()
      when "popup"
        popupFeatures.show()
        targetName.setLabel editor.lang.link.targetPopupName
        targetName.getElement().show()
      else
        targetName.setValue value
        targetName.getElement().hide()

  # Handles the event when the "Target" selection box is changed.
  linkTypeChanged = ->
    dialog = @getDialog()
    partIds = [
      "urlOptions"
      "localPageOptions"
      "anchorOptions"
      "emailOptions"
    ]
    typeValue = @getValue()
    uploadTab = dialog.definition.getContents("upload")
    uploadInitiallyHidden = uploadTab and uploadTab.hidden
    if typeValue is "url"
      dialog.showPage "target"  if editor.config.linkShowTargetTab
      dialog.showPage "upload"  unless uploadInitiallyHidden
    else
      dialog.hidePage "target"
      dialog.hidePage "upload"  unless uploadInitiallyHidden
    i = 0

    while i < partIds.length
      element = dialog.getContentElement("info", partIds[i])
      continue  unless element
      element = element.getElement().getParent().getParent()
      if partIds[i] is typeValue + "Options"
        element.show()
      else
        element.hide()
      i++
    dialog.layout()
    return

  javascriptProtocolRegex = /^javascript:/
  emailRegex = /^mailto:([^?]+)(?:\?(.+))?$/
  emailSubjectRegex = /subject=([^;?:@&=$,\/]*)/
  emailBodyRegex = /body=([^;?:@&=$,\/]*)/
  anchorRegex = /^#(.*)$/
  urlRegex = /^((?:http|https|ftp|news):\/\/)?(.*)$/
  selectableTargets = /^(_(?:self|top|parent|blank))$/
  encodedEmailLinkRegex = /^javascript:void\(location\.href='mailto:'\+String\.fromCharCode\(([^)]+)\)(?:\+'(.*)')?\)$/
  functionCallProtectedEmailLinkRegex = /^javascript:([^(]+)\(([^)]+)\)$/
  popupRegex = /\s*window.open\(\s*this\.href\s*,\s*(?:'([^']*)'|null)\s*,\s*'([^']*)'\s*\)\s*;\s*return\s*false;*\s*/
  popupFeaturesRegex = /(?:^|,)([^=]+)=(\d+|yes|no)/g
  parseLink = (editor, element) ->
    href = (element and (element.data("cke-saved-href") or element.getAttribute("href"))) or ""
    javascriptMatch = undefined
    emailMatch = undefined
    anchorMatch = undefined
    urlMatch = undefined
    retval = {}
    if javascriptMatch = href.match(javascriptProtocolRegex)
      if emailProtection is "encode"
        href = href.replace(encodedEmailLinkRegex, (match, protectedAddress, rest) ->
          "mailto:" + String.fromCharCode.apply(String, protectedAddress.split(",")) + (rest and unescapeSingleQuote(rest))
        )
      else if emailProtection
        href.replace functionCallProtectedEmailLinkRegex, (match, funcName, funcArgs) ->
          if funcName is compiledProtectionFunction.name
            retval.type = "email"
            email = retval.email = {}
            paramRegex = /[^,\s]+/g
            paramQuoteRegex = /(^')|('$)/g
            paramsMatch = funcArgs.match(paramRegex)
            paramsMatchLength = paramsMatch.length
            paramName = undefined
            paramVal = undefined
            i = 0

            while i < paramsMatchLength
              paramVal = decodeURIComponent(unescapeSingleQuote(paramsMatch[i].replace(paramQuoteRegex, "")))
              paramName = compiledProtectionFunction.params[i].toLowerCase()
              email[paramName] = paramVal
              i++
            email.address = [
              email.name
              email.domain
            ].join("@")
          return

    unless retval.type
      if anchorMatch = href.match(anchorRegex)
        retval.type = "anchor"
        retval.anchor = {}
        retval.anchor.name = retval.anchor.id = anchorMatch[1]
      else if emailMatch = href.match(emailRegex)
        subjectMatch = href.match(emailSubjectRegex)
        bodyMatch = href.match(emailBodyRegex)
        retval.type = "email"
        email = (retval.email = {})
        email.address = emailMatch[1]
        subjectMatch and (email.subject = decodeURIComponent(subjectMatch[1]))
        bodyMatch and (email.body = decodeURIComponent(bodyMatch[1]))
      else if href and (urlMatch = href.match(urlRegex))
        retval.type = "url"
        retval.url = {}
        retval.url.protocol = urlMatch[1]
        retval.url.url = urlMatch[2]
      else
        retval.type = "url"
    if element
      target = element.getAttribute("target")
      retval.target = {}
      retval.adv = {}
      unless target
        onclick = element.data("cke-pa-onclick") or element.getAttribute("onclick")
        onclickMatch = onclick and onclick.match(popupRegex)
        if onclickMatch
          retval.target.type = "popup"
          retval.target.name = onclickMatch[1]
          featureMatch = undefined
          while (featureMatch = popupFeaturesRegex.exec(onclickMatch[2]))
            if (featureMatch[2] is "yes" or featureMatch[2] is "1") and (featureMatch[1] of
              height: 1
              width: 1
              top: 1
              left: 1
            )
              retval.target[featureMatch[1]] = true
            else retval.target[featureMatch[1]] = featureMatch[2]  if isFinite(featureMatch[2])
      else
        targetMatch = target.match(selectableTargets)
        if targetMatch
          retval.target.type = retval.target.name = target
        else
          retval.target.type = "frame"
          retval.target.name = target
      me = this
      advAttr = (inputName, attrName) ->
        value = element.getAttribute(attrName)
        retval.adv[inputName] = value or ""  if value isnt null
        return

      advAttr "advId", "id"
      advAttr "advLangDir", "dir"
      advAttr "advAccessKey", "accessKey"
      retval.adv.advName = element.data("cke-saved-name") or element.getAttribute("name") or ""
      advAttr "advLangCode", "lang"
      advAttr "advTabIndex", "tabindex"
      advAttr "advTitle", "title"
      advAttr "advContentType", "type"
      (if CKEDITOR.plugins.link.synAnchorSelector then retval.adv.advCSSClasses = getLinkClass(element) else advAttr("advCSSClasses", "class"))
      advAttr "advCharset", "charset"
      advAttr "advStyles", "style"
      advAttr "advRel", "rel"
    anchors = retval.anchors = []
    i = undefined
    count = undefined
    item = undefined
    if CKEDITOR.plugins.link.emptyAnchorFix
      links = editor.document.getElementsByTag("a")
      i = 0
      count = links.count()

      while i < count
        item = links.getItem(i)
        if item.data("cke-saved-name") or item.hasAttribute("name")
          anchors.push
            name: item.data("cke-saved-name") or item.getAttribute("name")
            id: item.getAttribute("id")

        i++
    else
      anchorList = new CKEDITOR.dom.nodeList(editor.document.$.anchors)
      i = 0
      count = anchorList.count()

      while i < count
        item = anchorList.getItem(i)
        anchors[i] =
          name: item.getAttribute("name")
          id: item.getAttribute("id")
        i++
    if CKEDITOR.plugins.link.fakeAnchor
      imgs = editor.document.getElementsByTag("img")
      i = 0
      count = imgs.count()

      while i < count
        if item = CKEDITOR.plugins.link.tryRestoreFakeAnchor(editor, imgs.getItem(i))
          anchors.push
            name: item.getAttribute("name")
            id: item.getAttribute("id")

        i++
    @_.selectedElement = element
    retval

  setupParams = (page, data) ->
    @setValue data[page][@id] or ""  if data[page]
    return

  setupPopupParams = (data) ->
    setupParams.call this, "target", data

  setupAdvParams = (data) ->
    setupParams.call this, "adv", data

  commitParams = (page, data) ->
    data[page] = {}  unless data[page]
    data[page][@id] = @getValue() or ""
    return

  commitPopupParams = (data) ->
    commitParams.call this, "target", data

  commitAdvParams = (data) ->
    commitParams.call this, "adv", data

  emailProtection = editor.config.emailProtection or ""
  if emailProtection and emailProtection isnt "encode"
    compiledProtectionFunction = {}
    emailProtection.replace /^([^(]+)\(([^)]+)\)$/, (match, funcName, params) ->
      compiledProtectionFunction.name = funcName
      compiledProtectionFunction.params = []
      params.replace /[^,\s]+/g, (param) ->
        compiledProtectionFunction.params.push param
        return

      return

  commonLang = editor.lang.common
  linkLang = editor.lang.adv_link # modified by simo
  title: linkLang.title
  minWidth: 350
  minHeight: 230
  contents: [
    {
      id: "info"
      label: linkLang.info
      title: linkLang.info
      elements: [
        {
          id: "linkType"
          type: "select"
          label: linkLang.type
          default: "url"
          items: [
            [
              linkLang.toUrl
              "url"
            ]
            [ # added by @simo - http://blog.xoundboy.com/?p=393
              linkLang.localPages
              "localPage"
            ]
            [
              linkLang.toAnchor
              "anchor"
            ]
            [
              linkLang.toEmail
              "email"
            ]
          ]
          onChange: linkTypeChanged
          setup: (data) ->
            @setValue data.type  if data.type
            return

          commit: (data) ->
            data.type = @getValue()
            return
        }
        {

          # added by @simo - http://blog.xoundboy.com/?p=393
          # see also :   http://docs.ckeditor.com/source/dialogDefinition.html#CKEDITOR-dialog-definition-uiElement-property-type
          #        http://docs.ckeditor.com/#!/guide/plugin_sdk_sample_1
          type: "vbox"
          id: "localPageOptions"
          children: [
            type: "select"
            label: linkLang.selectPageLabel
            id: "localPage"
            title: linkLang.selectPageTitle

            # items: eval(decodeURIComponent(document.getElementById("pageListJSON").value)),
            items: []
            onLoad: (element) ->
              element_id = "#" + @getInputElement().$.id

              # ajax call indpired from http://stackoverflow.com/questions/5293920/ckeditor-dynamic-select-in-a-dialog
              $.ajax
                type: "GET"

                #contentType: 'application/json; charset=utf-8',
                url: "/" + getParameterByName("content_locale", document.location.href) + "/api/pages.json"
                dataType: "json"
                async: false
                success: (data) ->
                  $.each data, (index, item) ->
                    $(element_id).get(0).options[$(element_id).get(0).options.length] = new Option(decodeURIComponent(item.title), item.url)
                    return

                  return

                error: (xhr, ajaxOptions, thrownError) ->
                  alert xhr.status
                  alert thrownError
                  return

              return

            commit: (data) ->
              data.localPage = {}  unless data.localPage
              data.localPage = @getValue()
              return
          ]
        }
        {

          # added by @simo - end
          type: "vbox"
          id: "urlOptions"
          children: [
            {
              type: "hbox"
              widths: [
                "25%"
                "75%"
              ]
              children: [
                {
                  id: "protocol"
                  type: "select"
                  label: commonLang.protocol
                  default: "http://"
                  items: [

                    # Force 'ltr' for protocol names in BIDI. (#5433)
                    [
                      "http://‎"
                      "http://"
                    ]
                    [
                      "https://‎"
                      "https://"
                    ]
                    [
                      "ftp://‎"
                      "ftp://"
                    ]
                    [
                      "news://‎"
                      "news://"
                    ]
                    [
                      linkLang.other
                      ""
                    ]
                  ]
                  setup: (data) ->
                    @setValue data.url.protocol or ""  if data.url
                    return

                  commit: (data) ->
                    data.url = {}  unless data.url
                    data.url.protocol = @getValue()
                    return
                }
                {
                  type: "text"
                  id: "url"
                  label: commonLang.url
                  required: true
                  onLoad: ->
                    @allowOnChange = true
                    return

                  onKeyUp: ->
                    @allowOnChange = false
                    protocolCmb = @getDialog().getContentElement("info", "protocol")
                    url = @getValue()
                    urlOnChangeProtocol = /^(http|https|ftp|news):\/\/(?=.)/i
                    urlOnChangeTestOther = /^((javascript:)|[#\/\.\?])/i
                    protocol = urlOnChangeProtocol.exec(url)
                    if protocol
                      @setValue url.substr(protocol[0].length)
                      protocolCmb.setValue protocol[0].toLowerCase()
                    else protocolCmb.setValue ""  if urlOnChangeTestOther.test(url)
                    @allowOnChange = true
                    return

                  onChange: ->
                    # Dont't call on dialog load.
                    @onKeyUp()  if @allowOnChange
                    return

                  validate: ->
                    dialog = @getDialog()
                    return true  if dialog.getContentElement("info", "linkType") and dialog.getValueOf("info", "linkType") isnt "url"
                    if (/javascript\:/).test(@getValue())
                      alert commonLang.invalidValue
                      return false
                    # Edit Anchor.
                    return true  if @getDialog().fakeObj
                    func = CKEDITOR.dialog.validate.notEmpty(linkLang.noUrl)
                    func.apply this

                  setup: (data) ->
                    @allowOnChange = false
                    @setValue data.url.url  if data.url
                    @allowOnChange = true
                    return

                  commit: (data) ->

                    # IE will not trigger the onChange event if the mouse has been used
                    # to carry all the operations #4724
                    @onChange()
                    data.url = {}  unless data.url
                    data.url.url = @getValue()
                    @allowOnChange = false
                    return
                }
              ]
              setup: (data) ->
                @getElement().show()  unless @getDialog().getContentElement("info", "linkType")
                return
            }
            {
              type: "button"
              id: "browse"
              hidden: "true"
              filebrowser: "info:url"
              label: commonLang.browseServer
            }
          ]
        }
        {
          type: "vbox"
          id: "anchorOptions"
          width: 260
          align: "center"
          padding: 0
          children: [
            {
              type: "fieldset"
              id: "selectAnchorText"
              label: linkLang.selectAnchor
              setup: (data) ->
                if data.anchors.length > 0
                  @getElement().show()
                else
                  @getElement().hide()
                return

              children: [
                type: "hbox"
                id: "selectAnchor"
                children: [
                  {
                    type: "select"
                    id: "anchorName"
                    default: ""
                    label: linkLang.anchorName
                    style: "width: 100%;"
                    items: [[""]]
                    setup: (data) ->
                      @clear()
                      @add ""
                      i = 0

                      while i < data.anchors.length
                        @add data.anchors[i].name  if data.anchors[i].name
                        i++
                      @setValue data.anchor.name  if data.anchor
                      linkType = @getDialog().getContentElement("info", "linkType")
                      @focus()  if linkType and linkType.getValue() is "email"
                      return

                    commit: (data) ->
                      data.anchor = {}  unless data.anchor
                      data.anchor.name = @getValue()
                      return
                  }
                  {
                    type: "select"
                    id: "anchorId"
                    default: ""
                    label: linkLang.anchorId
                    style: "width: 100%;"
                    items: [[""]]
                    setup: (data) ->
                      @clear()
                      @add ""
                      i = 0

                      while i < data.anchors.length
                        @add data.anchors[i].id  if data.anchors[i].id
                        i++
                      @setValue data.anchor.id  if data.anchor
                      return

                    commit: (data) ->
                      data.anchor = {}  unless data.anchor
                      data.anchor.id = @getValue()
                      return
                  }
                ]
                setup: (data) ->
                  if data.anchors.length > 0
                    @getElement().show()
                  else
                    @getElement().hide()
                  return
              ]
            }
            {
              type: "html"
              id: "noAnchors"
              style: "text-align: center;"
              html: "<div role=\"note\" tabIndex=\"-1\">" + CKEDITOR.tools.htmlEncode(linkLang.noAnchors) + "</div>"

              # Focus the first element defined in above html.
              focus: true
              setup: (data) ->
                if data.anchors.length < 1
                  @getElement().show()
                else
                  @getElement().hide()
                return
            }
          ]
          setup: (data) ->
            @getElement().hide()  unless @getDialog().getContentElement("info", "linkType")
            return
        }
        {
          type: "vbox"
          id: "emailOptions"
          padding: 1
          children: [
            {
              type: "text"
              id: "emailAddress"
              label: linkLang.emailAddress
              required: true
              validate: ->
                dialog = @getDialog()
                return true  if not dialog.getContentElement("info", "linkType") or dialog.getValueOf("info", "linkType") isnt "email"
                func = CKEDITOR.dialog.validate.notEmpty(linkLang.noEmail)
                func.apply this

              setup: (data) ->
                @setValue data.email.address  if data.email
                linkType = @getDialog().getContentElement("info", "linkType")
                @select()  if linkType and linkType.getValue() is "email"
                return

              commit: (data) ->
                data.email = {}  unless data.email
                data.email.address = @getValue()
                return
            }
            {
              type: "text"
              id: "emailSubject"
              label: linkLang.emailSubject
              setup: (data) ->
                @setValue data.email.subject  if data.email
                return

              commit: (data) ->
                data.email = {}  unless data.email
                data.email.subject = @getValue()
                return
            }
            {
              type: "textarea"
              id: "emailBody"
              label: linkLang.emailBody
              rows: 3
              default: ""
              setup: (data) ->
                @setValue data.email.body  if data.email
                return

              commit: (data) ->
                data.email = {}  unless data.email
                data.email.body = @getValue()
                return
            }
          ]
          setup: (data) ->
            @getElement().hide()  unless @getDialog().getContentElement("info", "linkType")
            return
        }
      ]
    }
    {
      id: "target"
      requiredContent: "a[target]" # This is not fully correct, because some target option requires JS.
      label: linkLang.target
      title: linkLang.target
      elements: [
        {
          type: "hbox"
          widths: [
            "50%"
            "50%"
          ]
          children: [
            {
              type: "select"
              id: "linkTargetType"
              label: commonLang.target
              default: "notSet"
              style: "width : 100%;"
              items: [
                [
                  commonLang.notSet
                  "notSet"
                ]
                [
                  linkLang.targetFrame
                  "frame"
                ]
                [
                  linkLang.targetPopup
                  "popup"
                ]
                [
                  commonLang.targetNew
                  "_blank"
                ]
                [
                  commonLang.targetTop
                  "_top"
                ]
                [
                  commonLang.targetSelf
                  "_self"
                ]
                [
                  commonLang.targetParent
                  "_parent"
                ]
              ]
              onChange: targetChanged
              setup: (data) ->
                @setValue data.target.type or "notSet"  if data.target
                targetChanged.call this
                return

              commit: (data) ->
                data.target = {}  unless data.target
                data.target.type = @getValue()
                return
            }
            {
              type: "text"
              id: "linkTargetName"
              label: linkLang.targetFrameName
              default: ""
              setup: (data) ->
                @setValue data.target.name  if data.target
                return

              commit: (data) ->
                data.target = {}  unless data.target
                data.target.name = @getValue().replace(/\W/g, "")
                return
            }
          ]
        }
        {
          type: "vbox"
          width: "100%"
          align: "center"
          padding: 2
          id: "popupFeatures"
          children: [
            type: "fieldset"
            label: linkLang.popupFeatures
            children: [
              {
                type: "hbox"
                children: [
                  {
                    type: "checkbox"
                    id: "resizable"
                    label: linkLang.popupResizable
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                  {
                    type: "checkbox"
                    id: "status"
                    label: linkLang.popupStatusBar
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                ]
              }
              {
                type: "hbox"
                children: [
                  {
                    type: "checkbox"
                    id: "location"
                    label: linkLang.popupLocationBar
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                  {
                    type: "checkbox"
                    id: "toolbar"
                    label: linkLang.popupToolbar
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                ]
              }
              {
                type: "hbox"
                children: [
                  {
                    type: "checkbox"
                    id: "menubar"
                    label: linkLang.popupMenuBar
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                  {
                    type: "checkbox"
                    id: "fullscreen"
                    label: linkLang.popupFullScreen
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                ]
              }
              {
                type: "hbox"
                children: [
                  {
                    type: "checkbox"
                    id: "scrollbars"
                    label: linkLang.popupScrollBars
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                  {
                    type: "checkbox"
                    id: "dependent"
                    label: linkLang.popupDependent
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                ]
              }
              {
                type: "hbox"
                children: [
                  {
                    type: "text"
                    widths: [
                      "50%"
                      "50%"
                    ]
                    labelLayout: "horizontal"
                    label: commonLang.width
                    id: "width"
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                  {
                    type: "text"
                    labelLayout: "horizontal"
                    widths: [
                      "50%"
                      "50%"
                    ]
                    label: linkLang.popupLeft
                    id: "left"
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                ]
              }
              {
                type: "hbox"
                children: [
                  {
                    type: "text"
                    labelLayout: "horizontal"
                    widths: [
                      "50%"
                      "50%"
                    ]
                    label: commonLang.height
                    id: "height"
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                  {
                    type: "text"
                    labelLayout: "horizontal"
                    label: linkLang.popupTop
                    widths: [
                      "50%"
                      "50%"
                    ]
                    id: "top"
                    setup: setupPopupParams
                    commit: commitPopupParams
                  }
                ]
              }
            ]
          ]
        }
      ]
    }
    {
      id: "upload"
      label: linkLang.upload
      title: linkLang.upload
      hidden: true
      filebrowser: "uploadButton"
      elements: [
        {
          type: "file"
          id: "upload"
          label: commonLang.upload
          style: "height:40px"
          size: 29
        }
        {
          type: "fileButton"
          id: "uploadButton"
          label: commonLang.uploadSubmit
          filebrowser: "info:url"
          for: [
            "upload"
            "upload"
          ]
        }
      ]
    }
    {
      id: "advanced"
      label: linkLang.advanced
      title: linkLang.advanced
      elements: [
        {
          type: "vbox"
          padding: 1
          children: [
            {
              type: "hbox"
              widths: [
                "45%"
                "35%"
                "20%"
              ]
              children: [
                {
                  type: "text"
                  id: "advId"
                  requiredContent: "a[id]"
                  label: linkLang.id
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "select"
                  id: "advLangDir"
                  requiredContent: "a[dir]"
                  label: linkLang.langDir
                  default: ""
                  style: "width:110px"
                  items: [
                    [
                      commonLang.notSet
                      ""
                    ]
                    [
                      linkLang.langDirLTR
                      "ltr"
                    ]
                    [
                      linkLang.langDirRTL
                      "rtl"
                    ]
                  ]
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "text"
                  id: "advAccessKey"
                  requiredContent: "a[accesskey]"
                  width: "80px"
                  label: linkLang.acccessKey
                  maxLength: 1
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
              ]
            }
            {
              type: "hbox"
              widths: [
                "45%"
                "35%"
                "20%"
              ]
              children: [
                {
                  type: "text"
                  label: linkLang.name
                  id: "advName"
                  requiredContent: "a[name]"
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "text"
                  label: linkLang.langCode
                  id: "advLangCode"
                  requiredContent: "a[lang]"
                  width: "110px"
                  default: ""
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "text"
                  label: linkLang.tabIndex
                  id: "advTabIndex"
                  requiredContent: "a[tabindex]"
                  width: "80px"
                  maxLength: 5
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
              ]
            }
          ]
        }
        {
          type: "vbox"
          padding: 1
          children: [
            {
              type: "hbox"
              widths: [
                "45%"
                "55%"
              ]
              children: [
                {
                  type: "text"
                  label: linkLang.advisoryTitle
                  requiredContent: "a[title]"
                  default: ""
                  id: "advTitle"
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "text"
                  label: linkLang.advisoryContentType
                  requiredContent: "a[type]"
                  default: ""
                  id: "advContentType"
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
              ]
            }
            {
              type: "hbox"
              widths: [
                "45%"
                "55%"
              ]
              children: [
                {
                  type: "text"
                  label: linkLang.cssClasses
                  requiredContent: "a(cke-xyz)" # Random text like 'xyz' will check if all are allowed.
                  default: ""
                  id: "advCSSClasses"
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "text"
                  label: linkLang.charset
                  requiredContent: "a[charset]"
                  default: ""
                  id: "advCharset"
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
              ]
            }
            {
              type: "hbox"
              widths: [
                "45%"
                "55%"
              ]
              children: [
                {
                  type: "text"
                  label: linkLang.rel
                  requiredContent: "a[rel]"
                  default: ""
                  id: "advRel"
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
                {
                  type: "text"
                  label: linkLang.styles
                  requiredContent: "a{cke-xyz}" # Random text like 'xyz' will check if all are allowed.
                  default: ""
                  id: "advStyles"
                  validate: CKEDITOR.dialog.validate.inlineStyle(editor.lang.common.invalidInlineStyle)
                  setup: setupAdvParams
                  commit: commitAdvParams
                }
              ]
            }
          ]
        }
      ]
    }
  ]
  onShow: ->
    editor = @getParentEditor()
    selection = editor.getSelection()
    element = null

    # Fill in all the relevant fields if there's already one link selected.
    if (element = plugin.getSelectedLink(editor)) and element.hasAttribute("href")
      selection.selectElement element
    else
      element = null
    @setupContent parseLink.apply(this, [
      editor
      element
    ])
    return

  onOk: ->
    attributes = {}
    removeAttributes = []
    data = {}
    me = this
    editor = @getParentEditor()
    @commitContent data

    # Compose the URL.
    switch data.type or "url"
      when "url"
        protocol = (if (data.url and data.url.protocol isnt `undefined`) then data.url.protocol else "http://")
        url = (data.url and CKEDITOR.tools.trim(data.url.url)) or ""
        attributes["data-cke-saved-href"] = (if (url.indexOf("/") is 0) then url else protocol + url)
      when "localPage" # added by @simo - http://blog.xoundboy.com/?p=393
        attributes["data-cke-saved-href"] = data.localPage
      when "anchor"
        name = (data.anchor and data.anchor.name)
        id = (data.anchor and data.anchor.id)
        attributes["data-cke-saved-href"] = "#" + (name or id or "")
      when "email"
        linkHref = undefined
        email = data.email
        address = email.address
        switch emailProtection
          when "", "encode"
            subject = encodeURIComponent(email.subject or "")
            body = encodeURIComponent(email.body or "")

            # Build the e-mail parameters first.
            argList = []
            subject and argList.push("subject=" + subject)
            body and argList.push("body=" + body)
            argList = (if argList.length then "?" + argList.join("&") else "")
            if emailProtection is "encode"
              linkHref = [
                "javascript:void(location.href='mailto:'+"
                protectEmailAddressAsEncodedString(address)
              ]

              # parameters are optional.
              argList and linkHref.push("+'", escapeSingleQuote(argList), "'")
              linkHref.push ")"
            else
              linkHref = [
                "mailto:"
                address
                argList
              ]
            break
          else

            # Separating name and domain.
            nameAndDomain = address.split("@", 2)
            email.name = nameAndDomain[0]
            email.domain = nameAndDomain[1]
            linkHref = [
              "javascript:"
              protectEmailLinkAsFunction(email)
            ]
        attributes["data-cke-saved-href"] = linkHref.join("")

    # Popups and target.
    if data.target
      if data.target.type is "popup"
        onclickList = [
          "window.open(this.href, '"
          data.target.name or ""
          "', '"
        ]
        featureList = [
          "resizable"
          "status"
          "location"
          "toolbar"
          "menubar"
          "fullscreen"
          "scrollbars"
          "dependent"
        ]
        featureLength = featureList.length
        addFeature = (featureName) ->
          featureList.push featureName + "=" + data.target[featureName]  if data.target[featureName]
          return

        i = 0

        while i < featureLength
          featureList[i] = featureList[i] + ((if data.target[featureList[i]] then "=yes" else "=no"))
          i++
        addFeature "width"
        addFeature "left"
        addFeature "height"
        addFeature "top"
        onclickList.push featureList.join(","), "'); return false;"
        attributes["data-cke-pa-onclick"] = onclickList.join("")

        # Add the "target" attribute. (#5074)
        removeAttributes.push "target"
      else
        if data.target.type isnt "notSet" and data.target.name
          attributes.target = data.target.name
        else
          removeAttributes.push "target"
        removeAttributes.push "data-cke-pa-onclick", "onclick"

    # Advanced attributes.
    if data.adv
      advAttr = (inputName, attrName) ->
        value = data.adv[inputName]
        if value
          attributes[attrName] = value
        else
          removeAttributes.push attrName
        return

      advAttr "advId", "id"
      advAttr "advLangDir", "dir"
      advAttr "advAccessKey", "accessKey"
      if data.adv["advName"]
        attributes["name"] = attributes["data-cke-saved-name"] = data.adv["advName"]
      else
        removeAttributes = removeAttributes.concat([
          "data-cke-saved-name"
          "name"
        ])
      advAttr "advLangCode", "lang"
      advAttr "advTabIndex", "tabindex"
      advAttr "advTitle", "title"
      advAttr "advContentType", "type"
      advAttr "advCSSClasses", "class"
      advAttr "advCharset", "charset"
      advAttr "advStyles", "style"
      advAttr "advRel", "rel"
    selection = editor.getSelection()

    # Browser need the "href" fro copy/paste link to work. (#6641)
    attributes.href = attributes["data-cke-saved-href"]
    unless @_.selectedElement
      range = selection.getRanges(1)[0]

      # Use link URL as text with a collapsed cursor.
      if range.collapsed

        # Short mailto link text view (#5736).
        text = new CKEDITOR.dom.text((if data.type is "email" then data.email.address else attributes["data-cke-saved-href"]), editor.document)
        range.insertNode text
        range.selectNodeContents text

      # Apply style.
      style = new CKEDITOR.style(
        element: "a"
        attributes: attributes
      )
      style.type = CKEDITOR.STYLE_INLINE # need to override... dunno why.
      style.applyToRange range
      range.select()
    else

      # We're only editing an existing link, so just overwrite the attributes.
      element = @_.selectedElement
      href = element.data("cke-saved-href")
      textView = element.getHtml()
      element.setAttributes attributes
      element.removeAttributes removeAttributes
      element.addClass (if element.getChildCount() then "cke_anchor" else "cke_anchor_empty")  if data.adv and data.adv.advName and CKEDITOR.plugins.link.synAnchorSelector

      # Update text view when user changes protocol (#4612).

      # Short mailto link text view (#5736).
      element.setHtml (if data.type is "email" then data.email.address else attributes["data-cke-saved-href"])  if href is textView or data.type is "email" and textView.indexOf("@") isnt -1
      selection.selectElement element
      delete @_.selectedElement
    return

  onLoad: ->
    @hidePage "advanced"  unless editor.config.linkShowAdvancedTab #Hide Advanded tab.
    @hidePage "target"  unless editor.config.linkShowTargetTab #Hide Target tab.
    return


  # Inital focus on 'url' field if link is of type URL.
  onFocus: ->
    linkType = @getContentElement("info", "linkType")
    urlField = undefined
    if linkType and linkType.getValue() is "url"
      urlField = @getContentElement("info", "url")
      urlField.select()
    return


# The e-mail address anti-spam protection option. The protection will be
# applied when creating or modifying e-mail links through the editor interface.
#
# Two methods of protection can be choosed:
#
# 1. The e-mail parts (name, domain and any other query string) are
# assembled into a function call pattern. Such function must be
# provided by the developer in the pages that will use the contents.
# 2. Only the e-mail address is obfuscated into a special string that
# has no meaning for humans or spam bots, but which is properly
# rendered and accepted by the browser.
#
# Both approaches require JavaScript to be enabled.
#
# // href="mailto:tester@ckeditor.com?subject=subject&body=body"
# config.emailProtection = '';
#
# // href="<a href=\"javascript:void(location.href=\'mailto:\'+String.fromCharCode(116,101,115,116,101,114,64,99,107,101,100,105,116,111,114,46,99,111,109)+\'?subject=subject&body=body\')\">e-mail</a>"
# config.emailProtection = 'encode';
#
# // href="javascript:mt('tester','ckeditor.com','subject','body')"
# config.emailProtection = 'mt(NAME,DOMAIN,SUBJECT,BODY)';
#
# @since 3.1
# @cfg {String} [emailProtection='' (empty string = disabled)]
# @member CKEDITOR.config
