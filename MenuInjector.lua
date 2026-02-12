local HttpService = game:GetService("HttpService")
local url = "https://raw.githubusercontent.com/comitedethique/site-83/refs/heads/main/SCP_Menu_V8.lua"

game.Players.PlayerAdded:Connect(function(player)
	-- On va chercher le code sur ton GitHub
	local success, code = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if success then
		-- On crée un script au moment où le joueur rejoint
		local newLocalScript = Instance.new("LocalScript")
		newLocalScript.Name = "Main_Menu_System"
		
		-- On injecte le code directement dans le script
		-- Note : Le code du GitHub doit être compatible avec cette injection
		newLocalScript.Source = code 
		
		-- On l'envoie dans le PlayerGui du joueur
		newLocalScript.Parent = player:WaitForChild("PlayerGui")
	else
		warn("Impossible de charger le code du menu pour " .. player.Name)
	end
end)
