{CompositeDisposable} = require 'atom'

module.exports = WrapSelection =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor', 'wrap-selection:wrap-it-good': => @wrapItGood()

  deactivate: ->
    @subscriptions.dispose()

  wrapItGood: ->
    editor = atom.workspace.getActiveEditor()
    selection = editor.getSelection()
    if not selection.isEmpty()
      range = selection.getBufferRange()
      selection.destroy()
      editor.addCursorAtBufferPosition(range.start)
      editor.addCursorAtBufferPosition(range.end)
