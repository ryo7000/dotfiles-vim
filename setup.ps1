# Enable TLS for Github
if (([System.Net.ServicePointManager]::SecurityProtocol -band [System.Net.SecurityProtocolType]::Tls12) -eq 0) {
  echo "Add following to $profile"
  echo '-----'
  echo '[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12'
  echo '-----'
  exit
}

# vim
Invoke-WebRequest -Uri "https://github.com/koron/vim-kaoriya/releases/download/v8.1.1048-20190325/vim81-kaoriya-win64-8.1.1048-20190325.zip" -OutFile vim.zip

Expand-Archive vim.zip .
Move-Item vim81-kaoriya-win64\* .
Remove-Item vim.zip
Remove-Item vim81-kaoriya-win64

# ripgrep
Invoke-WebRequest -Uri "https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep-0.8.1-x86_64-pc-windows-msvc.zip" -OutFile ripgrep.zip
Expand-Archive ripgrep.zip .
Remove-Item ripgrep.zip
Remove-Item _rg.ps1

# python3
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.5.4/python-3.5.4-embed-amd64.zip" -OutFile python3.zip
Expand-Archive python3.zip python3
Expand-Archive python3\python35.zip python3
Copy-Item python3\vcruntime140.dll .
Remove-Item python3.zip

# dein
Start-Process -Wait -FilePath "C:\Program Files\Git\bin\git.exe" -ArgumentList "clone https://github.com/Shougo/dein.vim .vim\dein\dein.vim"
