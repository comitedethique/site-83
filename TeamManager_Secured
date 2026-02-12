--[[
	SCP SITE-83 - GLOBAL TEAM & XP HANDLER (FINAL PATCH)
	Correction : Utilisation de _G.CheckWL pour éviter l'erreur de callback.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local Config = require(ReplicatedStorage:WaitForChild("TeamConfig"))
local TeamEvent = ReplicatedStorage:WaitForChild("RequestTeamChange")
local XPStore = DataStoreService:GetDataStore(Config.System.XP_DataStore)

-- ==========================================
-- 1. GESTION DE L'XP (Leaderstats)
-- ==========================================
Players.PlayerAdded:Connect(function(player)
	local ls = Instance.new("Folder", player)
	ls.Name = "leaderstats"
	local xp = Instance.new("IntValue", ls)
	xp.Name = "XP"

	local success, data = pcall(function() return XPStore:GetAsync(tostring(player.UserId)) end)
	xp.Value = (success and data) or 0

	task.spawn(function()
		while player.Parent do
			task.wait(Config.System.Interval)
			if player:FindFirstChild("leaderstats") then
				player.leaderstats.XP.Value += Config.System.XPGain
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if player:FindFirstChild("leaderstats") then
		pcall(function() XPStore:SetAsync(tostring(player.UserId), player.leaderstats.XP.Value) end)
	end
end)

-- ==========================================
-- 2. CHANGEMENT D'ÉQUIPE SÉCURISÉ
-- ==========================================
TeamEvent.OnServerEvent:Connect(function(player, teamName)
	if typeof(teamName) ~= "string" then return end

	local teamInfo = nil
	for _, t in pairs(Config.Teams) do
		if t.Name == teamName then teamInfo = t break end
	end

	if not teamInfo then 
		warn("⚠️ [DEPLOY] Team '" .. teamName .. "' absente du TeamConfig.")
		return 
	end

	local robloxTeam = Teams:FindFirstChild(teamName)
	if not robloxTeam then
		warn("❌ [DEPLOY] L'équipe '" .. teamName .. "' n'existe pas dans Teams !")
		return
	end

	-- // VÉRIFICATION WL (FIXÉ VIA _G) //
	if teamInfo.WL then
		if _G.CheckWL then
			-- On appelle directement la fonction partagée par le WL_Manager_System
			local hasAccess = _G.CheckWL(player, teamName)

			if not hasAccess then
				TeamEvent:FireClient(player, "Error", "Accès Refusé", "Tu n'as pas la Whitelist pour rejoindre " .. teamName)
				return
			end
		else
			-- Sécurité au cas où le script de WL n'a pas encore fini de charger
			warn("❌ [WL] Le système de Whitelist n'est pas encore prêt !")
			TeamEvent:FireClient(player, "Error", "Erreur Système", "Le système de Whitelist charge encore...")
			return
		end
	end

	-- // VÉRIFICATION XP //
	local currentXP = (player:FindFirstChild("leaderstats") and player.leaderstats.XP.Value) or 0
	if currentXP < teamInfo.XP then
		TeamEvent:FireClient(player, "Error", "XP Insuffisante", "Il te faut " .. teamInfo.XP .. " XP.")
		return
	end

	-- // DÉPLOIEMENT //
	player.Team = robloxTeam
	player:LoadCharacter()
	print("✅ [DEPLOY] " .. player.Name .. " -> " .. teamName)
end)
