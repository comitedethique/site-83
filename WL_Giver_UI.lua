--[[
	SCP SITE-83 - WL GIVER UI (V2.1 FIXED TRANSPARENCY)
	Logic: UNTOUCHED
	Visuals: Fixed Transparency Bug
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Config = require(ReplicatedStorage:WaitForChild("TeamConfig"))

local WL_Remote = ReplicatedStorage:WaitForChild("WL_Manager_Function", 15)

if PlayerGui:FindFirstChild("WL_Giver_System") then
	PlayerGui.WL_Giver_System:Destroy()
end

local isAdmin = false
for _, id in pairs(Config.System.WL_AdminID) do
	if id == player.UserId then isAdmin = true break end
end

local COLORS = {
	Bg      = Color3.fromRGB(20, 20, 25),
	Header  = Color3.fromRGB(30, 30, 35),
	Item    = Color3.fromRGB(28, 28, 32),
	Stroke  = Color3.fromRGB(60, 60, 70),
	Text    = Color3.fromRGB(240, 240, 240),
	Green   = Color3.fromRGB(46, 204, 113),
	Red     = Color3.fromRGB(231, 76, 60),
	Hover   = Color3.fromRGB(45, 45, 50)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WL_Giver_System"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 -- Très haut pour être sûr
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = COLORS.Bg
MainFrame.BackgroundTransparency = 0 -- FORCE L'OPACITÉ
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = COLORS.Stroke
MainStroke.Thickness = 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = COLORS.Header
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local HideBottomCorner = Instance.new("Frame", TopBar)
HideBottomCorner.Size = UDim2.new(1, 0, 0, 10)
HideBottomCorner.Position = UDim2.new(0, 0, 1, -10)
HideBottomCorner.BackgroundColor3 = COLORS.Header
HideBottomCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "PANNEAU D'ADMINISTRATION // WL"
Title.TextColor3 = COLORS.Text
Title.Font = Enum.Font.Michroma
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local SearchContainer = Instance.new("Frame", MainFrame)
SearchContainer.Size = UDim2.new(0, 400, 0, 40)
SearchContainer.Position = UDim2.new(0.5, -200, 0.12, 0)
SearchContainer.BackgroundColor3 = COLORS.Item
SearchContainer.Parent = MainFrame
Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 6)
local SearchStroke = Instance.new("UIStroke", SearchContainer)
SearchStroke.Color = COLORS.Stroke
SearchStroke.Thickness = 1

local SearchPlayer = Instance.new("TextBox")
SearchPlayer.Size = UDim2.new(1, -20, 1, 0)
SearchPlayer.Position = UDim2.new(0, 10, 0, 0)
SearchPlayer.PlaceholderText = "Entrez le pseudo du joueur..."
SearchPlayer.Text = ""
SearchPlayer.BackgroundTransparency = 1
SearchPlayer.TextColor3 = COLORS.Text
SearchPlayer.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SearchPlayer.Font = Enum.Font.GothamMedium
SearchPlayer.TextSize = 14
SearchPlayer.TextXAlignment = Enum.TextXAlignment.Left
SearchPlayer.Parent = SearchContainer

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0.75, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.22, 0)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = COLORS.Stroke
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 6)

local function createTeamLine(name, isCategory)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -6, 0, 45)
	Frame.BackgroundColor3 = isCategory and COLORS.Header or COLORS.Item
	Frame.Parent = Scroll
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.6, 0, 1, 0)
	Label.Position = UDim2.new(0.05, 0, 0, 0)
	Label.Text = isCategory and "📂 " .. name:upper() or name
	Label.TextColor3 = isCategory and Color3.fromRGB(150, 200, 255) or COLORS.Text
	Label.Font = isCategory and Enum.Font.Michroma or Enum.Font.GothamBold
	Label.TextSize = isCategory and 10 or 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.BackgroundTransparency = 1
	Label.Parent = Frame

	local Add = Instance.new("TextButton")
	Add.Size = UDim2.new(0, 35, 0, 35)
	Add.Position = UDim2.new(1, -85, 0.5, -17.5)
	Add.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	Add.Text = "+"
	Add.TextColor3 = COLORS.Green
	Add.Font = Enum.Font.GothamBold
	Add.TextSize = 20
	Add.Parent = Frame
	Instance.new("UICorner", Add).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", Add).Color = COLORS.Green

	local Remove = Instance.new("TextButton")
	Remove.Size = UDim2.new(0, 35, 0, 35)
	Remove.Position = UDim2.new(1, -40, 0.5, -17.5)
	Remove.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	Remove.Text = "-"
	Remove.TextColor3 = COLORS.Red
	Remove.Font = Enum.Font.GothamBold
	Remove.TextSize = 20
	Remove.Parent = Frame
	Instance.new("UICorner", Remove).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", Remove).Color = COLORS.Red

	Add.MouseButton1Click:Connect(function()
		if SearchPlayer.Text ~= "" then
			WL_Remote:InvokeServer("ADD", SearchPlayer.Text, name)
			Add.Text = "✔" task.wait(0.5) Add.Text = "+"
		end
	end)

	Remove.MouseButton1Click:Connect(function()
		if SearchPlayer.Text ~= "" then
			WL_Remote:InvokeServer("REMOVE", SearchPlayer.Text, name)
			Remove.Text = "✔" task.wait(0.5) Remove.Text = "-"
		end
	end)
end

local function refreshPanel()
	for _, child in pairs(Scroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	for _, cat in ipairs(Config.Order) do
		local hasAccess = isAdmin or WL_Remote:InvokeServer("CHECK_GIVER", player.UserId, cat)
		if hasAccess then createTeamLine(cat, true) end
	end
	for _, team in pairs(Config.Teams) do
		if team.WL then
			local hasAccess = isAdmin or WL_Remote:InvokeServer("CHECK_GIVER", player.UserId, team.Name)
			if hasAccess then createTeamLine(team.Name, false) end
		end
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F2 then
		MainFrame.Visible = not MainFrame.Visible
		if MainFrame.Visible then refreshPanel() end
	end
end)

-- Simple Drag
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true dragStart = input.Position startPos = MainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
