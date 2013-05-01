" Exit quickly when already loaded.
if exists("g:loaded_turbospecs")
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
    echon "Sorry, Turbospecs requires ruby support."
  finish
endif

let g:loaded_turbospecs = "true"

let s:auto_mode = 0

function! s:Spec()
  :ruby spec
endfunction

function! s:SpecLine()
  :ruby spec_line
endfunction

function! s:ReSpec()
  :ruby re_spec
endfunction

function! s:LoadSpec()
  :call VimuxRunCommand("load '".@%."';")
endfunction

function! s:ToggleAutoMode()
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

command TurboSpec :call s:Spec()
command TurboSpecLine :call s:SpecLine()
command TurboSpecAgain :call s:ReSpec()
command TurboSpecLoad :call s:LoadSpec()
command TurboSpecAutoMode :call s:ToggleAutoMode()


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

