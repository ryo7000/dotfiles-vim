# Enable TLS for Github
if (([System.Net.ServicePointManager]::SecurityProtocol -band [System.Net.SecurityProtocolType]::Tls12) -eq 0) {
  echo "Add following to $profile"
  echo '-----'
  echo '[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12'
  echo '-----'
  exit
}

# vim
if (!(Test-Path vim.exe -PathType Leaf)) {
  if ($FALSE) {
    Invoke-WebRequest -Uri "https://github.com/koron/vim-kaoriya/releases/download/v8.2.1287-20200724/vim82-kaoriya-win64-8.2.1287-20200724.zip" -OutFile vim.zip

    Expand-Archive vim.zip .
    Move-Item vim82-kaoriya-win64\* .
    Remove-Item vim.zip
    Remove-Item vim82-kaoriya-win64
  } else {
    Invoke-WebRequest -Uri "https://github.com/vim/vim-win32-installer/releases/download/v8.2.4428/gvim_8.2.4428_x64.zip" -OutFile vim.zip

    Expand-Archive vim.zip .
    Move-Item vim\vim82\* .
    Remove-Item vim.zip
    Remove-Item -Recurse vim
  }
}

# ripgrep
if (!(Test-Path rg.exe -PathType Leaf)) {
  Invoke-WebRequest -Uri "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-pc-windows-msvc.zip" -OutFile ripgrep.zip

  Expand-Archive ripgrep.zip .
  Move-Item ripgrep-13.0.0-x86_64-pc-windows-msvc\rg.exe .
  Remove-Item ripgrep.zip
  Remove-Item ripgrep-13.0.0-x86_64-pc-windows-msvc -Recurse
}

# python3
if (!(Test-Path python3 -PathType Container)) {
  Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.10/python-3.9.10-embed-amd64.zip" -OutFile python3.zip

  Expand-Archive python3.zip python3
  Expand-Archive python3\python39.zip python3
  Copy-Item python3\vcruntime140.dll .
  Copy-Item python3\vcruntime140_1.dll .
  Remove-Item python3.zip

  # for denite.nvim
  cd python3
  (Get-Content python39._pth) -replace '#import site', 'import site' | Set-Content python39._pth
  Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile get-pip.py
  .\python.exe get-pip.py
  .\python.exe -m pip install pynvim
  cd ..
}

# dein
echo "clone dein.vim"
Start-Process -Wait -FilePath "git" -ArgumentList "clone", "https://github.com/Shougo/dein.vim", ".vim\dein\dein.vim"
