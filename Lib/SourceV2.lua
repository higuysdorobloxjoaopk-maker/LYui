--[[ update 1.8
]]
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local LYui = {}
LYui.Elements = {}
LYui.Notifications = {}

local AccentColor = Color3.fromRGB(120, 190, 255)
local TopBarColor = Color3.fromRGB(35, 58, 95)
local MainBGColor = Color3.fromRGB(15, 17, 20)
local SecondaryBGColor = Color3.fromRGB(20, 25, 30)
local TextColor = Color3.fromRGB(200, 200, 200)

function LYui:SetAccentColor(newColor)
	AccentColor = newColor
	for _, el in pairs(LYui.Elements) do
		if el.AccentUpdate then el.AccentUpdate(newColor) end
	end
end

function LYui:Update(id, value)
	if LYui.Elements[id] and LYui.Elements[id].Update then
		LYui.Elements[id].Update(value)
	end
end

function LYui:CreateWindow(config)
	local window = {}
	local titleText = config.Title or "LYui"
	local scriptName = config.ScriptName or "LYuiScript"
	LYui.SaveFolder = "SAVES." .. scriptName .. ".SAVES"

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "LYui_Interface"
	ScreenGui.Parent = PlayerGui
	ScreenGui.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 220, 0, 140)
	MainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
	MainFrame.BackgroundColor3 = MainBGColor
	MainFrame.BorderSizePixel = 1
	MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
	MainFrame.Active = true
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 25)
	TopBar.BackgroundColor3 = TopBarColor
	TopBar.BorderSizePixel = 0
	TopBar.Active = true
	TopBar.Parent = MainFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -50, 1, 0)
	Title.Position = UDim2.new(0, 28, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = titleText
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 14
	Title.Font = Enum.Font.SourceSans
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	local CollapseBtn = Instance.new("TextButton")
	CollapseBtn.Size = UDim2.new(0, 25, 0, 25)
	CollapseBtn.BackgroundTransparency = 1
	CollapseBtn.Text = "▼"
	CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CollapseBtn.TextSize = 10
	CollapseBtn.Parent = TopBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 25, 0, 25)
	CloseBtn.Position = UDim2.new(1, -25, 0, 0)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 14
	CloseBtn.Parent = TopBar

	local ContentFrame = Instance.new("ScrollingFrame")
	ContentFrame.Size = UDim2.new(1, 0, 1, -25)
	ContentFrame.Position = UDim2.new(0, 0, 0, 25)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.BorderSizePixel = 0
	ContentFrame.ScrollBarThickness = 2
	ContentFrame.ScrollBarImageColor3 = AccentColor
	ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ContentFrame.Parent = MainFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = ContentFrame

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingLeft = UDim.new(0, 10)
	UIPadding.PaddingTop = UDim.new(0, 10)
	UIPadding.PaddingBottom = UDim.new(0, 150)
	UIPadding.Parent = ContentFrame

	local ResizeHandle = Instance.new("Frame")
	ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
	ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Active = true
	ResizeHandle.Parent = MainFrame

	local Triangle = Instance.new("TextLabel")
	Triangle.Size = UDim2.new(1, 0, 1, 0)
	Triangle.Position = UDim2.new(0, 0, 0, 4)
	Triangle.BackgroundTransparency = 1
	Triangle.Text = "◢"
	Triangle.TextColor3 = AccentColor
	Triangle.TextSize = 16
	Triangle.Font = Enum.Font.Arial
	Triangle.TextXAlignment = Enum.TextXAlignment.Right
	Triangle.TextYAlignment = Enum.TextYAlignment.Bottom
	Triangle.Parent = ResizeHandle

	local dragging = false
	local dragStart, startPos

	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local resizing = false
	local resizeStart, startSize

	ResizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = MainFrame.Size
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStart
			local newWidth = math.max(180, startSize.X.Offset + delta.X)
			local newHeight = math.max(100, startSize.Y.Offset + delta.Y)
			MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			resizing = false
		end
	end)

	local isCollapsed = false
	local originalY = MainFrame.Size.Y.Offset

	CollapseBtn.MouseButton1Click:Connect(function()
		isCollapsed = not isCollapsed
		if isCollapsed then
			originalY = MainFrame.Size.Y.Offset
			MainFrame:TweenSize(UDim2.new(0, MainFrame.Size.X.Offset, 0, 25), "Out", "Quad", 0.2, true)
			ContentFrame.Visible = false
			ResizeHandle.Visible = false
			CollapseBtn.Text = "►"
		else
			MainFrame:TweenSize(UDim2.new(0, MainFrame.Size.X.Offset, 0, originalY), "Out", "Quad", 0.2, true)
			ContentFrame.Visible = true
			ResizeHandle.Visible = true
			CollapseBtn.Text = "▼"
		end
	end)

	local function showCloseConfirmation()
		local Overlay = Instance.new("Frame")
		Overlay.Size = UDim2.new(1, 0, 1, 0)
		Overlay.Position = UDim2.new(0, 0, 0, 0)
		Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Overlay.BackgroundTransparency = 0.5
		Overlay.Parent = MainFrame

		local ConfirmFrame = Instance.new("Frame")
		ConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
		ConfirmFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
		ConfirmFrame.BackgroundColor3 = SecondaryBGColor
		ConfirmFrame.BorderSizePixel = 0
		ConfirmFrame.Parent = Overlay

		local UICornerConfirm = Instance.new("UICorner")
		UICornerConfirm.CornerRadius = UDim.new(0, 8)
		UICornerConfirm.Parent = ConfirmFrame

		local ConfirmTitle = Instance.new("TextLabel")
		ConfirmTitle.Size = UDim2.new(1, 0, 0, 30)
		ConfirmTitle.BackgroundTransparency = 1
		ConfirmTitle.Text = "Fechar Janela?"
		ConfirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		ConfirmTitle.TextSize = 16
		ConfirmTitle.Font = Enum.Font.SourceSansBold
		ConfirmTitle.Parent = ConfirmFrame

		local CancelBtn = Instance.new("TextButton")
		CancelBtn.Size = UDim2.new(0.5, -10, 0, 30)
		CancelBtn.Position = UDim2.new(0, 10, 1, -40)
		CancelBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
		CancelBtn.Text = "Cancelar"
		CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CancelBtn.Parent = ConfirmFrame

		local UICornerCancel = Instance.new("UICorner")
		UICornerCancel.CornerRadius = UDim.new(0, 4)
		UICornerCancel.Parent = CancelBtn

		CancelBtn.MouseButton1Click:Connect(function()
			Overlay:Destroy()
		end)

		local CloseConfirmBtn = Instance.new("TextButton")
		CloseConfirmBtn.Size = UDim2.new(0.5, -10, 0, 30)
		CloseConfirmBtn.Position = UDim2.new(0.5, 10, 1, -40)
		CloseConfirmBtn.BackgroundColor3 = AccentColor
		CloseConfirmBtn.Text = "Fechar"
		CloseConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CloseConfirmBtn.Parent = ConfirmFrame

		local UICornerClose = Instance.new("UICorner")
		UICornerClose.CornerRadius = UDim.new(0, 4)
		UICornerClose.Parent = CloseConfirmBtn

		CloseConfirmBtn.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
	end

	CloseBtn.MouseButton1Click:Connect(showCloseConfirmation)

	window.ScreenGui = ScreenGui
	window.MainFrame = MainFrame
	window.ContentFrame = ContentFrame
	window.Destroy = function() ScreenGui:Destroy() end

	function window:CreateBanner(bConfig)
		local BannerFrame = Instance.new("Frame")
		BannerFrame.Size = UDim2.new(1, -10, 0, 100)
		BannerFrame.BackgroundColor3 = SecondaryBGColor
		BannerFrame.BorderSizePixel = 0
		BannerFrame.Parent = ContentFrame

		local BannerImage = Instance.new("ImageLabel")
		BannerImage.Size = UDim2.new(0, 40, 0, 40)
		BannerImage.Position = UDim2.new(0, 10, 0, 10)
		BannerImage.BackgroundTransparency = 1
		BannerImage.Image = bConfig.ImageId or ""
		BannerImage.Parent = BannerFrame

		local BannerTitle = Instance.new("TextLabel")
		BannerTitle.Size = UDim2.new(1, -60, 0, 20)
		BannerTitle.Position = UDim2.new(0, 60, 0, 10)
		BannerTitle.BackgroundTransparency = 1
		BannerTitle.Text = bConfig.Title or ""
		BannerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		BannerTitle.TextSize = 16
		BannerTitle.Font = Enum.Font.SourceSansBold
		BannerTitle.TextXAlignment = Enum.TextXAlignment.Left
		BannerTitle.Parent = BannerFrame

		local BannerDesc = Instance.new("TextLabel")
		BannerDesc.Size = UDim2.new(1, -60, 0, 20)
		BannerDesc.Position = UDim2.new(0, 60, 0, 30)
		BannerDesc.BackgroundTransparency = 1
		BannerDesc.Text = bConfig.Description or ""
		BannerDesc.TextColor3 = TextColor
		BannerDesc.TextSize = 12
		BannerDesc.Font = Enum.Font.SourceSans
		BannerDesc.TextXAlignment = Enum.TextXAlignment.Left
		BannerDesc.Parent = BannerFrame

		local DiscordBtn = Instance.new("TextButton")
		DiscordBtn.Size = UDim2.new(1, -20, 0, 25)
		DiscordBtn.Position = UDim2.new(0, 10, 0, 65)
		DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		DiscordBtn.BorderSizePixel = 0
		DiscordBtn.Text = "Discord"
		DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		DiscordBtn.Font = Enum.Font.SourceSansBold
		DiscordBtn.TextSize = 14
		DiscordBtn.Parent = BannerFrame

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = DiscordBtn

		if bConfig.Callback then
			DiscordBtn.MouseButton1Click:Connect(bConfig.Callback)
		end

		if bConfig.Id then
			LYui.Elements[bConfig.Id] = {
				Type = "Banner",
				Update = function(newConfig)
					if newConfig.Title then BannerTitle.Text = newConfig.Title end
					if newConfig.Description then BannerDesc.Text = newConfig.Description end
					if newConfig.ImageId then BannerImage.Image = newConfig.ImageId end
				end
			}
		end
	end

	function window:CreateArea(areaName)
		local area = {}
		local AreaFrame = Instance.new("Frame")
		AreaFrame.Name = "AreaFrame"
		AreaFrame.BackgroundColor3 = SecondaryBGColor
		AreaFrame.BorderSizePixel = 0
		AreaFrame.Parent = ContentFrame
		AreaFrame.Size = UDim2.new(1, -10, 0, 20)

		local Header = Instance.new("Frame")
		Header.Size = UDim2.new(1, 0, 0, 20)
		Header.BackgroundColor3 = TopBarColor
		Header.Parent = AreaFrame

		local AreaTitle = Instance.new("TextLabel")
		AreaTitle.Size = UDim2.new(1, -25, 1, 0)
		AreaTitle.Position = UDim2.new(0, 5, 0, 0)
		AreaTitle.BackgroundTransparency = 1
		AreaTitle.Text = areaName
		AreaTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		AreaTitle.TextSize = 14
		AreaTitle.Font = Enum.Font.SourceSans
		AreaTitle.TextXAlignment = Enum.TextXAlignment.Left
		AreaTitle.Parent = Header

		local MinBtn = Instance.new("TextButton")
		MinBtn.Size = UDim2.new(0, 20, 1, 0)
		MinBtn.Position = UDim2.new(1, -20, 0, 0)
		MinBtn.BackgroundTransparency = 1
		MinBtn.Text = "▼"
		MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MinBtn.TextSize = 10
		MinBtn.Parent = Header

		local AreaContent = Instance.new("Frame")
		AreaContent.Size = UDim2.new(1, 0, 1, -20)
		AreaContent.Position = UDim2.new(0, 0, 0, 20)
		AreaContent.BackgroundTransparency = 1
		AreaContent.Parent = AreaFrame

		local AreaList = Instance.new("UIListLayout")
		AreaList.Padding = UDim.new(0, 5)
		AreaList.SortOrder = Enum.SortOrder.LayoutOrder
		AreaList.Parent = AreaContent

		local AreaPadding = Instance.new("UIPadding")
		AreaPadding.PaddingLeft = UDim.new(0, 5)
		AreaPadding.PaddingTop = UDim.new(0, 5)
		AreaPadding.Parent = AreaContent

		local isMin = false
		local origH = 0

		local function UpdateAreaSize()
			if not isMin then
				local contentH = AreaList.AbsoluteContentSize.Y + AreaPadding.PaddingTop.Offset + AreaPadding.PaddingBottom.Offset
				AreaContent.Size = UDim2.new(1, 0, 0, contentH)
				AreaFrame.Size = UDim2.new(1, -10, 0, 20 + contentH)
			end
		end

		AreaList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateAreaSize)

		MinBtn.MouseButton1Click:Connect(function()
			isMin = not isMin
			if isMin then
				origH = AreaFrame.Size.Y.Offset
				AreaFrame:TweenSize(UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, 20), "Out", "Quad", 0.2, true)
				AreaContent.Visible = false
				MinBtn.Text = "►"
			else
				AreaFrame:TweenSize(UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, origH), "Out", "Quad", 0.2, true)
				AreaContent.Visible = true
				MinBtn.Text = "▼"
				UpdateAreaSize()
			end
		end)

		area.AreaFrame = AreaFrame
		function area:Destroy() AreaFrame:Destroy() end
		function area:Minimize()
			isMin = true
			AreaFrame:TweenSize(UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, 20), "Out", "Quad", 0.2, true)
			AreaContent.Visible = false
			MinBtn.Text = "►"
		end
		function area:Restore()
			isMin = false
			AreaFrame:TweenSize(UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, origH), "Out", "Quad", 0.2, true)
			AreaContent.Visible = true
			MinBtn.Text = "▼"
			UpdateAreaSize()
		end

		function area:CreateColorPicker(cConfig)
			local CPContainer = Instance.new("Frame")
			CPContainer.Size = UDim2.new(1, -10, 0, 25)
			CPContainer.BackgroundTransparency = 1
			CPContainer.Parent = AreaContent

			local CPLabel = Instance.new("TextLabel")
			CPLabel.Size = UDim2.new(1, -30, 1, 0)
			CPLabel.BackgroundTransparency = 1
			CPLabel.Text = cConfig.Name or "Color Picker"
			CPLabel.TextColor3 = TextColor
			CPLabel.TextSize = 14
			CPLabel.Font = Enum.Font.Code
			CPLabel.TextXAlignment = Enum.TextXAlignment.Left
			CPLabel.Parent = CPContainer

			local ColorBtn = Instance.new("TextButton")
			ColorBtn.Size = UDim2.new(0, 22, 0, 22)
			ColorBtn.Position = UDim2.new(1, -25, 0, 1)
			ColorBtn.BackgroundColor3 = cConfig.Default or Color3.fromRGB(255, 100, 100)
			ColorBtn.BorderSizePixel = 2
			ColorBtn.BorderColor3 = AccentColor
			ColorBtn.Text = ""
			ColorBtn.Parent = CPContainer

			local currentColor = ColorBtn.BackgroundColor3

			local function updateColor(newColor)
				currentColor = newColor
				ColorBtn.BackgroundColor3 = newColor
				if cConfig.Callback then cConfig.Callback(newColor) end
			end

			local popupOpen = false
			local popup

			ColorBtn.MouseButton1Click:Connect(function()
				if popupOpen then
					if popup then popup:Destroy() end
					popupOpen = false
					return
				end
				popupOpen = true

				popup = Instance.new("Frame")
				popup.Size = UDim2.new(0, 340, 0, 420)
				popup.Position = UDim2.new(1, 10, 0, -80)
				popup.BackgroundColor3 = SecondaryBGColor
				popup.BorderSizePixel = 2
				popup.BorderColor3 = AccentColor
				popup.ZIndex = 999
				popup.Parent = MainFrame

				local pc = Instance.new("UICorner")
				pc.CornerRadius = UDim.new(0, 8)
				pc.Parent = popup

				local Preview = Instance.new("Frame")
				Preview.Size = UDim2.new(0, 120, 0, 120)
				Preview.Position = UDim2.new(0, 20, 0, 20)
				Preview.BackgroundColor3 = currentColor
				Preview.BorderSizePixel = 0
				Preview.Parent = popup
				local pcc = Instance.new("UICorner"); pcc.CornerRadius = UDim.new(0, 6); pcc.Parent = Preview

				local Wheel = Instance.new("ImageLabel")
				Wheel.Size = UDim2.new(0, 150, 0, 150)
				Wheel.Position = UDim2.new(0, 170, 0, 20)
				Wheel.BackgroundTransparency = 1
				Wheel.Image = "rbxassetid://6012001633" -- Valid color wheel ID
				Wheel.Parent = popup

				local WheelIndicator = Instance.new("Frame")
				WheelIndicator.Size = UDim2.new(0, 12, 0, 12)
				WheelIndicator.BackgroundTransparency = 1
				WheelIndicator.BorderSizePixel = 2
				WheelIndicator.BorderColor3 = Color3.new(1,1,1)
				WheelIndicator.Parent = Wheel
				local wic = Instance.new("UICorner"); wic.CornerRadius = UDim.new(1,0); wic.Parent = WheelIndicator

				local Palette = Instance.new("Frame")
				Palette.Size = UDim2.new(1, -40, 0, 60)
				Palette.Position = UDim2.new(0, 20, 0, 160)
				Palette.BackgroundTransparency = 1
				Palette.Parent = popup

				local grid = Instance.new("UIGridLayout")
				grid.CellSize = UDim2.new(0, 28, 0, 28)
				grid.CellPadding = UDim2.new(0, 8, 0, 8)
				grid.Parent = Palette

				local colors = {
					Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
					Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
					Color3.fromRGB(255,140,0), Color3.fromRGB(128,0,128), Color3.fromRGB(0,128,0),
					Color3.fromRGB(255,105,180), Color3.fromRGB(100,100,100), Color3.fromRGB(255,255,255),
					Color3.fromRGB(0,0,0), Color3.fromRGB(75,0,130), Color3.fromRGB(0,191,255)
				}
				for _, col in ipairs(colors) do
					local sw = Instance.new("TextButton")
					sw.Size = UDim2.new(0,28,0,28)
					sw.BackgroundColor3 = col
					sw.Text = ""
					sw.Parent = Palette
					local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,4); sc.Parent = sw
					sw.MouseButton1Click:Connect(function()
						updateColor(col)
						Preview.BackgroundColor3 = col
					end)
				end

				local function makeRGBBox(name, val, y)
					local f = Instance.new("Frame")
					f.Size = UDim2.new(0, 280, 0, 26)
					f.Position = UDim2.new(0, 20, 0, y)
					f.BackgroundTransparency = 1
					f.Parent = popup

					local l = Instance.new("TextLabel")
					l.Size = UDim2.new(0,40,1,0)
					l.Text = name..":"
					l.TextColor3 = TextColor
					l.BackgroundTransparency = 1
					l.Parent = f

					local box = Instance.new("TextBox")
					box.Size = UDim2.new(0, 80, 1, 0)
					box.Position = UDim2.new(0, 50, 0, 0)
					box.Text = tostring(math.floor(val*255))
					box.BackgroundColor3 = Color3.fromRGB(25,30,40)
					box.TextColor3 = Color3.fromRGB(255,255,255)
					box.Parent = f
					local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,4); bc.Parent = box

					box.FocusLost:Connect(function()
						local n = tonumber(box.Text)
						if n then
							n = math.clamp(n, 0, 255)/255
							local r,g,b = currentColor.R, currentColor.G, currentColor.B
							if name == "R" then r = n elseif name == "G" then g = n else b = n end
							local nc = Color3.new(r,g,b)
							updateColor(nc)
							Preview.BackgroundColor3 = nc
						end
					end)
					return box
				end

				local rBox = makeRGBBox("R", currentColor.R, 240)
				local gBox = makeRGBBox("G", currentColor.G, 270)
				local bBox = makeRGBBox("B", currentColor.B, 300)

				local hexBox = Instance.new("TextBox")
				hexBox.Size = UDim2.new(0, 120, 0, 26)
				hexBox.Position = UDim2.new(0, 20, 0, 340)
				hexBox.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255)
				hexBox.BackgroundColor3 = Color3.fromRGB(25,30,40)
				hexBox.TextColor3 = Color3.fromRGB(255,255,255)
				hexBox.Parent = popup
				local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,4); hc.Parent = hexBox

				hexBox.FocusLost:Connect(function()
					local txt = hexBox.Text:gsub("#",""):upper()
					if #txt == 6 then
						local r = tonumber(txt:sub(1,2),16)/255
						local g = tonumber(txt:sub(3,4),16)/255
						local b = tonumber(txt:sub(5,6),16)/255
						if r and g and b then
							local nc = Color3.new(r,g,b)
							updateColor(nc)
							Preview.BackgroundColor3 = nc
						end
					end
				end)

				local closeB = Instance.new("TextButton")
				closeB.Size = UDim2.new(0, 100, 0, 35)
				closeB.Position = UDim2.new(0.5, -50, 1, -45)
				closeB.BackgroundColor3 = TopBarColor
				closeB.Text = "FECHAR"
				closeB.TextColor3 = Color3.new(1,1,1)
				closeB.Font = Enum.Font.SourceSansBold
				closeB.Parent = popup
				local clc = Instance.new("UICorner"); clc.CornerRadius = UDim.new(0,6); clc.Parent = closeB
				closeB.MouseButton1Click:Connect(function()
					popup:Destroy()
					popupOpen = false
				end)

				local closeConn
				closeConn = UserInputService.InputBegan:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						local mp = inp.Position
						if popup and (mp.X < popup.AbsolutePosition.X or mp.X > popup.AbsolutePosition.X + popup.AbsoluteSize.X or mp.Y < popup.AbsolutePosition.Y or mp.Y > popup.AbsolutePosition.Y + popup.AbsoluteSize.Y) then
							popup:Destroy()
							popupOpen = false
							closeConn:Disconnect()
						end
					end
				end)
			end)

			if cConfig.Id then
				LYui.Elements[cConfig.Id] = {
					Type = "ColorPicker",
					Update = function(newColor)
						if typeof(newColor) == "Color3" then updateColor(newColor) end
					end,
					AccentUpdate = function(newAccent) ColorBtn.BorderColor3 = newAccent end,
					CurrentColor = function() return currentColor end
				}
			end
		end

		function area:CreateTextBox(tConfig)
			local TBContainer = Instance.new("Frame")
			TBContainer.Size = UDim2.new(1, -10, 0, 35)
			TBContainer.BackgroundTransparency = 1
			TBContainer.Parent = AreaContent

			local TBLabel = Instance.new("TextLabel")
			TBLabel.Size = UDim2.new(1, 0, 0, 15)
			TBLabel.BackgroundTransparency = 1
			TBLabel.Text = tConfig.Name or "Input"
			TBLabel.TextColor3 = TextColor
			TBLabel.TextSize = 14
			TBLabel.Font = Enum.Font.Code
			TBLabel.TextXAlignment = Enum.TextXAlignment.Left
			TBLabel.Parent = TBContainer

			local TB = Instance.new("TextBox")
			TB.Size = UDim2.new(1, 0, 0, 18)
			TB.Position = UDim2.new(0, 0, 0, 17)
			TB.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
			TB.BorderSizePixel = 1
			TB.BorderColor3 = AccentColor
			TB.Text = tConfig.Default or ""
			TB.TextColor3 = Color3.fromRGB(255,255,255)
			TB.TextSize = 14
			TB.Font = Enum.Font.Code
			TB.TextXAlignment = Enum.TextXAlignment.Left
			TB.Parent = TBContainer

			local tbc = Instance.new("UICorner")
			tbc.CornerRadius = UDim.new(0, 4)
			tbc.Parent = TB

			local function fire()
				if tConfig.Callback then tConfig.Callback(TB.Text) end
			end
			TB.FocusLost:Connect(fire)

			if tConfig.Id then
				LYui.Elements[tConfig.Id] = {
					Type = "TextBox",
					Update = function(newText)
						TB.Text = tostring(newText)
						fire()
					end,
					AccentUpdate = function(newAccent) TB.BorderColor3 = newAccent end,
					CurrentText = function() return TB.Text end
				}
			end
		end

		function area:CreateLabel(lConfig)
			local InfoLabel = Instance.new("TextLabel")
			InfoLabel.Size = UDim2.new(1, -10, 0, 15)
			InfoLabel.BackgroundTransparency = 1
			InfoLabel.Text = lConfig.Text or ""
			InfoLabel.TextColor3 = TextColor
			InfoLabel.TextSize = 14
			InfoLabel.Font = Enum.Font.Code
			InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
			InfoLabel.Parent = AreaContent

			if lConfig.Id then
				LYui.Elements[lConfig.Id] = {
					Type = "Label",
					Update = function(newText) InfoLabel.Text = newText end
				}
			end
		end

		function area:CreateToggle(tConfig)
			local ToggleContainer = Instance.new("Frame")
			ToggleContainer.Size = UDim2.new(1, -10, 0, 20)
			ToggleContainer.BackgroundTransparency = 1
			ToggleContainer.Parent = AreaContent

			local ToggleBox = Instance.new("Frame")
			ToggleBox.Name = "ToggleBox"
			ToggleBox.Size = UDim2.new(0, 18, 0, 18)
			ToggleBox.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
			ToggleBox.BorderColor3 = Color3.fromRGB(40, 50, 70)
			ToggleBox.BorderSizePixel = 2
			ToggleBox.Parent = ToggleContainer

			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = UDim.new(1, 0)
			UICorner.Parent = ToggleBox

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Name = "ToggleButton"
			ToggleButton.Size = UDim2.new(1, 0, 1, 0)
			ToggleButton.BackgroundTransparency = 1
			ToggleButton.Text = ""
			ToggleButton.Parent = ToggleBox

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Name = "ToggleLabel"
			ToggleLabel.Size = UDim2.new(1, -25, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 25, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = tConfig.Name or "Toggle"
			ToggleLabel.TextColor3 = TextColor
			ToggleLabel.TextSize = 14
			ToggleLabel.Font = Enum.Font.Code
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = ToggleContainer

			local toggled = false

			local function setToggle(state)
				toggled = state
				if toggled then
					ToggleBox.BackgroundColor3 = AccentColor
					ToggleBox.BorderColor3 = TopBarColor
				else
					ToggleBox.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
					ToggleBox.BorderColor3 = Color3.fromRGB(40, 50, 70)
				end
				if tConfig.Callback then tConfig.Callback(toggled) end
			end

			ToggleButton.MouseButton1Click:Connect(function()
				setToggle(not toggled)
			end)

			if tConfig.Id then
				LYui.Elements[tConfig.Id] = {
					Type = "Toggle",
					Update = function(newState) setToggle(newState) end,
					CurrentState = function() return toggled end
				}
			end
		end

		function area:CreateButton(bConfig)
			local BtnFrame = Instance.new("Frame")
			BtnFrame.Size = UDim2.new(1, -10, 0, 25)
			BtnFrame.BackgroundTransparency = 1
			BtnFrame.Parent = AreaContent

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1, 0, 1, 0)
			Button.BackgroundColor3 = TopBarColor
			Button.BorderSizePixel = 0
			Button.Text = bConfig.Name or "Button"
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14
			Button.Font = Enum.Font.SourceSans
			Button.Parent = BtnFrame

			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Button

			Button.MouseButton1Click:Connect(function()
				if bConfig.Callback then bConfig.Callback() end
			end)

			if bConfig.Id then
				LYui.Elements[bConfig.Id] = {
					Type = "Button",
					Update = function(newName) Button.Text = newName end
				}
			end
		end

		function area:CreateSlider(sConfig)
			local SliderContainer = Instance.new("Frame")
			SliderContainer.Size = UDim2.new(1, -10, 0, 35)
			SliderContainer.BackgroundTransparency = 1
			SliderContainer.Parent = AreaContent

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(1, 0, 0, 15)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = sConfig.Name or "Slider"
			SliderLabel.TextColor3 = TextColor
			SliderLabel.TextSize = 14
			SliderLabel.Font = Enum.Font.Code
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = SliderContainer

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(1, 0, 0, 15)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(sConfig.Default or sConfig.Min or 0)
			ValueLabel.TextColor3 = TextColor
			ValueLabel.TextSize = 14
			ValueLabel.Font = Enum.Font.Code
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderContainer

			local SliderBG = Instance.new("Frame")
			SliderBG.Size = UDim2.new(1, 0, 0, 6)
			SliderBG.Position = UDim2.new(0, 0, 0, 20)
			SliderBG.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
			SliderBG.BorderSizePixel = 0
			SliderBG.Parent = SliderContainer

			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new(0, 0, 1, 0)
			SliderFill.BackgroundColor3 = AccentColor
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBG

			local SliderBtn = Instance.new("TextButton")
			SliderBtn.Size = UDim2.new(1, 0, 1, 0)
			SliderBtn.BackgroundTransparency = 1
			SliderBtn.Text = ""
			SliderBtn.Parent = SliderBG

			local min = sConfig.Min or 0
			local max = sConfig.Max or 100
			local def = sConfig.Default or min
			local currentVal = def

			local function setSlider(val)
				val = math.clamp(val, min, max)
				currentVal = val
				local pct = (val - min) / (max - min)
				SliderFill.Size = UDim2.new(pct, 0, 1, 0)
				ValueLabel.Text = tostring(math.floor(val))
				if sConfig.Callback then sConfig.Callback(math.floor(val)) end
			end

			setSlider(def)

			local draggingSlider = false

			SliderBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
					local pct = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
					setSlider(min + (max - min) * pct)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local pct = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
					setSlider(min + (max - min) * pct)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)

			if sConfig.Id then
				LYui.Elements[sConfig.Id] = {
					Type = "Slider",
					Update = function(newVal) setSlider(newVal) end,
					CurrentValue = function() return currentVal end
				}
			end
		end

		function area:CreateDropdown(dConfig)
			local DropContainer = Instance.new("Frame")
			DropContainer.Size = UDim2.new(1, -10, 0, 25)
			DropContainer.BackgroundTransparency = 1
			DropContainer.Parent = AreaContent

			local MainBtn = Instance.new("TextButton")
			MainBtn.Size = UDim2.new(1, 0, 0, 25)
			MainBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
			MainBtn.BorderSizePixel = 0
			MainBtn.Text = dConfig.Name or "Dropdown"
			MainBtn.TextColor3 = TextColor
			MainBtn.TextSize = 14
			MainBtn.Font = Enum.Font.Code
			MainBtn.Parent = DropContainer

			local ListFrame = Instance.new("ScrollingFrame")
			ListFrame.Size = UDim2.new(1, 0, 0, 0)
			ListFrame.Position = UDim2.new(0, 0, 0, 25)
			ListFrame.BackgroundColor3 = SecondaryBGColor
			ListFrame.BorderSizePixel = 1
			ListFrame.BorderColor3 = Color3.fromRGB(40, 50, 70)
			ListFrame.ScrollBarThickness = 2
			ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ListFrame.Visible = false
			ListFrame.Parent = DropContainer

			local dLayout = Instance.new("UIListLayout")
			dLayout.Parent = ListFrame

			local open = false
			local options = dConfig.Options or {}
			local multi = dConfig.Multi or false
			local selected = {}

			local function toggleDrop()
				open = not open
				if open then
					ListFrame.Visible = true
					DropContainer.Size = UDim2.new(1, -10, 0, 25 + math.min(100, #options * 20))
					ListFrame.Size = UDim2.new(1, 0, 0, math.min(100, #options * 20))
				else
					ListFrame.Visible = false
					DropContainer.Size = UDim2.new(1, -10, 0, 25)
				end
				UpdateAreaSize()
			end

			MainBtn.MouseButton1Click:Connect(toggleDrop)

			local function populate(opts)
				for _, child in ipairs(ListFrame:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				options = opts
				for _, opt in ipairs(options) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1, 0, 0, 20)
					optBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
					optBtn.BorderSizePixel = 0
					optBtn.Text = opt
					optBtn.TextColor3 = TextColor
					optBtn.TextSize = 14
					optBtn.Font = Enum.Font.Code
					optBtn.Parent = ListFrame

					optBtn.MouseButton1Click:Connect(function()
						if multi then
							if selected[opt] then
								selected[opt] = nil
								optBtn.TextColor3 = TextColor
							else
								selected[opt] = true
								optBtn.TextColor3 = AccentColor
							end
							if dConfig.Callback then dConfig.Callback(selected) end
						else
							MainBtn.Text = opt
							toggleDrop()
							if dConfig.Callback then dConfig.Callback(opt) end
						end
					end)
				end
				if open then
					DropContainer.Size = UDim2.new(1, -10, 0, 25 + math.min(100, #options * 20))
					ListFrame.Size = UDim2.new(1, 0, 0, math.min(100, #options * 20))
					UpdateAreaSize()
				end
			end

			if dConfig.Type == "Players" then
				local function getPlrs()
					local t = {}
					for _, p in ipairs(Players:GetPlayers()) do table.insert(t, p.Name) end
					return t
				end
				populate(getPlrs())
				Players.PlayerAdded:Connect(function() populate(getPlrs()) end)
				Players.PlayerRemoving:Connect(function() populate(getPlrs()) end)
			else
				populate(options)
			end

			if dConfig.Id then
				LYui.Elements[dConfig.Id] = {
					Type = "Dropdown",
					Update = function(newOpts)
						if type(newOpts) == "table" then populate(newOpts) end
					end
				}
			end
		end

		function area:CreateProgressBar(pConfig)
			local PBContainer = Instance.new("Frame")
			PBContainer.Size = UDim2.new(1, -10, 0, 35)
			PBContainer.BackgroundTransparency = 1
			PBContainer.Parent = AreaContent

			local PBLabel = Instance.new("TextLabel")
			PBLabel.Size = UDim2.new(1, 0, 0, 15)
			PBLabel.BackgroundTransparency = 1
			PBLabel.Text = pConfig.Name or "Progresso"
			PBLabel.TextColor3 = TextColor
			PBLabel.TextSize = 14
			PBLabel.Font = Enum.Font.Code
			PBLabel.TextXAlignment = Enum.TextXAlignment.Left
			PBLabel.Parent = PBContainer

			local PBPercent = Instance.new("TextLabel")
			PBPercent.Size = UDim2.new(1, 0, 0, 15)
			PBPercent.BackgroundTransparency = 1
			PBPercent.Text = "0%"
			PBPercent.TextColor3 = TextColor
			PBPercent.TextSize = 14
			PBPercent.Font = Enum.Font.Code
			PBPercent.TextXAlignment = Enum.TextXAlignment.Right
			PBPercent.Parent = PBContainer

			local PBBG = Instance.new("Frame")
			PBBG.Size = UDim2.new(1, 0, 0, 6)
			PBBG.Position = UDim2.new(0, 0, 0, 20)
			PBBG.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
			PBBG.BorderSizePixel = 0
			PBBG.Parent = PBContainer

			local PBFill = Instance.new("Frame")
			PBFill.Size = UDim2.new(0, 0, 1, 0)
			PBFill.BackgroundColor3 = AccentColor
			PBFill.BorderSizePixel = 0
			PBFill.Parent = PBBG

			local function setProgress(pct)
				pct = math.clamp(pct, 0, 100)
				PBFill.Size = UDim2.new(pct / 100, 0, 1, 0)
				PBPercent.Text = tostring(pct) .. "%"
			end

			setProgress(pConfig.Default or 0)

			if pConfig.Id then
				LYui.Elements[pConfig.Id] = {
					Type = "ProgressBar",
					Update = function(newPct) setProgress(newPct) end
				}
			end
		end

		function area:CreateKeybind(kConfig)
			local KBContainer = Instance.new("Frame")
			KBContainer.Size = UDim2.new(1, -10, 0, 25)
			KBContainer.BackgroundTransparency = 1
			KBContainer.Parent = AreaContent

			local KBLabel = Instance.new("TextLabel")
			KBLabel.Size = UDim2.new(1, -60, 1, 0)
			KBLabel.BackgroundTransparency = 1
			KBLabel.Text = kConfig.Name or "Keybind"
			KBLabel.TextColor3 = TextColor
			KBLabel.TextSize = 14
			KBLabel.Font = Enum.Font.Code
			KBLabel.TextXAlignment = Enum.TextXAlignment.Left
			KBLabel.Parent = KBContainer

			local KBButton = Instance.new("TextButton")
			KBButton.Size = UDim2.new(0, 50, 1, 0)
			KBButton.Position = UDim2.new(1, -50, 0, 0)
			KBButton.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
			KBButton.Text = kConfig.Default or "None"
			KBButton.TextColor3 = TextColor
			KBButton.Parent = KBContainer

			local UICornerKB = Instance.new("UICorner")
			UICornerKB.CornerRadius = UDim.new(0, 4)
			UICornerKB.Parent = KBButton

			local binding = false
			KBButton.MouseButton1Click:Connect(function()
				binding = true
				KBButton.Text = "..."
			end)

			UserInputService.InputBegan:Connect(function(input)
				if binding then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						local key = input.KeyCode.Name
						KBButton.Text = key
						if kConfig.Callback then kConfig.Callback(key) end
						binding = false
					end
				end
			end)

			if kConfig.Id then
				LYui.Elements[kConfig.Id] = {
					Type = "Keybind",
					Update = function(newKey) KBButton.Text = newKey end
				}
			end
		end

		return area
	end

	local function ensureSaveFolder()
		if not isfolder("SAVES") then makefolder("SAVES") end
		if not isfolder(LYui.SaveFolder) then makefolder(LYui.SaveFolder) end
	end

	function window:Save(saveName)
		ensureSaveFolder()
		local data = {}
		for id, el in pairs(LYui.Elements) do
			if el.CurrentState then data[id] = el.CurrentState() end
			if el.CurrentValue then data[id] = el.CurrentValue() end
			if el.CurrentText then data[id] = el.CurrentText() end
			if el.CurrentColor then
				local c = el.CurrentColor()
				data[id] = {R = c.R, G = c.G, B = c.B}
			end
		end
		local filename = LYui.SaveFolder .. "/save_" .. saveName .. "_" .. os.date("%Y%m%d_%H%M%S") .. ".json"
		writefile(filename, HttpService:JSONEncode(data))
		print("💾 SALVO:", filename)
	end

	function window:Load(saveName)
		ensureSaveFolder()
		local filename = LYui.SaveFolder .. "/save_" .. saveName .. ".json"
		if isfile(filename) then
			local data = HttpService:JSONDecode(readfile(filename))
			for id, value in pairs(data) do
				LYui:Update(id, value)
			end
			print("📂 CARREGADO:", saveName)
		end
	end

	function window:AutoSaveAll()
		ensureSaveFolder()
		task.spawn(function()
			while true do
				task.wait(15)
				window:Save("autosave")
			end
		end)
		print("🔄 AutoSave ativado (a cada 15s)")
	end

	function LYui:Notify(nConfig)
		local NotifyFrame = Instance.new("Frame")
		NotifyFrame.Size = UDim2.new(0, 300, 0, 80)
		NotifyFrame.BackgroundColor3 = SecondaryBGColor
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Position = UDim2.new(1, -310, 0, 10 + (#LYui.Notifications * 90))
		NotifyFrame.Parent = ScreenGui

		local UICornerNotify = Instance.new("UICorner")
		UICornerNotify.CornerRadius = UDim.new(0, 8)
		UICornerNotify.Parent = NotifyFrame

		local NotifyTitle = Instance.new("TextLabel")
		NotifyTitle.Size = UDim2.new(1, 0, 0, 20)
		NotifyTitle.Position = UDim2.new(0, 0, 0, 5)
		NotifyTitle.BackgroundTransparency = 1
		NotifyTitle.Text = nConfig.Title or "Notificação"
		NotifyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyTitle.TextSize = 16
		NotifyTitle.Font = Enum.Font.SourceSansBold
		NotifyTitle.TextXAlignment = Enum.TextXAlignment.Center
		NotifyTitle.Parent = NotifyFrame

		local NotifyDesc = Instance.new("TextLabel")
		NotifyDesc.Size = UDim2.new(1, -10, 0, 30)
		NotifyDesc.Position = UDim2.new(0, 5, 0, 25)
		NotifyDesc.BackgroundTransparency = 1
		NotifyDesc.Text = nConfig.Description or ""
		NotifyDesc.TextColor3 = TextColor
		NotifyDesc.TextSize = 12
		NotifyDesc.Font = Enum.Font.SourceSans
		NotifyDesc.TextXAlignment = Enum.TextXAlignment.Center
		NotifyDesc.Parent = NotifyFrame

		if nConfig.Image then
			local NotifyImage = Instance.new("ImageLabel")
			NotifyImage.Size = UDim2.new(0, 40, 0, 40)
			NotifyImage.Position = UDim2.new(0, 5, 0, 5)
			NotifyImage.BackgroundTransparency = 1
			NotifyImage.Image = nConfig.Image
			NotifyImage.Parent = NotifyFrame
		end

		if nConfig.Button then
			local NotifyBtn = Instance.new("TextButton")
			NotifyBtn.Size = UDim2.new(1, -10, 0, 25)
			NotifyBtn.Position = UDim2.new(0, 5, 1, -30)
			NotifyBtn.BackgroundColor3 = AccentColor
			NotifyBtn.Text = nConfig.Button.Text or "OK"
			NotifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			NotifyBtn.Parent = NotifyFrame

			local UICornerBtn = Instance.new("UICorner")
			UICornerBtn.CornerRadius = UDim.new(0, 4)
			UICornerBtn.Parent = NotifyBtn

			NotifyBtn.MouseButton1Click:Connect(function()
				if nConfig.Button.Callback then nConfig.Button.Callback() end
				NotifyFrame:Destroy()
			end)
		end

		table.insert(LYui.Notifications, NotifyFrame)

		NotifyFrame.Position = UDim2.new(1, 0, NotifyFrame.Position.Y.Scale, NotifyFrame.Position.Y.Offset)
		TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, NotifyFrame.Position.Y.Scale, NotifyFrame.Position.Y.Offset)}):Play()

		if not nConfig.Button then
			task.wait(5)
			TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, NotifyFrame.Position.Y.Scale, NotifyFrame.Position.Y.Offset)}):Play()
			task.wait(0.3)
			NotifyFrame:Destroy()
		end

		for i, notif in ipairs(LYui.Notifications) do
			TweenService:Create(notif, TweenInfo.new(0.2), {Position = UDim2.new(1, -310, 0, 10 + ((i-1) * 90))}):Play()
		end
	end

	return window
end

return LYui
