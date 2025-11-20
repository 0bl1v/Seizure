local SeizureUI = {}
SeizureUI.__index = SeizureUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Theme definitions
SeizureUI.Themes = {
	Dark = {
		Background = Color3.fromRGB(7, 7, 7),
		ElementBackground = Color3.fromRGB(20, 20, 20),
		ElementHover = Color3.fromRGB(30, 30, 30),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(150, 150, 150),
		Accent = Color3.fromRGB(100, 200, 255),
		CheckboxOff = Color3.fromRGB(40, 40, 40),
		Divider = Color3.fromRGB(40, 40, 40),
	},
	Light = {
		Background = Color3.fromRGB(240, 240, 240),
		ElementBackground = Color3.fromRGB(220, 220, 220),
		ElementHover = Color3.fromRGB(200, 200, 200),
		TextPrimary = Color3.fromRGB(30, 30, 30),
		TextSecondary = Color3.fromRGB(100, 100, 100),
		Accent = Color3.fromRGB(0, 120, 215),
		CheckboxOff = Color3.fromRGB(180, 180, 180),
		Divider = Color3.fromRGB(180, 180, 180),
	},
	Ocean = {
		Background = Color3.fromRGB(15, 35, 60),
		ElementBackground = Color3.fromRGB(25, 55, 90),
		ElementHover = Color3.fromRGB(35, 75, 120),
		TextPrimary = Color3.fromRGB(230, 240, 255),
		TextSecondary = Color3.fromRGB(150, 180, 220),
		Accent = Color3.fromRGB(100, 220, 255),
		CheckboxOff = Color3.fromRGB(45, 70, 100),
		Divider = Color3.fromRGB(45, 70, 100),
	},
	Neon = {
		Background = Color3.fromRGB(10, 10, 20),
		ElementBackground = Color3.fromRGB(20, 20, 40),
		ElementHover = Color3.fromRGB(30, 30, 60),
		TextPrimary = Color3.fromRGB(0, 255, 150),
		TextSecondary = Color3.fromRGB(0, 180, 120),
		Accent = Color3.fromRGB(255, 0, 200),
		CheckboxOff = Color3.fromRGB(40, 40, 80),
		Divider = Color3.fromRGB(40, 40, 80),
	},
	Sunset = {
		Background = Color3.fromRGB(40, 25, 20),
		ElementBackground = Color3.fromRGB(70, 40, 30),
		ElementHover = Color3.fromRGB(90, 55, 40),
		TextPrimary = Color3.fromRGB(255, 220, 200),
		TextSecondary = Color3.fromRGB(200, 150, 130),
		Accent = Color3.fromRGB(255, 140, 80),
		CheckboxOff = Color3.fromRGB(60, 35, 25),
		Divider = Color3.fromRGB(60, 35, 25),
	},
}

local function getParent()
	local success, result = pcall(function()
		if gethui then
			return gethui()
		end
	end)
	if success and result then
		return result
	end

	success, result = pcall(function()
		return game:GetService("CoreGui")
	end)
	if success and result then
		return result
	end

	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

