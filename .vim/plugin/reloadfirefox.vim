if exists('g:reload_firefox')
    finish
endif

command -nargs=0 Setreloadfirefox :call SetMozreplReloadFirefox()

function! ReloadFirefox()
    if has('ruby')
        :ruby <<EOF
            require "net/telnet"

            telnet = Net::Telnet.new({
                "Host" => "localhost",
                "Port" => 4242
            })

            telnet.puts("content.location.reload(true)")
            telnet.close
EOF
    else
        if has('gui_win32')
            " for Windows
            let ruby_script_file = 'c:/cygwin/home/username/bin/mozrepl_reload_firefox.rb'
        else
            " for Linux, Cygwin
            let ruby_script_file = $HOME . '/bin/mozrepl_reload_firefox.rb'
        endif

        if filereadable(ruby_script_file)
            call system(ruby_script_file)
        else
            echo "ERROR : File \"" . ruby_script_file . "\" is NOT found."
        endif
    endif
endfunction

function! SetMozreplReloadFirefox()
    if exists('g:reload_firefox')
        autocmd! mozreplreloadfirefox
        unlet g:reload_firefox
        echo "\"mozreplreloadfirefox\" of augroup has been deleted."
    else
        augroup mozreplreloadfirefox
           autocmd BufWritePost *.html,*.htm,*.js,*.css,*.php call ReloadFirefox()
        augroup END
        let g:reload_firefox=1
        echo "Firefox browser content is reloaded when file(*.html,*htm,*.js,*.css) is saved."
    endif
endfunction
