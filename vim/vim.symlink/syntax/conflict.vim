" Vim syntax file
" Language:	conflict conflict file
" Maintainer:	Alex Jakushev (Alex.Jakushev@kemek.lt)
" Last Change:	2002.12.30
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn region conflict start="^<<<<<<<.*$" end="^>>>>>>>.*$" contains=conflictBase
syn region conflictBase start="^|||||||.*$" end="^=======.*$" contained


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_conflict_cnfl_syn_inits")
	if version < 508
		let did_conflict_cnfl_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink conflict			DiffChange
	HiLink conflictBase		DiffAdd

	delcommand HiLink
endif

let b:current_syntax = "conflict"
