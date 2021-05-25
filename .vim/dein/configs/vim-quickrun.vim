let g:quickrun_config = {
\  "_" : {
\      "runner" : "vimproc",
\      "runner/vimproc/updatetime" : 60,
\      "outputter" : "error",
\      "outputter/error/success" : "buffer",
\      "outputter/error/error" : "quickfix"
\ },
\ 'cpp': {
\   'cmdopt': '-std=c++11',
\ },
\ 'rust': {
\   'type': 'rust/cargo',
\ },
\}
