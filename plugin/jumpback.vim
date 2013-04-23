" Exit quickly when already loaded.
if exists("g:loaded_jumpback")
  finish
endif

" Exit quicky if running in compatible mode
if &compatible
  echohl ErrorMsg
  echohl none
  finish
endif

" Check for Ruby functionality.
if !has("ruby")
    echohl ErrorMsg
    echon "Sorry, Jumpback requires ruby support."
  finish
endif

let g:loaded_jumpback = "true"

let s:auto_mode = 0

function! Spec()
  :ruby spec
endfunction

function! SpecLine()
  :ruby spec_line
endfunction

function! ReSpec()
  :ruby re_spec
endfunction

function! LoadSpec()
  :call VimuxRunCommand("load '".@%."';")
endfunction

function! ToggleAutoMode()
  let s:auto_mode = (s:auto_mode + 1) % 2

  if s:auto_mode
    augroup turbospecs
      autocmd BufWrite *[^_spec].rb :TurboSpecLoad
      autocmd BufWrite *_spec.rb :TurboSpec
    augroup END
    echo "Automode ON"
  else
    augroup turbospecs
      autocmd!
    augroup END
    echo "Automode OFF"
  endif
endfunction

command TurboSpec :call Spec()
command TurboSpecLine :call SpecLine()
command TurboSpecAgain :call ReSpec()
command TurboSpecLoad :call LoadSpec()
command TurboToggleAutoMode :call ToggleAutoMode()


ruby << EOF

def line
  VIM::evaluate("line('.')")
end

def spec_file
  VIM::evaluate(%{bufname("%")})
end

def rspec_command(file, line = nil)
  if line
    "rspec #{file}:#{line}"
  else
    "rspec #{file}"
  end
end

def spec
  @last_spec = rspec_command(spec_file)
  run_spec
end

def spec_line
  @last_spec = rspec_command(spec_file, line)
  run_spec
end

def run_spec
  VIM::command(%{:call VimuxRunCommand("#{@last_spec}")})
end

def re_spec
  if @last_spec
   run_spec
  end
end

def tab_changed
  @previous = @current if @current
  @current =  VIM::evaluate("tabpagenr()")
end

def jump_tab
 if @previous
   VIM::command("tabn #{@previous}")
 end
end

def startup
  @current = VIM::evaluate("tabpagenr()")
end

EOF

