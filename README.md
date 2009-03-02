Rails Dojo Helpers
==================

This plugin is not even close to complete and functionality is being fleshed
out as I use it, or as members of my team need it. If you would like to fork
this project and contribute, I would be -ecstatic-. ^\_^

Default Options and Behavior
----------------------------

All helpers attempt to be sane in regards to default options, and determining
when certain defaults are appropriate. This should hopefully make things
easier for people unfamiliar with, or still learning, the dojo framework.
These "defaults" include using dojox.dijit.ContentPane instead of the version
in dijit proper due to how common it is to need script and style parsing.

### All ###

*  Any dijit with an id set will also have jsId set to the same value. This
   will create a global javascript variable with the same name as the ID that
   references the widget. This can be disabled by setting option 'global' to
   false.

*  By default, all helpers that don't make most sense with another tag will
   be contained by a div. This can be changed with option 'tag'.

### Form Fields ###

*  The form helpers will attempt to set alt and title to something sane where
   possible, if they are not already set.

*  All fields will scroll on focus so that they are not outside the viewport
   when tabbed to.

*  intermediateChanges defaults to true.

#### Text Fields ####

*  If a field is required, or the 'validation' option is set, a
   ValidationTextBox will be used in place of a TextBox widget and the prompt
   message will default to the element's title (which should also default to
   the capitalized name of the field when used in scoped helpers).

*  Text fields are automatically trimmed for whitespace.

Form Helpers
------------

Since my first real use of the helpers is for forms, I have first implemented
rails-compatible form helpers. This includes bare versions, as well as scoped
versions for use within a form\_for or fields\_for block.

*  dijit\_form\_for

*  dijit\_text\_field

*  dijit\_password\_field

*  dijit\_text\_area

*  dijit\_check\_box

*  dijit\_check\_box\_tag

*  dijit\_select

*  dijit\_button

*  dijit\_submit\_button

*  dijit\_reset\_button
