--[[
	SCP INTERFACE - V9.1 (UI POSITION FIX)
	Logic: UNTOUCHED
	Visuals: Button moved to Bottom-Left to avoid overlap
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local Config = require(ReplicatedStorage:WaitForChild("TeamConfig"))
local TeamEvent = ReplicatedStorage:WaitForChild("RequestTeamChange")
local WL_Remote = ReplicatedStorage:WaitForChild("WL_Manager_Function")

-- // 1. PALETTE DE COULEURS //
local COLORS = {
	Background  = Color3.fromRGB(20, 20, 25),
	Header      = Color3.fromRGB(30, 30, 35),
	Stroke      = Color3.fromRGB(60, 60, 70),
	Text        = Color3.fromRGB(240, 240, 240),
	TextDim     = Color3.fromRGB(150, 150, 150),

	WL          = Color3.fromRGB(255, 65, 65),
	XP          = Color3.fromRGB(0, 180, 255),
	Free        = Color3.fromRGB(100, 255, 120),
	Locked      = Color3.fromRGB(40, 25, 25),
	Hover       = Color3.fromRGB(45, 45, 50)
}

if PlayerGui:FindFirstChild("SCP_Menu_System") then
	PlayerGui.SCP_Menu_System:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SCP_Menu_System"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- // 2. NOTIFICATIONS //
local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Size = UDim2.new(0, 400, 0, 100)
NotifContainer.Position = UDim2.new(0.5, -200, 0, 60)
NotifContainer.BackgroundTransparency = 1

local function notify(title, msg, color)
	local label = Instance.new("TextLabel", NotifContainer)
	label.Size = UDim2.new(1, 0, 0, 40)
	label.Position = UDim2.new(0, 0, -1, 0)
	label.BackgroundColor3 = COLORS.Header
	label.TextColor3 = color or COLORS.Text
	label.Text = "  " .. title .. " : " .. msg
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", label)
	str.Color = color or COLORS.Text
	str.Thickness = 1

	label:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Back", 0.5)
	task.delay(4, function()
		label:TweenPosition(UDim2.new(0, 0, -1, 0), "In", "Quad", 0.3)
		task.wait(0.3)
		label:Destroy()
	end)
end

-- // 3. CADRE PRINCIPAL //
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 500)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = COLORS.Stroke
MainStroke.Thickness = 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = COLORS.Header
TopBar.BorderSizePixel = 0
local TopTitle = Instance.new("TextLabel", TopBar)
TopTitle.Size = UDim2.new(1, -20, 1, 0)
TopTitle.Position = UDim2.new(0, 20, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = Config.SiteName .. " // BASE DE DONNÉES DU PERSONNEL"
TopTitle.Font = Enum.Font.Michroma
TopTitle.TextSize = 16
TopTitle.TextColor3 = COLORS.Text
TopTitle.TextXAlignment = Enum.TextXAlignment.Left

local ScrollArea = Instance.new("ScrollingFrame", MainFrame)
ScrollArea.Name = "ScrollArea"
ScrollArea.Size = UDim2.new(1, -20, 1, -60)
ScrollArea.Position = UDim2.new(0, 10, 0, 55)
ScrollArea.BackgroundTransparency = 1
ScrollArea.ScrollBarThickness = 4
ScrollArea.ScrollBarImageColor3 = COLORS.Stroke
ScrollArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
local Layout = Instance.new("UIListLayout", ScrollArea)
Layout.Padding = UDim.new(0, 12)

-- // 4. CONSTRUCTION //
local function build()
	for _, child in pairs(ScrollArea:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	for i, catName in ipairs(Config.Order) do
		local teamsInCat = {}
		for _, t in pairs(Config.Teams) do
			if t.Category == catName then table.insert(teamsInCat, t) end
		end

		if #teamsInCat > 0 then
			local CatFrame = Instance.new("Frame", ScrollArea)
			CatFrame.Size = UDim2.new(1, -12, 0, 45)
			CatFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
			CatFrame.ClipsDescendants = true
			Instance.new("UICorner", CatFrame).CornerRadius = UDim.new(0, 6)
			local CatStroke = Instance.new("UIStroke", CatFrame)
			CatStroke.Color = COLORS.Stroke
			CatStroke.Thickness = 1
			CatStroke.Transparency = 0.5

			local Header = Instance.new("TextButton", CatFrame)
			Header.Size = UDim2.new(1, 0, 0, 45)
			Header.BackgroundTransparency = 1
			Header.Text = "      " .. catName:upper()
			Header.TextColor3 = COLORS.Text
			Header.Font = Enum.Font.GothamBold
			Header.TextSize = 13
			Header.TextXAlignment = Enum.TextXAlignment.Left

			local Arrow = Instance.new("TextLabel", Header)
			Arrow.Text = "▶"
			Arrow.Size = UDim2.new(0, 30, 1, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.TextColor3 = COLORS.XP
			Arrow.Font = Enum.Font.Gotham
			Arrow.TextSize = 12

			local Container = Instance.new("Frame", CatFrame)
			Container.Size = UDim2.new(1, 0, 0, 0)
			Container.Position = UDim2.new(0, 0, 0, 45)
			Container.BackgroundTransparency = 1
			local CLayout = Instance.new("UIListLayout", Container)
			CLayout.Padding = UDim.new(0, 4)

			local contentHeight = 0

			for _, data in pairs(teamsInCat) do
				local hasAccess = true
				if data.WL then
					local success, result = pcall(function()
						return WL_Remote:InvokeServer("CHECK", data.Name)
					end)
					hasAccess = success and result
				end

				local tBtn = Instance.new("TextButton", Container)
				tBtn.Size = UDim2.new(0.95, 0, 0, 38)
				tBtn.AnchorPoint = Vector2.new(0.5, 0)
				tBtn.Position = UDim2.new(0.5, 0, 0, 0)
				tBtn.Font = Enum.Font.GothamMedium
				tBtn.TextSize = 13
				tBtn.TextXAlignment = Enum.TextXAlignment.Left
				tBtn.AutoButtonColor = false

				Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 4)
				local btnStroke = Instance.new("UIStroke", tBtn)
				btnStroke.Thickness = 1
				btnStroke.Transparency = 0.8

				local Indicator = Instance.new("Frame", tBtn)
				Indicator.Size = UDim2.new(0, 3, 0, 18)
				Indicator.Position = UDim2.new(0, 10, 0.5, -9)
				Indicator.BorderSizePixel = 0

				if not hasAccess then
					tBtn.BackgroundColor3 = COLORS.Locked
					tBtn.Text = "          " .. data.Name .. " [VERROUILLÉ]"
					tBtn.TextColor3 = COLORS.TextDim
					btnStroke.Color = Color3.fromRGB(60, 40, 40)
					Indicator.BackgroundColor3 = COLORS.TextDim
				else
					tBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
					tBtn.Text = "          " .. data.Name
					btnStroke.Color = COLORS.Stroke

					if data.WL then
						tBtn.TextColor3 = COLORS.Text
						Indicator.BackgroundColor3 = COLORS.WL
					elseif data.XP > 0 then
						tBtn.TextColor3 = COLORS.Text
						Indicator.BackgroundColor3 = COLORS.XP

						local xpLabel = Instance.new("TextLabel", tBtn)
						xpLabel.Text = data.XP .. " XP"
						xpLabel.Size = UDim2.new(0, 60, 1, 0)
						xpLabel.Position = UDim2.new(1, -70, 0, 0)
						xpLabel.BackgroundTransparency = 1
						xpLabel.TextColor3 = COLORS.XP
						xpLabel.Font = Enum.Font.Gotham
						xpLabel.TextSize = 11
						xpLabel.TextXAlignment = Enum.TextXAlignment.Right
					else
						tBtn.TextColor3 = COLORS.Text
						Indicator.BackgroundColor3 = COLORS.Free
					end
				end

				if hasAccess then
					tBtn.MouseEnter:Connect(function()
						TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Hover}):Play()
					end)
					tBtn.MouseLeave:Connect(function()
						TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
					end)
				end

				tBtn.MouseButton1Click:Connect(function()
					if hasAccess then
						TeamEvent:FireServer(data.Name)
						MainFrame.Visible = false
					else
						notify("ACCÈS REFUSÉ", "Vous n'avez pas l'accréditation requise.", COLORS.WL)
					end
				end)
				contentHeight += 42
			end

			local active = false
			Header.MouseButton1Click:Connect(function()
				active = not active
				Arrow.Rotation = active and 90 or 0
				local targetH = active and (55 + contentHeight) or 45
				TweenService:Create(CatFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -12, 0, targetH)}):Play()
			end)
		end
	end
