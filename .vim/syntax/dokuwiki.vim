" DokuWiki Vim Syntaxfile
" Language:      DokuWiki Pages (http://wiki.splitbrain.org/wiki:dokuwiki)
" Maintainer:    Michael Klier <chi@chimeric.de>
" Modifier:      Ryo <ryo@live-emotion.com>
" URL:           http://www.chimeric.de/projects/dokuwiki/vimsyntax
" Last Change:   2007-04-01

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = "dokuwiki"
endif

syn case ignore
syn sync linebreaks=1

syn match DokuHeadline          #^ \=\(=\{2,6}\)[^=]\+\1 *$#
syn match DokuRule              #^ \=-\{4,} *$#
syn match DokuBold              #\*\*[^\*\[\]]\+\*\*#
syn match DokuItalic            #//[^\/\[\]]\+//#
syn match DokuUnderlined        #__[^_[\]]\+__#
syn match DokuMonospaced        #''[^'[\]]\+''#
syn match DokuNewLine           #\\\\\( \{1,}\|$\)#
syn match DokuSmileys           #8-)\|8-O\|:-(\|:-)\|=)\|:-/\|:-\\\|:-?\|:-D\|:-P\|:-O\|:-X\|:-|\|;-)\|:?:\|:!:\|\^_\^\|LOL\|FIXME\|DELETEME#
syn match DokuPre               #^  \( *$\| *[^*-]\)\@=#
syn match DokuList              #^\( \{2}\| \{4}\| \{6}\| \{8}\| \{10}\| \{12}\| \{14}\| \{16}\| \{18}\| \{20}\| \{22}\| \{24}\)\(\-\|\*\)# 
syn match DokuQuote             #^>\+#
syn match DokuLinKInterwiki     #[a-z]\+>#    contained
syn match DokuLinkExternal      #\(http\|https\)\=\(://\)\=\(www\.\)\(\a\|-\)\+\(\.\{1}\l\{2,3}\)\=[^| ]*#
syn match DokuLinkMail          #<[^@]\+@[^>]\+>#
syn match DokuLinkTitle         #|\zs[^|\]{}]\+# contained
syn match DokuImageMode         #?[^}]\+# contained
syn match DokuTableTH           #\^# contained
syn match DokuTableTD           #|#  contained

syn region DokuLink             start=#\[\[# end=#\]\]# contains=DokuLinkInterwiki,DokuLinkExternal,DokuLinkTitle,DokuMedia oneline
syn region DokuMedia            start=#{{#   end=#}}#   contains=DokuLinkExternal,DokuImageMode,DokuLinkTitle oneline

syn region DokuSub              start=#<sub># end=#</sub>#  keepend
syn region DokuSup              start=#<sup># end=#</sup>#  keepend 
syn region DokuDel              start=#<del># end=#</del>#  keepend 
syn region DokuFootnote         start=#((#    end=#))#      keepend

syn region DokuFileGeneric matchgroup=DokuFileMatch start=#<file># end=#</file># keepend
"syn region DokuCodeGeneric matchgroup=DokuCodeMatch start=#<code># end=#</code># keepend
syn region DokuCodeGeneric matchgroup=DokuCodeMatch start=#<code \=.\{-}># end=#</code># keepend
syn region DokuBlockNoWiki matchgroup=DokuCodeMatch start=#<nowiki># end=#</nowiki># keepend
syn region DokuBlockNoWiki matchgroup=DokuCodeMatch start=#%%# end=#%%#

" fix insert dokuformatting groups
syn region DokuTableTH          start=#\^# end=#\^\|# contains=DokuTableTH,DokuLink,DokuMedia,DokuBold,DokuItalic,DokuUnderlined,DokuMonospaced,DokuSmileys,DokuNewLine oneline
syn region DokuTableTD          start=#|#  end=#|\|# contains=DokuTableTD,DokuLink,DokuMedia,DokuBold,DokuItalic,DokuUnderlined,DokuMonospaced,DokuSmileys,DokuNewLine oneline

" TODO make other syntax work inside codeblocks
" syn include @PHP syntax/php.vim
" unlet b:current_syntax
" syn region DokuPHP matchgroup=DokuCodeMatch start=#<code php># end=#</code># contains=@PHP
" syn include @PERL syntax/perl.vim
" unlet b:current_syntax
" syn region DokuPERL matchgroup=DokuCodeMatch start=#<code perl># end=#</code># contains=@PERL
" syn include @HTML syntax/html.vim
" unlet b:current_syntax
" syn region DokuHTML matchgroup=DokuCodeMatch start=#<html># end=#</html># contains=@HTML
" syn include @JAVA syntax/java.vim
" unlet b:current_syntax
" syn region DokuJAVA matchgroup=DokuCodeMatch start=#<code java># end=#</code># contains=@JAVA

" costum color groups
hi def link DokuHeadline      Title
hi def link DokuNewLine       NonText
hi def link DokuRule          Special
hi def link DokuQuote         Constant
hi def link DokuLink          Underlined
hi def link DokuLinkInterwiki DokuLink
hi def link DokuLinkExternal  DokuLink
hi def link DokuLinkMail      DokuLink
hi def link DokuLinkTitle     DokuLink
hi def link DokuMedia         Constant
hi def link DokuImageMode     Constant
hi def link DokuSmileys       Label
hi def link DokuSub           Identifier
hi def link DokuSup           Identifier
hi def link DokuDel           Identifier
hi def link DokuFootnote      Macro
hi def link DokuList          Question
hi def link DokuTableTH       Identifier
hi def link DokuTableTD       Constant

" color groups
hi def link DokuBlockColor    NonText
hi def link DokuPre           NonText
hi def link DokuFormatColor   Constant

" link to groups 
hi link DokuBold       DokuFormatColor
hi link DokuItalic     DokuFormatColor
hi link DokuUnderlined DokuFormatColor
hi link DokuMonospaced DokuFormatColor
hi link DokuFile       DokuBlockColor
hi link DokuCode       DokuBlockColor
hi link DokuCodeMatch  DokuBlockColor
hi link DokuFileMatch  DokuBlockColor
hi link DokuNoWiki     DokuBlockColor

" FIXME is this right, or could it be omited?
if main_syntax == "dokuwiki"
  syn sync minlines=2
endif

let b:current_syntax = "dokuwiki"

if main_syntax == 'dokuwiki'
  unlet main_syntax
endif

" vim:ts=2:sw=2:
