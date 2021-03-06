" Unicode Haskell for Vim
" by Frerich Raabe <frerich.raabe@gmail.com>
" Based on Haskell Cuteness by Andrey Popp <andrey.popp@braintrace.ru>

let s:mappedChars = {
  \ '`div`' : '÷',
  \ 'bottom': '⊥',
  \ 'eleva': '↑',
  \ 'not': '¬',
  \ 'intersect': '∩',
  \ 'union' : '∪',
  \ 'mult' : '×',
  \ '::' : '∷',
  \ '\': 'λ',
  \ '<-': '←',
  \ '->': '→',
  \ '<=': '≲',
  \ '>=': '≳',
  \ '==': '≡',
  \ '/=': '≠',
  \ '=>': '⇒',
  \ '>>': '»',
  \ ' . ': ' ∘ ',
  \ 'forall ': '∀',
  \ '()': '∅',
  \ '`elem`': '∈',
  \ '`notElem`': '∉',
  \ 'Integer' : 'ℕ',
  \ 'Fractional' : 'ℚ',
  \ 'Float' : 'ℝ',
  \ 'Bool' : '𝔹'
  \ }

" Turn entered text into Unicode characters if possible
for [key, value] in items(s:mappedChars)
    exec "imap <buffer>" substitute(key, ' ', '<space>', 'g') substitute(value, ' ', '<space>', 'g')
endfor

if exists("s:loaded_unicodehaskell")
    finish
endif
let s:loaded_unicodehaskell = 1

augroup HaskellC
    autocmd BufReadPost *.hs cal s:HaskellSrcToUTF8()
    autocmd BufWritePre *.hs cal s:UTF8ToHaskellSrc()
    autocmd BufWritePost *.hs cal s:HaskellSrcToUTF8()
augroup END

function s:safeRegexp(s)
    return escape(a:s, "\\.")
endfunction

" Convert Unicode Haskell source code to plain ASCII source code when saving
" data.
function s:UTF8ToHaskellSrc()
    let l:line = line(".")
    let l:column = col(".")

    for [key, value] in items(s:mappedChars)
        exec "silent %s," . value . "," . s:safeRegexp(key) . ",eg"
    endfor

    let &l:fileencoding = s:oldencoding
    call cursor(l:line, l:column)
endfunction

" Convert ASCII Haskell source code to fancy Unicode source code when reading
" Haskell programs.
function s:HaskellSrcToUTF8()
    let l:line = line(".")
    let l:column = col(".")

    let s:oldencoding = &l:fileencoding
    set fileencoding=utf-8

    for [key, value] in items(s:mappedChars)
        exec "silent %s," . s:safeRegexp(key) . "," . value . ",eg"
    endfor

    let &l:fileencoding = s:oldencoding
    call cursor(l:line, l:column)
endfunction

do HaskellC BufRead
