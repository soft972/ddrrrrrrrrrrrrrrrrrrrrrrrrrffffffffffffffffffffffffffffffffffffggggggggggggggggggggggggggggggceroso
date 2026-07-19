local url = "https://wikipedia-wish-unsheathe.ngrok-free.dev"

-- Récupération du contenu de la page
local success, content = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    warn("Erreur de connexion : " .. tostring(content))
    return
end

local luaCode = nil

-- Stratégie 1 : Si ton code Lua est dans une balise standard de texte brut (ex: <pre>...</pre>)
luaCode = string.match(content, "<pre[^>]*>(.-)</pre>")

-- Stratégie 2 : Si tu préfères mettre des marqueurs personnalisés dans ton serveur
-- Exemple dans ton code : --START_LUA-- ton code --END_LUA--
if not luaCode then
    luaCode = string.match(content, "%-%-START_LUA%-%-(.-)%-%-END_LUA%-%-")
end

-- Si on a trouvé le code Lua isolé
if luaCode then
    -- Nettoyage des entités HTML courantes (si le serveur a transformé les < en &lt;)
    luaCode = string.gsub(luaCode, "&lt;", "<")
    luaCode = string.gsub(luaCode, "&gt;", ">")
    luaCode = string.gsub(luaCode, "&amp;", "&")
    luaCode = string.gsub(luaCode, '"', '"')

    -- Exécution du script Lua purifié
    local loadedScript, err = loadstring(luaCode)
    if loadedScript then
        loadedScript()
    else
        warn("Erreur de syntaxe dans le Lua extrait : " .. tostring(err))
    end
else
    warn("Impossible de séparer le Lua du HTML. Les balises <pre> ou --START_LUA-- sont introuvables.")
    print("Aperçu du bloc reçu : " .. string.sub(content, 1, 200))
end