function SeizureUI:CreateWindow(config)
	local Window = {}
	Window.Config = config or {}
	Window.Title = Window.Config.Title or "SeizureUI"
	Window.Description = Window.Config.Description or "inspired by windui"
	Window.Icon = Window.Config.Icon or "rbxassetid://156513166"
	Window.Theme = Window.Config.Theme or SeizureUI.Themes.Dark

	local requestedSize = Window.Config.Size or UDim2.new(0, 652, 0, 392)
	local minW = 400
	local minH = 250
	local w = math.max(requestedSize.X.Offset, minW)
	local h = math.max(requestedSize.Y.Offset, minH)
	Window.Size = UDim2.new(0, w, 0, h)

	Window.Tabs = {}
	Window.CurrentTab = nil

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SeizureUI"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	pcall(function()
		ScreenGui.Parent = getParent()
	end)

	if not ScreenGui.Parent then
		ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Parent = ScreenGui
	bg.AnchorPoint = Vector2.new(0.5, 0.5)
	bg.BackgroundColor3 = Window.Theme.Background
	bg.BorderSizePixel = 0
	bg.Position = UDim2.new(0.5, 0, 0.5, 0)
	bg.Size = UDim2.new(0, 0, 0, 0)
	bg.ClipsDescendants = true
	bg.BackgroundTransparency = 1

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.02, 0)
	corner.Parent = bg

	local introTween = TweenService:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = Window.Size,
		BackgroundTransparency = 0
	})
	introTween:Play()

	local icon = Instance.new("ImageLabel")
	icon.Name = "icon"
	icon.Parent = bg
	icon.BackgroundTransparency = 1
	icon.Position = UDim2.new(0.02, 0, 0.028, 0)
	icon.Size = UDim2.new(0, 35, 0, 35)
	icon.Image = Window.Icon
	icon.ImageTransparency = 1

	local iconC = Instance.new("UICorner")
	iconC.CornerRadius = UDim.new(0.2, 0)
	iconC.Parent = icon

	local title = Instance.new("TextLabel")
	title.Name = "title"
	title.Parent = bg
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0.094, 0, 0.028, 0)
	title.Size = UDim2.new(0, 548, 0, 21)
	title.Font = Enum.Font.GothamMedium
	title.Text = Window.Title
	title.TextColor3 = Window.Theme.TextPrimary
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTransparency = 1

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "subtitle"
	subtitle.Parent = bg
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.new(0.094, 0, 0.064, 0)
	subtitle.Size = UDim2.new(0, 548, 0, 21)
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = Window.Description
	subtitle.TextColor3 = Window.Theme.TextSecondary
	subtitle.TextSize = 12
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextTransparency = 1

	task.wait(0.3)
	TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
	TweenService:Create(title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

	local wWidth = Window.Size.X.Offset
	local wHeight = Window.Size.Y.Offset
	local tabH = wHeight * 0.765
	local contentW = wWidth * 0.754
	local contentH = wHeight * 0.816

	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Parent = bg
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0.019, 0, 0.145, 0)
	TabContainer.Size = UDim2.new(0, 120, 0, tabH)

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabContainer
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 8)

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = bg
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0.22, 0, 0.143, 0)
	ContentContainer.Size = UDim2.new(0, contentW, 0, contentH)

	local dragging = false
	local dragStart
	local startPos
	local dragTween

	bg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = bg.Position

			if dragTween then
				dragTween:Cancel()
			end
		end
	end)

	bg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

			if dragTween then
				dragTween:Cancel()
			end
			dragTween = TweenService:Create(bg, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = newPos
			})
			dragTween:Play()
		end
	end)

	function Window:SetTheme(newTheme)
		Window.Theme = newTheme
		TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundColor3 = Window.Theme.Background}):Play()
		TweenService:Create(title, TweenInfo.new(0.3), {TextColor3 = Window.Theme.TextPrimary}):Play()
		TweenService:Create(subtitle, TweenInfo.new(0.3), {TextColor3 = Window.Theme.TextSecondary}):Play()
	end

	function Window:CreateTab(tabConfig)
		local Tab = {}
		Tab.Name = tabConfig.Name or "Tab"
		Tab.Elements = {}

		local TabButton = Instance.new("TextButton")
		TabButton.Name = "Tab_" .. Tab.Name
		TabButton.Parent = TabContainer
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 0, 21)
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = Tab.Name
		TabButton.TextColor3 = Window.Theme.TextSecondary
		TabButton.TextSize = 14
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.TextTransparency = 1

		task.wait(0.05)
		TweenService:Create(TabButton, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Name = "Content_" .. Tab.Name
		tabContent.Parent = ContentContainer
		tabContent.BackgroundTransparency = 1
		tabContent.BorderSizePixel = 0
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.ScrollBarThickness = 4
		tabContent.ScrollBarImageColor3 = Window.Theme.Accent
		tabContent.Visible = false

		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.Parent = tabContent
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 8)

		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Window.Tabs) do
				TweenService:Create(tab.Button, TweenInfo.new(0.2), {TextColor3 = Window.Theme.TextSecondary}):Play()
				tab.Content.Visible = false
			end

			TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Window.Theme.TextPrimary}):Play()
			tabContent.Visible = true

			Window.CurrentTab = Tab
		end)

		TabButton.MouseEnter:Connect(function()
			if TabButton.TextColor3 ~= Window.Theme.TextPrimary then
				TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Window.Theme.Accent}):Play()
			end
		end)

		TabButton.MouseLeave:Connect(function()
			if TabButton.TextColor3 ~= Window.Theme.TextPrimary then
				TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Window.Theme.TextSecondary}):Play()
			end
		end)

		Tab.Button = TabButton
		Tab.Content = tabContent

		if #Window.Tabs == 0 then
			TabButton.TextColor3 = Window.Theme.TextPrimary
			tabContent.Visible = true
			Window.CurrentTab = Tab
		end

		table.insert(Window.Tabs, Tab)

		function Tab:CreateButton(buttonConfig)
			local btnFrame = Instance.new("Frame")
			btnFrame.Name = "Button"
			btnFrame.Parent = tabContent
			btnFrame.BackgroundColor3 = Window.Theme.ElementBackground
			btnFrame.BorderSizePixel = 0
			btnFrame.Size = UDim2.new(1, 0, 0, 42)
			btnFrame.BackgroundTransparency = 1

			TweenService:Create(btnFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0.1, 0)
			btnCorner.Parent = btnFrame

			local btnLabel = Instance.new("TextLabel")
			btnLabel.Parent = btnFrame
			btnLabel.BackgroundTransparency = 1
			btnLabel.Position = UDim2.new(0.026, 0, 0, 0)
			btnLabel.Size = UDim2.new(0.95, 0, 1, 0)
			btnLabel.Font = Enum.Font.GothamMedium
			btnLabel.Text = buttonConfig.Name or "Button"
			btnLabel.TextColor3 = Window.Theme.TextPrimary
			btnLabel.TextSize = 14
			btnLabel.TextXAlignment = Enum.TextXAlignment.Left
			btnLabel.TextTransparency = 1

			task.wait(0.1)
			TweenService:Create(btnLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			local clickBtn = Instance.new("TextButton")
			clickBtn.Parent = btnFrame
			clickBtn.BackgroundTransparency = 1
			clickBtn.Size = UDim2.new(1, 0, 1, 0)
			clickBtn.Text = ""

			clickBtn.MouseButton1Click:Connect(function()
				local origSize = btnFrame.Size
				TweenService:Create(btnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, -4, 0, 38)
				}):Play()
				task.wait(0.1)
				TweenService:Create(btnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = origSize
				}):Play()

				if buttonConfig.Callback then
					buttonConfig.Callback()
				end
			end)

			clickBtn.MouseEnter:Connect(function()
				TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Window.Theme.ElementHover,
					Size = UDim2.new(1, 0, 0, 44)
				}):Play()
			end)

			clickBtn.MouseLeave:Connect(function()
				TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Window.Theme.ElementBackground,
					Size = UDim2.new(1, 0, 0, 42)
				}):Play()
			end)

			return btnFrame
		end

		function Tab:CreateToggle(toggleConfig)
			local togFrame = Instance.new("Frame")
			togFrame.Name = "Toggle"
			togFrame.Parent = tabContent
			togFrame.BackgroundColor3 = Window.Theme.ElementBackground
			togFrame.BorderSizePixel = 0
			togFrame.Size = UDim2.new(1, 0, 0, 42)
			togFrame.BackgroundTransparency = 1

			TweenService:Create(togFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			local togCorner = Instance.new("UICorner")
			togCorner.CornerRadius = UDim.new(0.1, 0)
			togCorner.Parent = togFrame

			local togLabel = Instance.new("TextLabel")
			togLabel.Parent = togFrame
			togLabel.BackgroundTransparency = 1
			togLabel.Position = UDim2.new(0.026, 0, 0, 0)
			togLabel.Size = UDim2.new(0.85, 0, 1, 0)
			togLabel.Font = Enum.Font.GothamMedium
			togLabel.Text = toggleConfig.Name or "Toggle"
			togLabel.TextColor3 = Window.Theme.TextPrimary
			togLabel.TextSize = 14
			togLabel.TextXAlignment = Enum.TextXAlignment.Left
			togLabel.TextYAlignment = Enum.TextYAlignment.Center
			togLabel.TextTransparency = 1

			task.wait(0.1)
			TweenService:Create(togLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			local state = toggleConfig.Default or false

			local checkBox = Instance.new("Frame")
			checkBox.Parent = togFrame
			checkBox.AnchorPoint = Vector2.new(1, 0.5)
			checkBox.BackgroundColor3 = state and Window.Theme.Accent or Window.Theme.CheckboxOff
			checkBox.BorderSizePixel = 0
			checkBox.Position = UDim2.new(0.975, 0, 0.5, 0)
			checkBox.Size = UDim2.new(0, 20, 0, 20)

			local checkC = Instance.new("UICorner")
			checkC.CornerRadius = UDim.new(0.2, 0)
			checkC.Parent = checkBox

			local checkMark = Instance.new("ImageLabel")
			checkMark.Parent = checkBox
			checkMark.BackgroundTransparency = 1
			checkMark.AnchorPoint = Vector2.new(0.5, 0.5)
			checkMark.Position = UDim2.new(0.5, 0, 0.5, 0)
			checkMark.Size = UDim2.new(0.7, 0, 0.7, 0)
			checkMark.Image = "rbxassetid://10709790644"
			checkMark.ImageColor3 = Window.Theme.ElementBackground
			checkMark.ImageTransparency = state and 0 or 1

			local clickBtn = Instance.new("TextButton")
			clickBtn.Parent = togFrame
			clickBtn.BackgroundTransparency = 1
			clickBtn.Size = UDim2.new(1, 0, 1, 0)
			clickBtn.Text = ""

			clickBtn.MouseButton1Click:Connect(function()
				state = not state

				TweenService:Create(checkBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = state and Window.Theme.Accent or Window.Theme.CheckboxOff
				}):Play()

				TweenService:Create(checkMark, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					ImageTransparency = state and 0 or 1
				}):Play()

				if toggleConfig.Callback then
					toggleConfig.Callback(state)
				end
			end)

			clickBtn.MouseEnter:Connect(function()
				TweenService:Create(togFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Window.Theme.ElementHover
				}):Play()
			end)

			clickBtn.MouseLeave:Connect(function()
				TweenService:Create(togFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Window.Theme.ElementBackground
				}):Play()
			end)

			return togFrame
		end

		function Tab:CreateParagraph(paragraphConfig)
			local paraFrame = Instance.new("Frame")
			paraFrame.Name = "Paragraph"
			paraFrame.Parent = tabContent
			paraFrame.BackgroundColor3 = Window.Theme.ElementBackground
			paraFrame.BorderSizePixel = 0
			paraFrame.Size = UDim2.new(1, 0, 0, 0)
			paraFrame.BackgroundTransparency = 1
			paraFrame.AutomaticSize = Enum.AutomaticSize.Y

			TweenService:Create(paraFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			local paraCorner = Instance.new("UICorner")
			paraCorner.CornerRadius = UDim.new(0.05, 0)
			paraCorner.Parent = paraFrame

			local paraPadding = Instance.new("UIPadding")
			paraPadding.Parent = paraFrame
			paraPadding.PaddingTop = UDim.new(0, 12)
			paraPadding.PaddingBottom = UDim.new(0, 12)
			paraPadding.PaddingLeft = UDim.new(0, 12)
			paraPadding.PaddingRight = UDim.new(0, 12)

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Name = "Title"
			titleLbl.Parent = paraFrame
			titleLbl.BackgroundTransparency = 1
			titleLbl.Size = UDim2.new(1, 0, 0, 0)
			titleLbl.Font = Enum.Font.GothamMedium
			titleLbl.Text = paragraphConfig.Title or "Title"
			titleLbl.TextColor3 = Window.Theme.TextPrimary
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.TextYAlignment = Enum.TextYAlignment.Top
			titleLbl.TextWrapped = true
			titleLbl.AutomaticSize = Enum.AutomaticSize.Y
			titleLbl.TextTransparency = 1

			local contentLbl = Instance.new("TextLabel")
			contentLbl.Name = "Content"
			contentLbl.Parent = paraFrame
			contentLbl.BackgroundTransparency = 1
			contentLbl.Position = UDim2.new(0, 0, 0, 20)
			contentLbl.Size = UDim2.new(1, 0, 0, 0)
			contentLbl.Font = Enum.Font.Gotham
			contentLbl.Text = paragraphConfig.Content or "Content"
			contentLbl.TextColor3 = Window.Theme.TextSecondary
			contentLbl.TextSize = 13
			contentLbl.TextXAlignment = Enum.TextXAlignment.Left
			contentLbl.TextYAlignment = Enum.TextYAlignment.Top
			contentLbl.TextWrapped = true
			contentLbl.AutomaticSize = Enum.AutomaticSize.Y
			contentLbl.TextTransparency = 1

			task.wait(0.1)
			TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			TweenService:Create(contentLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			return paraFrame
		end

		function Tab:CreateDivider()
			local divFrame = Instance.new("Frame")
			divFrame.Name = "Divider"
			divFrame.Parent = tabContent
			divFrame.BackgroundTransparency = 1
			divFrame.Size = UDim2.new(1, 0, 0, 12)

			local line = Instance.new("Frame")
			line.Parent = divFrame
			line.AnchorPoint = Vector2.new(0, 0.5)
			line.BackgroundColor3 = Window.Theme.Divider
			line.BorderSizePixel = 0
			line.Position = UDim2.new(0, 0, 0.5, 0)
			line.Size = UDim2.new(1, 0, 0, 1)
			line.BackgroundTransparency = 1

			task.wait(0.1)
			TweenService:Create(line, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			return divFrame
		end

		function Tab:CreateSection(sectionConfig)
			local sectFrame = Instance.new("Frame")
			sectFrame.Name = "Section"
			sectFrame.Parent = tabContent
			sectFrame.BackgroundTransparency = 1
			sectFrame.Size = UDim2.new(1, 0, 0, 28)

			local sectLabel = Instance.new("TextLabel")
			sectLabel.Parent = sectFrame
			sectLabel.BackgroundTransparency = 1
			sectLabel.Size = UDim2.new(1, 0, 1, 0)
			sectLabel.Font = Enum.Font.GothamMedium
			sectLabel.Text = sectionConfig.Name or "Section"
			sectLabel.TextColor3 = Window.Theme.Accent
			sectLabel.TextSize = sectionConfig.Size or 15
			sectLabel.TextXAlignment = sectionConfig.Side == "Right" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
			sectLabel.TextYAlignment = Enum.TextYAlignment.Center
			sectLabel.TextTransparency = 1

			task.wait(0.1)
			TweenService:Create(sectLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			return sectFrame
		end

		return Tab
	end

	return Window
end

return SeizureUI
