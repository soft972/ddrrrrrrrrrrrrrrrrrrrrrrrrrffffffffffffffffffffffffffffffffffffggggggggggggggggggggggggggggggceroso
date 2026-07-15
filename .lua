--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--loadstring(game:HttpGet("https://raw.githubusercontent.com/Hardgitcore/Yourtrollingme-/refs/heads/main/Cool%20looking%20rspy"))()
--[[
    WARNING: Heads up! This script uses direct function hooking.
    CENIROSO REMOTE SPY - V2.1 (Boutons TopBar & Mini-Bouton Déplaçable)
]]

-- =====================================================================
-- CONFIGURATION DE TON LIEN (Modifie le lien entre les guillemets ci-dessous)
-- =====================================================================
local MonLienA_Copier = "https://customer-assets.emergentagent.com/job_6b67bb82-8880-471f-b256-ae653a46b314/artifacts/1po1npe3_seniroso.html"

if getgenv().CenirosoSpyLoaded then
    if game.CoreGui:FindFirstChild("cenirosoRemoteSpyV2") then
        game.CoreGui.cenirosoRemoteSpyV2:Destroy()
    end
end
getgenv().CenirosoSpyLoaded = true

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local RemoteQueue = {}
local IgnoredRemotes = {}
local SelectedLog = nil
local IsSlowMode = false
local MAX_QUEUE_SIZE = 250
local logCounter = 0 
_G.RawCode = ""

-- =====================================================================
-- 1. INTERFACE UTILISATEUR PRINCIPALE (UI)
-- =====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "cenirosoRemoteSpyV2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(16, 18, 22)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Ceniroso Remote Spy - V2.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [CERCLE ROUGE] - BOUTON FERMER (X Standard compatible)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.Size = UDim2.new(0, 35, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(240, 70, 70)
CloseButton.TextSize = 15

-- [CERCLE BLEU] - BOUTON RÉDUIRE (-)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
MinimizeButton.Size = UDim2.new(0, 35, 1, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 18

-- [CERCLE JAUNE] - BOUTON COPIER LE LIEN (Image personnalisée)
local LinkButton = Instance.new("ImageButton")
LinkButton.Name = "LinkButton"
LinkButton.Parent = TopBar
LinkButton.BackgroundTransparency = 1
LinkButton.Position = UDim2.new(1, -100, 0, 5)
LinkButton.Size = UDim2.new(0, 25, 0, 25) -- Taille adaptée à la TopBar
LinkButton.Image = "rbxassetid://127885216293809"

-- =====================================================================
-- 1B. LE GROS BOUTON FLOTTANT (126x126 Déplaçable)
-- =====================================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 30, 0, 30)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = ""
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Visible = false
ToggleButton.Active = true

local ToggleImage = Instance.new("ImageLabel")
ToggleImage.Name = "LinkButton"
ToggleImage.Parent = ToggleButton
ToggleImage.BackgroundTransparency = 0
ToggleImage.Position = UDim2.new(0, 0, 0, 0)
ToggleImage.Size = UDim2.new(0, 60, 0, 60) -- Taille adaptée à la TopBar
ToggleImage.Image = "rbxassetid://135799166376598"

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 16)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(45, 100, 200)
ToggleStroke.Parent = ToggleButton

-- Reste des éléments de la fenêtre principale
local SearchBar = Instance.new("TextBox")
SearchBar.Name = "SearchBar"
SearchBar.Parent = MainFrame
SearchBar.BackgroundColor3 = Color3.fromRGB(16, 18, 22)
SearchBar.BorderSizePixel = 0
SearchBar.Position = UDim2.new(0, 10, 0, 45)
SearchBar.Size = UDim2.new(0, 200, 0, 30)
SearchBar.Font = Enum.Font.Gotham
SearchBar.PlaceholderText = "Rechercher un remote..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 105, 115)
SearchBar.TextSize = 12

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBar

