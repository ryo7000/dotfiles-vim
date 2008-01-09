if exists('g:loaded_util')
    finish
endif
let g:loaded_util = 1

" MozReplを使って、Firefoxであたらしいタブを開く関数
function! OpenNewTab(url)
	:ruby <<EOF
		require "net/telnet"

		telnet = Net::Telnet.new({
			"Host" => "localhost",
			"Port" => 4242
		})

		url = VIM::evaluate("a:url")
		telnet.puts("window.openNewTabWith('#{url}')")
		telnet.close
EOF
endfunction
