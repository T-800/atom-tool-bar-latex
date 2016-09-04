{ CompositeDisposable } = require 'atom'

module.exports =
  config:
    visibility:
      type: 'string',
      default: 'showButtonsOnLatex',
      description: 'Configure toolbar visibility behaviour',
      enum: [
        'showToolbarOnLatex'
        'showButtonsOnLatex'
        'showButtonsOnAll'
      ]
    grammars:
      type: 'array',
      default: [
        'source.tex'
        'source.latex'
        'text.tex'
        'text.tex.latex'
        'text.latex'
        'text.plain'
        'text.plain.null-grammar'
      ],
      description: 'Valid file type grammars',

  buttons: [
    {
      'icon': 'file',
      'label': 'New File',
      'command': 'application:open-file',
      'iconset': 'mdi'
    },
    {
      'icon': 'folder',
      'label': 'Open File',
      'command': 'application:open-file',
      'iconset': 'mdi'
    },
    {
      'icon': 'content-save',
      'label': 'Save File',
      'command': 'core:save',
      'iconset': 'mdi'
    },
    {
      'icon': 'undo',
      'label': 'Undo',
      'command': 'core:undo',
      'iconset': 'mdi'
    },
    {
      'icon': 'redo',
      'label': 'Redo',
      'command': 'core:redo',
      'iconset': 'mdi'
    },
    {
      'icon': 'hammer',
      'label': 'Build latex'
      'command': 'latex:build',
      'iconset': 'icomoon'
    },
    { 'type': 'separator' },
    {
      'icon': 'format-bold',
      'label': 'Bold text'
      'command': 'tool-bar-latex:toggle-bold',
      'iconset': 'mdi'
    },
    {
      'icon': 'format-italic',
      'label': 'Italic text'
      'command': 'tool-bar-latex:toggle-italic',
      'iconset': 'mdi'
    },
    {
      'icon': 'format-underline',
      'label': 'Underline text'
      'command': 'tool-bar-latex:toggle-underline',
      'iconset': 'mdi'
    },

    { 'type': 'separator' },
    {
      'icon': 'format-list-bulleted',
      'label': 'List bulleted'
      'command': 'tool-bar-latex:toggle-itemize',
      'iconset': 'mdi'
    },
    {
      'icon': 'format-list-numbers',
      'label': 'List numbers'
      'command': 'tool-bar-latex:toggle-enumerate',
      'iconset': 'mdi'
    },
    {
      'icon': 'format-list-bulleted-type',
      'label': 'List item'
      'command': 'tool-bar-latex:toggle-item',
      'iconset': 'mdi'
    },

    { 'type': 'separator' },

    {
      'icon': 'usd',
      'label': 'Math inline'
      'command': 'tool-bar-latex:toggle-inline-math',
      'iconset': 'fa'
    },
    {
      'icon': 'appnet',
      'label': 'Math block'
      'command': 'tool-bar-latex:toggle-block-math',
      'iconset': 'mdi'
    },
    {
      'icon': 'function',
      'label': 'Equation helper',
      'command': 'math-helper:toggle',
      'iconset': 'mdi'
    },
    {
      'icon': 'table',
      'label': 'Insert table',
      'command': 'tool-bar-latex:insert-table',
      'iconset': 'mdi'
    },
    { 'type': 'separator' },
    {
      'icon': 'format-title',
      'label': 'Chapter',
      'command': 'tool-bar-latex:toggle-chapter',
      'iconset': 'mdi'
    },
    {
      'icon': 'section',
      'label': 'Section',
      'command': 'tool-bar-latex:toggle-section',
      'iconset': 'icomoon'
    },
    {
      'icon': 'parking',
      'label': 'Paragraph',
      'command': 'tool-bar-latex:toggle-paragraph',
      'iconset': 'mdi'
    },
    {
      'icon': 'format-paragraph',
      'label': 'Sub Paragraph',
      'command': 'tool-bar-latex:toggle-subparagraph',
      'iconset': 'mdi'
    },

  ]

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar('tool-bar-latex')
    # cleaning up when tool bar is deactivated
    @toolBar.onDidDestroy => @toolBar = null
    # display buttons
    @addButtons()

  addButtons: ->
    return unless @toolBar?

    @buttons.forEach (button) =>
      if button['type'] == 'separator'
        @toolBar.addSpacer()
      else
        @toolBar.addButton(
          icon: button['icon'],
          callback: button['command'],
          tooltip: button['label'],
          iconset: button['iconset'])

  removeButtons: -> @toolBar?.removeItems()

  updateToolbarVisible: (visible) ->
    atom.config.set('tool-bar.visible', visible)

  isToolbarVisible: -> atom.config.get('tool-bar.visible')

  activate: ->
    @disposables = new CompositeDisposable()
    @disposables.add atom.commands.add 'atom-text-editor[data-grammar="text tex latex"]',
      'tool-bar-latex:toggle-inline-math': => @triggerSnippet("ml")
      'tool-bar-latex:toggle-block-math': => @triggerSnippet("$$")
      'tool-bar-latex:toggle-paragraph': => @triggerSnippet("par")
      'tool-bar-latex:toggle-chapter': => @triggerSnippet("cha")
      'tool-bar-latex:toggle-section': => @triggerSnippet("sec")
      'tool-bar-latex:toggle-subsection': => @triggerSnippet("sub")
      'tool-bar-latex:toggle-subsubsection': =>@triggerSnippet("subs")
      'tool-bar-latex:toggle-subparagraph': => @triggerSnippet("subp")
      'tool-bar-latex:toggle-begin': => @triggerSnippet("begin")
      'tool-bar-latex:toggle-itemize': => @triggerSnippet("item")
      'tool-bar-latex:toggle-enumerate': => @triggerSnippet("enum")
      'tool-bar-latex:toggle-item': => @triggerSnippet("itd")
      'tool-bar-latex:toggle-bold': => @triggerSnippet("**")
      'tool-bar-latex:toggle-italic': => @triggerSnippet("//")
      'tool-bar-latex:toggle-underline': => @triggerSnippet("__")
      'tool-bar-latex:insert-table': => @insert_table()


    @disposables.add atom.workspace.onDidStopChangingActivePaneItem (item) =>
      visibility = atom.config.get('tool-bar-latex.visibility')

      if @isLatex()
        @removeButtons()
        @addButtons()
        @updateToolbarVisible(true) if visibility == 'showToolbarOnLatex'
      else if @isToolbarVisible()
        if visibility == 'showButtonsOnLatex'
          @removeButtons()
        else if visibility == 'showToolbarOnLatex'
          @updateToolbarVisible(false)

  triggerSnippet: (snip) ->
    return unless editor = atom.workspace.getActiveTextEditor()
    return unless mod = atom.packages.getActivePackage('snippets')?.mainModule
    return unless snippet = mod.getSnippets(editor)[snip]
    mod.insert(snippet, editor, editor.getLastCursor())


  isLatex: ->
    editor = atom.workspace.getActiveTextEditor()
    return false unless editor?
    grammars = atom.config.get('tool-bar-latex.grammars')
    return grammars.indexOf(editor.getGrammar().scopeName) >= 0

  deactivate: ->
    @disposables?.dispose()
    @disposables = null
    @disposables.dispose()
    @disposables = null
    @toolBar?.removeItems()

  trigger: (e) ->
    editor = atom.workspace.getActiveTextEditor()
    curPos = editor.getCursorBufferPosition()
    editor.insertText(e)
    atom.views.getView(editor).focus()


  insert_table:() ->
    InsertTableView = require './insert-table-view'
    editor = atom.workspace.getActiveTextEditor()
    if editor and editor.buffer
      @insertTableView ?= new InsertTableView()
      @insertTableView.display()
    else
      atom.notifications.addError('Failed to open insert table panel')
