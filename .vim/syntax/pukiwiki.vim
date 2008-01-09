"
" pukiwiki.vim - Pukiwiki用シンタックス定義
"
" Language:     Pukiwiki
" Maintainer:   りょう <ryo@live-emotion.com>
" Last Change:  25-Jun-2007.

scriptencoding cp932

syntax match wikiQuotation display "^>\+"
syntax match wikiList display "^-\{1,3}"
syntax match wikiNoList display "^+\{1,3}"
syntax match wikiDefine display "^:\{1,3}.*|.*$"
syntax match wikiFormatted display "^ .*$"
syntax match wikiTable display "^|.*|[fh]*$"
syntax match wikiTableCsv display "^,.*$"
syntax match wikiCaption display "^*\+.*$"
syntax match wikiAlign display "^\(LEFT\|CENTER\|RIGHT\):.*"
syntax match wikiHr display "^----"
syntax match wikiLink display "\[\[.*\]\]"
syntax match wikiNewline display "\~$"
syntax match wikiCommand display "^#.*$"
syntax match wikiPlugin display "&.*;"
syntax match wikiStrong display "''.*''"
syntax match wikiItalic display "'''.*'''"
syntax match wikiCancel display "%%.*%%"
syntax match wikiNote display "((.*))"
"syntax match wikiName display "[A-Z]\+[a-z]\+[A-Z]\+[a-z]\+"
syntax match wikiComment display "^\/\/.*$"


hi def link wikiQuotation		Title
hi def link wikiList			Title
hi def link wikiNoList			Title
hi def link wikiDefine			Title
hi def link wikiFormatted		Folded
hi def link wikiTable			Identifier
hi def link wikiTableCsv		Identifier
hi def link wikiCaption			IncSearch
hi def link wikiAlign			Title
hi def link wikiHr				Question
hi def link wikiLink			UnderLined
hi def link wikiNewline			NonText
hi def link wikiCommand			Statement
hi def link wikiPlugin			Statement
hi def link wikiStrong			Statement
hi def link wikiItalic			ModeMsg
hi def link wikiCancel			Error
hi def link wikiNote			SignColumn
hi def link wikiName			UnderLined
hi def link wikiComment			Comment

let b:current_syntax = "pukiwiki"
