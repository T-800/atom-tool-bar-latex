# Toolbar for Latex document

## this package is in early stage of developpment (use a your own risk !)

A tool-bar plugin that adds Latex editing buttons.

# Installation

You have to install `tool-bar`,  `math-helper` and `latex` packages:

```
apm install tool-bar latex math-helper
```

Then install this package:

```
apm install tool-bar-latex
```

# Configuration

- **Visibility**:
  - `showToolbarOnLatex`: show toolbar in Latex files.
  - `showButtonsOnLatex`: show Latex buttons in Latex files. Useful when you have multiple plugins installed.
  - `showButtonsOnAll`: always show toolbar and Latex buttons
- **Grammars**:
  - An array of file types to be treated as Latex files.

# Feature
## ToolBar

- New File
- Open File(s)
- Save File
- Undo
- Redo
- Build latex Document (Need`latex` package)
- Bold text
- Italic text
- Underline text
- Itemize env
- Enumerate env
- Item shortcut
- Math inline (`$ .. $`)
- Equation Block env (`\[  ... \]`)
- Math Equation Helper panel (Need `math-helper` package)
- Insert table panel
- Add chapter
- Add Section
- Add Paragraph
- Add Sub Paragraph


## Grammars & Snippets
This package include new version of `language-latex`

This new version allow autocomplete panel to show up in `$ .. $` and `\[  ... \]` mode who wasn't possible in the last version

It also change the scope of few snippet (ex : `\sum{}{}` now only show in `$ .. $` and `\[  ... \]`)


# TODO
- [x] Change Grammars & Snippets
- [x] Add insert table helper view
- [x] Equation Helper panel insert snippet
- [ ] Clean up

# Thanks
tool-bar : https://atom.io/packages/tool-bar

tool-bar-markdown : https://atom.io/packages/tool-bar-markdown-writer

markdown-writer : https://atom.io/packages/markdown-writer

markdown-preview-enhanced : https://atom.io/packages/markdown-preview-enhanced
