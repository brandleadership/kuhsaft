CKEDITOR.editorConfig = (config) ->
  config.language = "de"
  config.extraAllowedContent = 'iframe[*]'
  config.removeButtons = "Anchor,Underline,Strike,Subscript,Superscript"
  config.format_tags = "p;h1;h2;h3;h4;pre"
  config.toolbar = [["Format"],
                    ["Bold", "Italic", "Underline", "Strike", "-", "Subscript", "Superscript"],
                    ["Table", "HorizontalRule", "SpecialChar"], ["Link", "Unlink"],
                    ["Undo", "Redo", "-", "RemoveFormat", "Cut", "Copy", "Paste"],
                    ["Source", "-", "ShowBlocks", "-", "About"],
                    ["Maximize"]]

  config.linkShowAdvancedTab = false
  config.linkShowTargetTab = false

  config.removePlugins = 'link'
  config.extraPlugins = 'adv_link'

  true

# Image Upload options:
# ---------------------

# enable theese two:
  # config.filebrowserUploadUrl = '/cms/ckimages'
  # config.filebrowserBrowseUrl = '/cms/ckimages'

# and add this button:
  # 'Image'


# FULL OPTIONS:
#[
#['Source','-','Save','NewPage','Preview','-','Templates'],
#['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
#['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
#['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
#'/',
#['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
#['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
#['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
#['Link','Unlink','Anchor'],
#['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],
#'/',
#['Styles','Format','Font','FontSize'],
#['TextColor','BGColor'],
#['Maximize', 'ShowBlocks','-','About']
#]
