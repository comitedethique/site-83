--[[
	SCP SITE-83 - WL_Manager_System (V4.6)
	- Système de Whitelist Intégral (DataStore)
	- Support Panel F2 & Commandes Chat
	- FIX : Insensibilité à la casse (majuscules/minuscules)
	- FIX : Gestion automatique des Catégories -> Teams
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local WL_DataStore = DataStoreService:GetDataStore("Site83_WL_FinalV1")
local Config = require(ReplicatedStorage:WaitForChild("TeamConfig"))

local STAFF_IDS = {}
for _, id in pairs(Config.System.WL_AdminID) do STAFF_IDS[id] = true end

-- Table des permissions (Nettoyée des caractères invisibles)
local PERMS = {
	["SÉCURITÉ DU SITE"] = {814033297, 2024799179, 3125771066, 8446495403, 126633983},
	["DÉPARTEMENT MÉDICAL"] = {814033297, 2643571054},
	["DI&ST"] = {814033297, 2668800571},
	["DÉPARTEMENT SCIENTIFIQUE"] = {814033297},
	["ADMINISTRATION"] = {814033297, 2065341759},
	["Détachement Bravo"] = {814033297, 2065341759,126633983},
	["CONFORMITÉ & JUSTICE"] = {814033297},
	["FORCES D'INTERVENTION"] = {814033297},
	["HAUT COMMANDEMENT"] = {814033297, 2209072588},
	["GROUPES D'INTÉRÊT"] = {814033297},

	["Bêta-1"] = {814033297},
	["A1"] = {814033297, 1419527818},
	["O.1"] = {814033297, 3689433340},
	["O.F.I.M"] = {814033297, 2024799179, 2065341759, 8446495403},
	["P.I"] = {814033297},
	["Escouade Zulu"] = {814033297},
	["Comité d'Ethique"] = {814033297, 3689433340},
	["Justice Internes"] = {814033297, 2675984059},
	["BRF"] = {814033297},
	["Insurrection Du Chaos"] = {814033297}
}

local PlayerData = {}

-- Fonction utilitaire pour nettoyer les textes (enlève espaces et majuscules)
local function sanitize(txt)
	return string.lower(string.gsub(txt, "^%s*(.-)%s*$", "%1"))
end

-- // CHARGEMENT DES DONNÉES //
local function loadData(p)
	local userId = tostring(p.UserId)
	local success, data = pcall(function() return WL_DataStore:GetAsync(userId) end)
	PlayerData[userId] = (success and data) or {}
	print("📂 [WL] Données chargées pour " .. p.Name)
end

-- On charge les joueurs déjà là + les nouveaux
for _, p in pairs(Players:GetPlayers()) do loadData(p) end
Players.PlayerAdded:Connect(loadData)

-- // LOGIQUE DE VÉRIFICATION INTELLIGENTE //
local function handleCheck(player, teamOrCat)
	if not player then return false end
	if STAFF_IDS[player.UserId] then return true end

	local data = PlayerData[tostring(player.UserId)]
	if not data then return false end

	local search = sanitize(teamOrCat)

	-- 1. Vérification Directe (si le joueur a la WL précise)
	for wlName, status in pairs(data) do
		if sanitize(wlName) == search and status == true then
			return true
		end
	end

	-- 2. Vérification par Catégorie (si le joueur a la WL du département)
	for _, teamData in pairs(Config.Teams) do
		if sanitize(teamData.Name) == search then
			local category = teamData.Category
			if category then
				local searchCat = sanitize(category)
				for wlName, status in pairs(data) do
					if sanitize(wlName) == searchCat and status == true then
						print("✅ [WL] Accès via Catégorie: " .. category)
						return true
					end
				end
			end
		end
	end

	return false
end

-- // ACTIONS PANEL F2 //
local function findTrailingPlayer(name)
	name = sanitize(name)
	for _, p in pairs(Players:GetPlayers()) do
		if sanitize(p.Name):sub(1, #name) == name or sanitize(p.DisplayName):sub(1, #name) == name then
			return p
		end
	end
	return nil
end

local function setWL(targetPlayer, teamName, status)
	local userId = tostring(targetPlayer.UserId)
	if not PlayerData[userId] then PlayerData[userId] = {} end

	PlayerData[userId][teamName] = status

	local success, err = pcall(function() 
		WL_DataStore:SetAsync(userId, PlayerData[userId]) 
	end)

	if success then
		print("🛡️ [WL UPDATE] " .. targetPlayer.Name .. " | " .. teamName .. " = " .. tostring(status))
		local event = ReplicatedStorage:FindFirstChild("RequestTeamChange")
		if event then event:FireClient(targetPlayer, "RefreshWL") end
	else
		warn("❌ [WL ERROR] " .. tostring(err))
	end
end

local function canManageWL(userId, targetName)
	if STAFF_IDS[userId] then return true end
	local search = sanitize(targetName)
	for permName, ids in pairs(PERMS) do
		if sanitize(permName) == search then
			for _, id in pairs(ids) do if id == userId then return true end end
		end
	end
	return false
end

-- // COMMUNICATION //
local WL_Remote = ReplicatedStorage:FindFirstChild("WL_Manager_Function") or Instance.new("RemoteFunction")
WL_Remote.Name = "WL_Manager_Function"
WL_Remote.Parent = ReplicatedStorage

WL_Remote.OnServerInvoke = function(player, action, arg1, arg2)
	if action == "CHECK" then return handleCheck(player, arg1) end
	if action == "CHECK_GIVER" then return canManageWL(player.UserId, arg2) end
	if action == "ADD" or action == "REMOVE" then
		if canManageWL(player.UserId, arg2) then
			local target = findTrailingPlayer(arg1)
			if target then setWL(target, arg2, (action == "ADD")) return true end
		end
	end
	return false
end

_G.CheckWL = function(player, teamName) return handleCheck(player, teamName) end

-- // COMMANDES CHAT //
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		local args = string.split(msg, " ")
		local cmd = args[1]:lower()
		if (cmd == "!wl" or cmd == "!unwl") and STAFF_IDS[player.UserId] then
			local target = findTrailingPlayer(args[2] or "")
			local team = msg:match('"(.-)"') or args[3]
			if target and team then setWL(target, team, (cmd == "!wl")) end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(p)
	local userId = tostring(p.UserId)
	if PlayerData[userId] then
		pcall(function() WL_DataStore:SetAsync(userId, PlayerData[userId]) end)
		PlayerData[userId] = nil
	end
end)
