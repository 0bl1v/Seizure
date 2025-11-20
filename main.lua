local SeizureUI = {}
SeizureUI.__index = SeizureUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Helper function to create instances
local function New(ClassName, Properties)
	local Object = Instance.new(ClassName)
	if Properties then
		for Property, Value in next, Properties do
			Object[Property] = Value
		end
	end
	return Object
end

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

	local ScreenGui = New("ScreenGui", {
		Name = "SeizureUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})

	pcall(function()
		ScreenGui.Parent = getParent()
	end)

	if not ScreenGui.Parent then
		ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	local bg = New("Frame", {
		Name = "Background",
		Parent = ScreenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Window.Theme.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		ClipsDescendants = true,
		BackgroundTransparency = 1
	})

	local corner = New("UICorner", {
		CornerRadius = UDim.new(0.02, 0),
		Parent = bg
	})

	local introTween = TweenService:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = Window.Size,
		BackgroundTransparency = 0
	})
	introTween:Play()

	local icon = New("ImageLabel", {
		Name = "icon",
		Parent = bg,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.02, 0, 0.028, 0),
		Size = UDim2.new(0, 35, 0, 35),
		Image = Window.Icon,
		ImageTransparency = 1
	})

	local iconC = New("UICorner", {
		CornerRadius = UDim.new(0.2, 0),
		Parent = icon
	})

	local title = New("TextLabel", {
		Name = "title",
		Parent = bg,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.094, 0, 0.028, 0),
		Size = UDim2.new(0, 548, 0, 21),
		Font = Enum.Font.GothamMedium,
		Text = Window.Title,
		TextColor3 = Window.Theme.TextPrimary,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 1
	})

	local subtitle = New("TextLabel", {
		Name = "subtitle",
		Parent = bg,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.094, 0, 0.064, 0),
		Size = UDim2.new(0, 548, 0, 21),
		Font = Enum.Font.Gotham,
		Text = Window.Description,
		TextColor3 = Window.Theme.TextSecondary,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 1
	})

	task.wait(0.3)
	TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
	TweenService:Create(title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

	local wWidth = Window.Size.X.Offset
	local wHeight = Window.Size.Y.Offset
	local tabH = wHeight * 0.765
	local contentW = wWidth * 0.754
	local contentH = wHeight * 0.816

	local TabContainer = New("Frame", {
		Name = "TabContainer",
		Parent = bg,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.019, 0, 0.145, 0),
		Size = UDim2.new(0, 120, 0, tabH)
	})

	local TabLayout = New("UIListLayout", {
		Parent = TabContainer,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	})

	local ContentContainer = New("Frame", {
		Name = "ContentContainer",
		Parent = bg,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.22, 0, 0.143, 0),
		Size = UDim2.new(0, contentW, 0, contentH)
	})

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

		local TabButton = New("TextButton", {
			Name = "Tab_" .. Tab.Name,
			Parent = TabContainer,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 21),
			Font = Enum.Font.Gotham,
			Text = Tab.Name,
			TextColor3 = Window.Theme.TextSecondary,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTransparency = 1
		})

		task.wait(0.05)
		TweenService:Create(TabButton, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

		local tabContent = New("ScrollingFrame", {
			Name = "Content_" .. Tab.Name,
			Parent = ContentContainer,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 4,
			ScrollBarImageTransparency = 1,
			Visible = false
		})

		local ContentLayout = New("UIListLayout", {
			Parent = tabContent,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		})

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
			local btnFrame = New("Frame", {
				Name = "Button",
				Parent = tabContent,
				BackgroundColor3 = Window.Theme.ElementBackground,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 42),
				BackgroundTransparency = 1
			})

			TweenService:Create(btnFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			New("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
				Parent = btnFrame
			})

			local btnLabel = New("TextLabel", {
				Parent = btnFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.026, 0, 0, 0),
				Size = UDim2.new(0.95, 0, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = buttonConfig.Name or "Button",
				TextColor3 = Window.Theme.TextPrimary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTransparency = 1
			})

			task.wait(0.1)
			TweenService:Create(btnLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			local clickBtn = New("TextButton", {
				Parent = btnFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})

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
			local togFrame = New("Frame", {
				Name = "Toggle",
				Parent = tabContent,
				BackgroundColor3 = Window.Theme.ElementBackground,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 42),
				BackgroundTransparency = 1
			})

			TweenService:Create(togFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			local togCorner = New("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
				Parent = togFrame
			})

			local togLabel = New("TextLabel", {
				Parent = togFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.026, 0, 0, 0),
				Size = UDim2.new(0.85, 0, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = toggleConfig.Name or "Toggle",
				TextColor3 = Window.Theme.TextPrimary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTransparency = 1
			})

			task.wait(0.1)
			TweenService:Create(togLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			local state = toggleConfig.Default or false

			local checkBox = New("Frame", {
				Parent = togFrame,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = state and Window.Theme.Accent or Window.Theme.CheckboxOff,
				BorderSizePixel = 0,
				Position = UDim2.new(0.975, 0, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20)
			})

			local checkC = New("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
				Parent = checkBox
			})

			local checkMark = New("ImageLabel", {
				Parent = checkBox,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.7, 0, 0.7, 0),
				Image = "rbxassetid://10709790644",
				ImageColor3 = Window.Theme.ElementBackground,
				ImageTransparency = state and 0 or 1
			})

			local clickBtn = New("TextButton", {
				Parent = togFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})

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
			local paraFrame = New("Frame", {
				Name = "Paragraph",
				Parent = tabContent,
				BackgroundColor3 = Window.Theme.ElementBackground,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			})

			TweenService:Create(paraFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			local paraCorner = New("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
				Parent = paraFrame
			})

			local paraPadding = New("UIPadding", {
				Parent = paraFrame,
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12)
			})

			local titleLbl = New("TextLabel", {
				Name = "Title",
				Parent = paraFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Font = Enum.Font.GothamMedium,
				Text = paragraphConfig.Title or "Title",
				TextColor3 = Window.Theme.TextPrimary,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextTransparency = 1
			})

			local contentLbl = New("TextLabel", {
				Name = "Content",
				Parent = paraFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 0, 0),
				Font = Enum.Font.Gotham,
				Text = paragraphConfig.Content or "Content",
				TextColor3 = Window.Theme.TextSecondary,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextTransparency = 1
			})

			task.wait(0.1)
			TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			TweenService:Create(contentLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			return paraFrame
		end

		function Tab:CreateDivider()
			local divFrame = New("Frame", {
				Name = "Divider",
				Parent = tabContent,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 12)
			})

			local line = New("Frame", {
				Parent = divFrame,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Window.Theme.Divider,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundTransparency = 1
			})

			task.wait(0.1)
			TweenService:Create(line, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

			return divFrame
		end

		function Tab:CreateSection(sectionConfig)
			local sectFrame = New("Frame", {
				Name = "Section",
				Parent = tabContent,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 28)
			})

			local sectLabel = New("TextLabel", {
				Parent = sectFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = sectionConfig.Name or "Section",
				TextColor3 = Window.Theme.Accent,
				TextSize = sectionConfig.Size or 15,
				TextXAlignment = sectionConfig.Side == "Right" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTransparency = 1
			})

			task.wait(0.1)
			TweenService:Create(sectLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

			return sectFrame
		end

		return Tab
	end

	return Window
end

return SeizureUI