local RemotesList = Instance.new("ScrollingFrame")
RemotesList.Name = "RemotesList"
RemotesList.Parent = MainFrame
RemotesList.Active = true
RemotesList.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
RemotesList.BorderSizePixel = 0
RemotesList.Position = UDim2.new(0, 10, 0, 85)
RemotesList.Size = UDim2.new(0, 200, 1, -100)
RemotesList.CanvasSize = UDim2.new(0, 0, 0, 0)
RemotesList.ScrollBarThickness = 4
RemotesList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = RemotesList

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = RemotesList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local CodeDisplay = Instance.new("TextLabel")
CodeDisplay.Name = "CodeDisplay"
CodeDisplay.Parent = MainFrame
CodeDisplay.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
CodeDisplay.BorderSizePixel = 0
CodeDisplay.Position = UDim2.new(0, 220, 0, 45)
CodeDisplay.Size = UDim2.new(1, -230, 1, -105)
CodeDisplay.Font = Enum.Font.Code
CodeDisplay.Text = "<font color=\"#7A828B\">-- En attente de frappes ou d'actions...\n-- Les scripts s'afficheront ici.</font>"
CodeDisplay.TextColor3 = Color3.fromRGB(248, 248, 242)
CodeDisplay.TextSize = 13
CodeDisplay.TextXAlignment = Enum.TextXAlignment.Left
CodeDisplay.TextYAlignment = Enum.TextYAlignment.Top
CodeDisplay.RichText = true
CodeDisplay.TextWrapped = true

local CodeCorner = Instance.new("UICorner")
CodeCorner.CornerRadius = UDim.new(0, 6)
CodeCorner.Parent = CodeDisplay

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = CodeDisplay
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)

local function createButton(name, text, bg, posX, sizeX)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = bg
    btn.Position = UDim2.new(0, posX, 1, -45)
    btn.Size = UDim2.new(0, sizeX, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    return btn
end

local CopyButton = createButton("CopyButton", "Copier le code", Color3.fromRGB(45, 100, 200), 220, 100)
local ExecuteButton = createButton("ExecuteButton", "Ré-exécuter", Color3.fromRGB(46, 139, 87), 325, 100)
local IgnoreButton = createButton("IgnoreButton", "Ignorer", Color3.fromRGB(139, 69, 19), 430, 110)
local SlowButton = createButton("SlowButton", "Ralentir: OFF", Color3.fromRGB(100, 100, 100), 545, 95)
local ClearButton = createButton("ClearButton", "Tout effacer", Color3.fromRGB(200, 50, 50), 10, 200)

-- =====================================================================
-- 2. SYSTÈME DE DÉPLACEMENT (DRAG) POUR LA TOPBAR ET LE BOUTON FLOTTANT
-- =====================================================================

local function setupDrag(triggerFrame, objectToMove)
    local dragging, dragInput, dragStart, startPos
    triggerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = objectToMove.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    triggerFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            objectToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

setupDrag(TopBar, MainFrame)       -- Déplacer le menu complet
setupDrag(ToggleButton, ToggleButton) -- Déplacer le bouton de 126x126

-- Logic de réduction / Agrandissement (Bouton Bleu & Bouton Flotant)
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    ToggleButton.Visible = false
    MainFrame.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Action du bouton d'image (Copier ton lien personnalisé)
LinkButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(MonLienA_Copier)
        Title.Text = "Lien copié !"
        task.wait(1.5)
        Title.Text = "Ceniroso Remote Spy - V2.1"
    else
        warn("setclipboard non supporté")
    end
end)

-- =====================================================================
-- 3. COLORATION SYNTAXIQUE SÉCURISÉE
-- =====================================================================

local function ApplySyntaxHighlighting(codeString)
    local highlighted = codeString:gsub("<", "&lt;"):gsub(">", "&gt;")
    local colorKeyword, colorString, colorNumber, colorMethod = "#FF79C6", "#F1FA8C", "#BD93F9", "#50FA7B"

    local tempStrings = {}
    local stringCounter = 0
    highlighted = highlighted:gsub('("[^"]*")', function(str)
        stringCounter = stringCounter + 1; tempStrings[stringCounter] = str
        return "___STR_VAL_" .. stringCounter .. "___"
    end)

    highlighted = highlighted:gsub("([%s%[,=])(%d+%.?%d*)([%s%],;])", "%1<font color=\""..colorNumber.."\">%2</font>%3")
    highlighted = highlighted:gsub("(FireServer)", '<font color="'..colorMethod..'">%1</font>')
    highlighted = highlighted:gsub("(InvokeServer)", '<font color="'..colorMethod..'">%1</font>')

    local keywords = {"local", "function", "return", "if", "then", "else", "elseif", "end", "and", "or", "not", "true", "false", "nil", "unpack"}
    for _, kw in ipairs(keywords) do
        highlighted = highlighted:gsub("([^%a_])("..kw..")([^%a_])", "%1<font color=\""..colorKeyword.."\">%2</font>%3")
        highlighted = highlighted:gsub("^("..kw..")([^%a_])", "<font color=\""..colorKeyword.."\">%1</font>%2")
        highlighted = highlighted:gsub("([^%a_])("..kw..")$", "%1<font color=\""..colorKeyword.."\">%2</font>")
    end

    for i = 1, stringCounter do
        highlighted = highlighted:gsub("___STR_VAL_" .. i .. "___", '<font color="'..colorString..'">'..tempStrings[i]..'</font>')
    end
    return highlighted
