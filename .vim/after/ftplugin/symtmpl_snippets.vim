if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet image_tag image_tag('".st."imageName".et."'".st.et.")".st.et
exec "Snippet link_to link_to('".st."linkName".et."', '".st."moduleName".et."/".st."actionName".et.st.et."')".st.et
exec "Snippet tforeach <?php foreach ($".st."variable".et." as $".st."key".et.st.et."): ?><CR>".st.et."<CR><?php endforeach ?><CR>".st.et
exec "Snippet div <div".st.et."><CR>".st.et."<CR></div>".st.et
exec "Snippet tif <?php if (".st."condition".et."): ?><CR>".st.et."<CR><?php endif ?><CR>".st.et
exec "Snippet echo <?php echo ".st.et." ?>".st.et
exec "Snippet tfor <?php for($".st."i".et." = ".st.et."; $".st."i".et." <= ".st.et."; $".st."i".et."++): ?><CR>".st.et."<CR><?php endfor ?><CR>".st.et
