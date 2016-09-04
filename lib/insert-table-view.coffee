{CompositeDisposable} = require 'atom'
{$, View, TextEditorView} = require "atom-space-pen-views"

module.exports =
class InsertTableView extends View
  @content: ->
    @div class: "tool-bar-latex tool-bar-latex-dialog", =>
      @label "Insert Table", class: "icon icon-diff-added"
      @div =>
        @label "Rows", class: "message"
        @subview "rowEditor", new TextEditorView(mini: true)
        @label "Columns", class: "message"
        @subview "columnEditor", new TextEditorView(mini: true)
        @div class: 'align-choice', =>
          @span 'Align text'
          @select class: 'align-select', =>
            @option 'Left'
            @option 'Center'
            @option 'Right'


  initialize: ->
    @disposables = new CompositeDisposable()
    @disposables.add(atom.commands.add(
      @element, {
        "core:confirm": => @onConfirm(),
        "core:cancel":  => @detach()
      }))
    @previouslyFocusedElement = $(document.activeElement)
    uploaderSelect = $('.align-select', @element)
    uploaderSelect.on 'change', (e)->
      atom.config.set('tool-bar-latex.align-text', this.value)
      console.log "@align init", @align

  onConfirm: ->
    row = parseInt(@rowEditor.getText(), 10)
    col = parseInt(@columnEditor.getText(), 10)
    alignSelect = "c"
    align = atom.config.get 'tool-bar-latex.align-text'
    console.log align
    switch align
      when 'Left' then  alignSelect = 'l'
      when 'Center' then  alignSelect = 'c'
      when 'Right' then  alignSelect = 'r'
    console.log alignSelect
    @insertTable(row, col, alignSelect) if @isValidRange(row, col)

    @detach()

  display: ->

    @editor = atom.workspace.getActiveTextEditor()
    @panel ?= atom.workspace.addModalPanel(item: this, visible: false)

    @rowEditor.setText("3")
    @columnEditor.setText("3")
    @panel.show()
    @rowEditor.focus()
  detach: ->
    if @panel.isVisible()
      @panel.hide()
      @previouslyFocusedElement?.focus()
    #super

  detached: ->
    @disposables?.dispose()
    @disposables = null

  insertTable: (row, col, align) ->
    cursor = @editor.getCursorBufferPosition()
    @editor.insertText(@createTable(row, col, align))
    @editor.setCursorBufferPosition(cursor)

  createTable: (row, col, align) ->

    table = []

    # insert header
    table.push(@createTableHeader(col, align))

    # insert line body
    table.push(@createTablerow(col))for [0..row - 1]

    # insert footer
    table.push("\\end{tabular}")

    return table.join("\n")

  isValidRange: (row, col) ->
    return false if isNaN(row) || isNaN(col)
    return false if row < 1 || col < 1
    return true

  createTableHeader:(col, align) ->
    t = []
    t.push("\\begin{tabular}{|")
    t.push("#{align}|") for x in [0..col - 1]
    t.push("}\n\\hline\t")
    return t.join('')

  createTablerow:(col) ->
    t = []
    t.push("  &") for x in [0..col - 2]
    t.push("  \\\\\n\\hline")
    return t.join('')
