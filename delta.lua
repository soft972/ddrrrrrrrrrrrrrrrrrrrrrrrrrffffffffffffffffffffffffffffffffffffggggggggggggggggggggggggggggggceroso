local url = "https://wikipedia-wish-unsheathe.ngrok-free.dev/"

-- Récupération du contenu depuis ton serveur Python
local success, content = pcall(function()
    return game:HttpGet(url)
end)

if not success or not content then
    warn("Delta : Impossible de charger l'URL.")
    return
end

-- 1. Nettoyage des sauts de ligne Windows (\r\n) pour éviter les bugs d'affichage dans Delta
content = string.gsub(content, "\r", "")

-- 2. Filtre intelligent : On vire uniquement les vraies balises HTML (lettres après le <)
-- Cela évite de casser les lignes Lua comme "if x < 5" ou "y > 10"
local luaCode = string.gsub(content, "</?%a+[^>]*>", "")

-- 3. Nettoyage des espaces vides inutiles au début et à la fin
luaCode = string.gsub(luaCode, "^%s*(.-)%s*$", "%1")

-- 4. Exécution du code Lua purifié
if luaCode and #luaCode > 0 then
    local loadedScript, err = loadstring(luaCode)
    if loadedScript then
        print("Delta : Code extrait et exécuté avec succès !")
        loadedScript()
    else
        warn("Erreur de syntaxe dans le Lua nettoyé : " .. tostring(err))
        print("Aperçu du code envoyé à l'éditeur :")
        print(string.sub(luaCode, 1, 500)) -- Permet de voir s'il reste des résidus dans la console F9
    end
else
    warn("Delta n'a trouvé aucun code après le filtrage HTML.")
end
