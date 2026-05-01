# 📌 Sistema de XP e Level - MTA:SA

Sistema simples e eficiente de XP e Level com salvamento em banco de dados, ganho por kill e comandos básicos.

---

## 🚀 Funcionalidades

- Sistema de XP e Level automático  
- Salvamento em banco de dados (SQLite)  
- Level up automático baseado em XP  
- Ganho de XP ao matar jogadores  
- Cache em memória para melhor performance  
- ElementData sincronizado (XP e Level)  
- Comandos para teste e debug  

---

## 📂 Arquivos

- `server.lua` → Sistema completo de XP  
- `database.sqlite` → Banco de dados (criado automaticamente)  

---

## ⚙️ Configuração

No seu `settings.lua` (ou onde preferir):

```lua
settings = {
    ['GainExpForKill'] = 50 -- quantidade de XP ganha por kill
}
