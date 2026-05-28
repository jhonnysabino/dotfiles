# dotfiles

Minhas configurações pessoais para Desenvolvimento.

## Estrutura

- `nvim/` — Configuração do Neovim
- `wezterm/` — Configuração do WezTerm
- `pi/` — Configuração do PI (coding agent)

## Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-user/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Ativar configurações com stow
stow nvim
stow wezterm
stow --no-folding pi

# Desativar configurações
stow -D nvim
stow -D wezterm
stow -D pi
```

> **Importante**: Após alterar qualquer arquivo, rode `stow -v -t ~ <pacote>` para atualizar os symlinks.
> O `pi` usa `--no-folding` porque divide `~/.pi/agent/` com arquivos locais como `auth.json` e `sessions/`.

### Setup PI em máquina nova

```bash
cd ~/dotfiles && ./pi/setup.sh
```

Ou manualmente:

```bash
cd ~/dotfiles && stow --no-folding pi
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
pi install npm:@codexstar/pi-listen
pi install npm:@aliou/pi-processes
pi  # faça /login para autenticar
```

## Dependências

Certifique-se que `~/go/bin` está no PATH (~/.bashrc):

```bash
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

Ferramentas extras (instaladas via `./scripts/install-tools.sh`):
- **lazygit** — Interface git no terminal
- **gotests** — Gera testes unitários
- **gomodifytags** — Gerencia tags de struct
- **impl** — Gera stub de interface
- **fillstruct** — Preenche struct

---

## WezTerm

Fonte: `JetBrainsMono Nerd Font Mono`

### Atalhos

| Ação | Tecla |
|------|-------|
| Split horizontal | `CTRL+\` |
| Split vertical | `CTRL+-` |
| Fechar pane | `CTRL+SHIFT+w` |
| Zoom pane | `CTRL+SHIFT+m` |
| Navegar panes | `CTRL+h/j/k/l` |
| Redimensionar pane | `CTRL+SHIFT+h/j/k/l` |
| Aba anterior | `CTRL+[` |
| Próxima aba | `CTRL+]` |
| Nova aba | `CTRL+t` |

> **Integração com Neovim**: `CTRL+h/j/k/l` navega entre splits do neovim primeiro; ao chegar na borda, muda para o pane do WezTerm automaticamente.

---

## Neovim

Fonte: `JetBrainsMono Nerd Font Mono`

Plugins principais:
- **LSP**: Go, Lua, TypeScript, Terraform
- **UI**: Telescope, Neotree, Which-key, Trouble
- **Git**: Gitsigns, LazyGit
- **Utils**: Harpoon, Undotree, Zen Mode

### Atalhos gerais

| Ação | Tecla |
|------|-------|
| Navegar entre janelas | `CTRL+h/j/k/l` |
| Mover linha (visual) | `J` / `K` |
| Substituir palavra | `<leader>r` |

### LazyGit

| Ação | Tecla |
|------|-------|
| Abrir LazyGit (no arquivo atual) | `<leader>lg` |
| Editar arquivo | `e` (abre com números relativos na linha certa) |
| Fechar editor e voltar | `:q` |

Configuração do LazyGit em `~/.config/lazygit/config.yml`.

### LSP

| Ação | Tecla |
|------|-------|
| Format code | `<leader>cf` |
| Go to definition | `<leader>fd` |
| Find references | `<leader>fr` |
| Code action | `<leader>ca` |
| Rename | `<leader>cr` |
