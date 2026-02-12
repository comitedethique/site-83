local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamConfig"))
if not Config or not Config.SiteName then 
    script.Parent:Destroy() -- Détruit le menu si la config GitHub ne répond pas
    return 
end