end

-- // 5. BOUTON D'OUVERTURE (EN BAS À GAUCHE) //
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "OpenMenu"
OpenBtn.Size = UDim2.new(0, 220, 0, 45)
OpenBtn.AnchorPoint = Vector2.new(0, 1) -- Changement d'ancrage (Bas-Gauche)
OpenBtn.Position = UDim2.new(0, 30, 1, -30) -- 30 pixels depuis la gauche, 30 pixels du bas
OpenBtn.BackgroundColor3 = COLORS.Header
OpenBtn.Text = "MENU DE DÉPLOIEMENT"
OpenBtn.Font = Enum.Font.Michroma
OpenBtn.TextColor3 = COLORS.Text
OpenBtn.TextSize = 14
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = COLORS.Stroke
OpenStroke.Thickness = 2
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Effet Hover (Adapté pour l'alignement gauche)
OpenBtn.MouseEnter:Connect(function()
	TweenService:Create(OpenBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Hover, Size = UDim2.new(0, 230, 0, 48)}):Play()
end)
OpenBtn.MouseLeave:Connect(function()
	TweenService:Create(OpenBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Header, Size = UDim2.new(0, 220, 0, 45)}):Play()
end)

-- // EVENTS //
TeamEvent.OnClientEvent:Connect(function(mode, title, msg)
	if mode == "RefreshWL" then
		if MainFrame.Visible then build() end
	elseif mode == "Error" then
		notify(title, msg, COLORS.WL)
	end
end)

local function toggle()
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then 
		build()
		MainFrame.Size = UDim2.new(0, 850, 0, 480)
		MainFrame.BackgroundTransparency = 1
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 850, 0, 500), BackgroundTransparency = 0}):Play()
	end
end

OpenBtn.MouseButton1Click:Connect(toggle)