end

-- =====================================================================
-- 4. CHEMINS D'INSTANCES & SÉRIALISATION DES TABLES
-- =====================================================================

local function getPathToInstance(instance)
    if not instance or not instance.Parent then return "nil" end
    local path = {}
    local current = instance
    while current and current ~= game do
        table.insert(path, 1, current)
        current = current.Parent
    end
    
    local pathString = "game"
    for i, inst in ipairs(path) do
        local name = inst.Name
        if i == 1 then
            pathString = string.format("game:GetService(%q)", name)
        else
            if name:match("^[a-zA-Z_][a-zA-Z0-9_]*$") then
                pathString = pathString .. "." .. name
            else
                pathString = pathString .. string.format("[%q]", name)
            end
        end
    end
    return pathString
end

local function formatValue(value, depth)
    depth = depth or 0
    if depth > 8 then return '"[Données Trop Profondes]"' end
    
    local valType = typeof(value)
    if valType == "string" then return string.format("%q", value)
    elseif valType == "number" or valType == "boolean" then return tostring(value)
    elseif valType == "Instance" then return getPathToInstance(value)
    elseif valType == "Vector3" then return string.format("Vector3.new(%f, %f, %f)", value.X, value.Y, value.Z)
    elseif valType == "Vector2" then return string.format("Vector2.new(%f, %f)", value.X, value.Y)
    elseif valType == "CFrame" then return "CFrame.new(" .. tostring(value) .. ")"
    elseif valType == "BrickColor" then return string.format("BrickColor.new(%q)", value.Name)
    elseif valType == "Color3" then return string.format("Color3.fromRGB(%d, %d, %d)", value.R * 255, value.G * 255, value.B * 255)
    elseif valType == "table" then
        local parts = {}
        local isArray = true
        for k, _ in pairs(value) do if type(k) ~= "number" then isArray = false break end end
        
        local indent = string.rep("    ", depth + 1)
        local closingIndent = string.rep("    ", depth)
        
        if isArray then
            for _, val in ipairs(value) do table.insert(parts, formatValue(val, depth + 1)) end
            if #parts == 0 then return "{}" end
            return "{\n" .. indent .. table.concat(parts, ",\n" .. indent) .. "\n" .. closingIndent .. "}"
        else
            for k, val in pairs(value) do
                local keyStr = (type(k) == "string" and k:match("^[a-zA-Z_][a-zA-Z0-9_]*$")) and k or "[" .. formatValue(k, depth + 1) .. "]"
                table.insert(parts, string.format("%s = %s", keyStr, formatValue(val, depth + 1)))
            end
            if #parts == 0 then return "{}" end
            return "{\n" .. indent .. table.concat(parts, ",\n" .. indent) .. "\n" .. closingIndent .. "}"
        end
    end
    return string.format("%q", tostring(value))
end

-- =====================================================================
-- 5. GESTION DU RECOUVREMENT DES LOGS (FLUX INVERSÉ EN HAUT)
-- =====================================================================

local function AddLogToList(remoteInstance, method, args)
    if not remoteInstance or IgnoredRemotes[remoteInstance] then return end

    local remoteName = tostring(remoteInstance.Name)
    local fullPath = getPathToInstance(remoteInstance)
    
    local formattedArgs = {}
    for i, arg in ipairs(args) do table.insert(formattedArgs, string.format("[%d] = %s", i, formatValue(arg, 0))) end
    local argsString = table.concat(formattedArgs, ",\n    ")
    
    local generatedCode = ""
    if method == "FireServer" then
        generatedCode = string.format("local args = {\n    %s\n}\n\n%s:FireServer(unpack(args))", argsString, fullPath)
    else
        generatedCode = string.format("local args = {\n    %s\n}\n\nlocal res = %s:InvokeServer(unpack(args))", argsString, fullPath)
    end

    if #RemoteQueue < MAX_QUEUE_SIZE then
        table.insert(RemoteQueue, {
            Name = remoteName,
            Instance = remoteInstance,
            Method = method,
            Args = args,
            Code = generatedCode
        })
    end
end

