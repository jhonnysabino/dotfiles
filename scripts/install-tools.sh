#!/bin/bash

echo "Installing Go tools..."

go install github.com/jesseduffield/lazygit@latest
go install github.com/cweill/gotests@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/josharian/impl@latest
go install github.com/dustin/go-fillstruct@latest

echo "Done! Make sure ~/go/bin is in your PATH"