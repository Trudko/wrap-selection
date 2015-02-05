WrapSelectionView = require './wrap-selection-view'
{CompositeDisposable} = require 'atom'

module.exports = WrapSelection =
  wrapSelectionView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor', 'wrap-selection:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    editor = atom.workspace.getActiveEditor()
    selection = editor.getSelection();
    range = selection.getBufferRange()
    selection.destroy()
    editor.addCursorAtBufferPosition(range.start)
    editor.addCursorAtBufferPosition(range.end)