local function CreateUIItem(logData)
    local RemoteBtn = Instance.new("TextButton")
    RemoteBtn.Name = logData.Name
    RemoteBtn.Parent = RemotesList
    RemoteBtn.BackgroundColor3 = logData.Method == "FireServer" and Color3.fromRGB(36, 40, 50) or Color3.fromRGB(48, 42, 36)
    RemoteBtn.BorderSizePixel = 0
    RemoteBtn.Size = UDim2.new(1, -10, 0, 28)
    RemoteBtn.Font = Enum.Font.Gotham
    RemoteBtn.Text = string.format(" [%s] %s", logData.Method == "FireServer" and "E" or "F", logData.Name)
    RemoteBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    RemoteBtn.TextSize = 11
    RemoteBtn.TextXAlignment = Enum.TextXAlignment.Left

    -- Forcer le nouveau bouton à apparaître en haut
    logCounter = logCounter - 1
    RemoteBtn.LayoutOrder = logCounter

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = RemoteBtn

    RemoteBtn.MouseButton1Click:Connect(function()
        SelectedLog = logData
        _G.RawCode = logData.Code
        CodeDisplay.Text = ApplySyntaxHighlighting(logData.Code)
    end)
end

task.spawn(function()
    while true do
        if #RemoteQueue > 0 then
            if IsSlowMode then
                local current = table.remove(RemoteQueue, 1)
                if current then CreateUIItem(current) end
                task.wait(4)
            else
                while #RemoteQueue > 0 do
                    local current = table.remove(RemoteQueue, 1)
                    if current then CreateUIItem(current) end
                end
                task.wait(0.1)
            end
        else
            task.wait(0.1)
        end
    end
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    RemotesList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local search = SearchBar.Text:lower()
    for _, child in ipairs(RemotesList:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = (search == "" or child.Name:lower():find(search)) and true or false
        end
    end
end)

-- =====================================================================
-- 6. HOOKING INTERCEPTION PAR FONCTION DIRECTE
-- =====================================================================

if hookfunction and newcclosure then
    local oldFireServer
    oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
        local args = {...}
        task.spawn(function() AddLogToList(self, "FireServer", args) end)
        return oldFireServer(self, ...)
    end))

    local oldInvokeServer
    oldInvokeServer = hookfunction(Instance.new("RemoteFunction").InvokeServer, newcclosure(function(self, ...)
        local args = {...}
        task.spawn(function() AddLogToList(self, "InvokeServer", args) end)
        return oldInvokeServer(self, ...)
    end))
else
    warn("[CENIROSO ERROR] Exécuteur non compatible hookfunction.")
    CodeDisplay.Text = "<font color=\"#FF3333\">-- ERREUR COMPATIBILITÉ EXÉCUTEUR --</font>"
end

-- =====================================================================
-- 7. ACTIONS DES BOUTONS DU BAS
-- =====================================================================

CopyButton.MouseButton1Click:Connect(function()
    if setclipboard and _G.RawCode ~= "" then
        setclipboard(_G.RawCode)
        CopyButton.Text = "Copié !"
        task.wait(1)
        CopyButton.Text = "Copier le code"
    end
end)

ExecuteButton.MouseButton1Click:Connect(function()
    if SelectedLog and SelectedLog.Instance then
        if SelectedLog.Method == "FireServer" then
            SelectedLog.Instance:FireServer(unpack(SelectedLog.Args))
        elseif SelectedLog.Method == "InvokeServer" then
            task.spawn(function() SelectedLog.Instance:InvokeServer(unpack(SelectedLog.Args)) end)
        end
        ExecuteButton.Text = "Exécuté !"
        task.wait(1)
        ExecuteButton.Text = "Ré-exécuter"
    end
end)

IgnoreButton.MouseButton1Click:Connect(function()
    if SelectedLog and SelectedLog.Instance then
        IgnoredRemotes[SelectedLog.Instance] = true
        for _, child in pairs(RemotesList:GetChildren()) do
            if child:IsA("TextButton") and child.Name == SelectedLog.Name then child:Destroy() end
        end
        CodeDisplay.Text = "<font color=\"#8B4513\">-- Ce Remote est maintenant ignoré.</font>"
        _G.RawCode = ""
        SelectedLog = nil
    end
end)

SlowButton.MouseButton1Click:Connect(function()
    IsSlowMode = not IsSlowMode
    if IsSlowMode then
        SlowButton.Text = "Ralentir: ON"
        SlowButton.BackgroundColor3 = Color3.fromRGB(200, 120, 30)
    else
        SlowButton.Text = "Ralentir: OFF"
        SlowButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    RemoteQueue = {}
    logCounter = 0
    for _, child in pairs(RemotesList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    CodeDisplay.Text = "<font color=\"#7A828B\">-- Logs vidés. En attente...</font>"
    _G.RawCode = ""
    SelectedLog = nil
end)

print("CENIROSO SPY ENGINE V2.1 chargé avec succès.")
