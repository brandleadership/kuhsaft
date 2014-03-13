ckeditor-adv_link
=================

A CKEditor4 link plugin adding the ability to link to local (CMS) pages. Rely on jQuery for ajax calls (un-intrusive).
This implementation supports internationalisation (see below).


Disclaimer
----------

I developed that script for my needs and inspired by this [blog post](http://blog.xoundboy.com/?p=393) and this StackOverflow [answer](http://stackoverflow.com/questions/5293920/ckeditor-dynamic-select-in-a-dialog). I want people to be able to use it but I don't pretend to do any support regarding installation or use. It works well with CKEditor v 4.2.2. You want to make it work with other versions? Just do it and share it back.


Enhancement
-----------

I really think it would be great to replace the select input by a list of links contained in a HTML div or even better an input text with ajax call (like in WP). I do not have time now to do that. If you want to involve yourself, you're more than welcome.


How to install it ?
--------------------

1) Download and extract `adv_link` folder into CKEditor plugins folder

2) Disable default link plugin and enable the new one. To do so, in your config.js file :

```javascript
CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here.
	 
	 config.removePlugins = 'link';
	 config.extraPlugins = 'adv_link';

	// whatever

};
```

3) In `dialogs/links.js` file, set the URL of the page which generates inputs to populate the plugin. It is located around line 377. A PHP script sample is given in `sample` folder and can be a good start.

4) Test your installation by using the plugin.

5) It should be working, adapt your script to get the rights inputs.

6) If it does not work, use javascript debugging tool.


Internationalization ready
--------------------------

All languages are embedded in the source code. They are just copies of the default `link` plugin. But few of them are translated.

3 new vars are defined in language files (at the top) :

```javascript
localPages:'Local pages',
selectPageLabel:'Select a page',
selectPageTitle:'Select the page you want to link to',
```

If you can't see them in the selected language file, you'll have to copy-paste from `en.js` file. Please, share your translation with others users.
