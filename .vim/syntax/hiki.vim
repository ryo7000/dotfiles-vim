"
" hiki.vim - Hiki用シンタックス定義
"
" Language:     Hiki
" Maintainer:   りょう <ryo@live-emotion.com>
" Last Change:  09-Jul-2007.

scriptencoding cp932

syntax match hikiWikiWord display /\u[a-z0-9]\+\u[a-z0-9]\+\(\u[a-z0-9]\+\)*/
syntax match hikiQuotation display "^\"\".\+"
syntax match hikiList display "^\*\{1,3}"
syntax match hikiNoList display "^#\{1,3}"
syntax match hikiDefine display "^:.\{-\}:.*$"
syntax match hikiFormatted display "^ .*$"
syntax region hikiFormatted display start=/<<</ end=/>>>/
syntax match hikiTable display "^||.*$"
syntax match hikiCaption display "^!\{1,5}[^!].*$"
syntax match hikiHr display "^----"
syntax match hikiLink display "\[\[.\{-\}\]\]"
syntax match hikiInterWikiLink display "\*\[\[.\{-\}\]\]"
syntax match hikiCommand display "^#.*$"
syntax region hikiPlugin display start=/{{/ end=/}}/
syntax match hikiItalic display "''.\{-\}''"
syntax match hikiStrong display "'''.\{-\}'''"
syntax match hikiCancel display "==.*=="
syntax match hikiComment display "^\/\/.*$"


hi def link hikiWikiWord		UnderLined
hi def link hikiQuotation		Title
hi def link hikiList			Title
hi def link hikiNoList			Title
hi def link hikiDefine			Title
hi def link hikiFormatted		Folded
hi def link hikiTable			Identifier
hi def link hikiCaption			IncSearch
hi def link hikiHr				Question
hi def link hikiLink			UnderLined
hi def link hikiCommand			Statement
hi def link hikiPlugin			Statement
hi def link hikiItalic			ModeMsg
hi def link hikiStrong			Statement
hi def link hikiCancel			Error
hi def link hikiComment			Comment

let b:current_syntax = "hiki"
