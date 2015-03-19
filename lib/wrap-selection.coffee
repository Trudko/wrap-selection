{CompositeDisposable} = require 'atom'

module.exports = WrapSelection =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor', 'wrap-selection:wrap-with-text': => @wrapWithText()
    @subscriptions.add atom.commands.add 'atom-text-editor', 'wrap-selection:wrap-with-tag': => @wrapWithTag()

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

  wrapWithTag: ->
    editor = atom.workspace.getActiveEditor()
    selection = editor.getSelection()

    range = selection.getBufferRange()
    start = range.start
    end = range.end
    indentLevel = editor.indentationForBufferRow(start.row)
    prefix = ''
    if editor.softTabs
      for i in [0...indentLevel]
        prefix += ' ' for j in [0...editor.getTabLength()]
    else
      for i in [0...indentLevel]
        prefix += '\t'

    rangeOne = [[start.row , 0],[start.row , 0]];
    rangeTwo = [[start.row + 2, 0],[start.row + 2, 0]]
    editor.insertNewlineAbove()
    editor.insertNewlineBelow()
    selection.indent()
    editor.setTextInBufferRange(rangeOne, "#{prefix}<>")
    editor.setTextInBufferRange(rangeTwo, "#{prefix}<>")
    editor.setCursorBufferPosition([start.row , prefix.length + 1])
    editor.addCursorAtBufferPosition([start.row + 2 , prefix.length + 1])
