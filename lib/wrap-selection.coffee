{CompositeDisposable} = require 'atom'

module.exports = WrapSelection =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor', 'wrap-selection:wrap-with-text': => @wrapWithText()

  deactivate: ->
    @subscriptions.dispose()

  wrapWithText: ->
    editor = atom.workspace.getActiveEditor()
    selections = editor.getSelections()
    for selection in selections
        if not selection.isEmpty()
          range = selection.getBufferRange()
          selection.destroy()
          editor.addCursorAtBufferPosition(range.start)
          editor.addCursorAtBufferPosition(range.end)
