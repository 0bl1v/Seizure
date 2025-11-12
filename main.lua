-- SeizureUI Library
-- A modern UI library for Roblox
-- Version: 1.0

local SeizureUI = {}
SeizureUI.__index = SeizureUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Create main library object
function SeizureUI:CreateWindow(config)
	local Window = {}
	Window.Config = config or {}
	Window.Title = Window.Config.Title or "SeizureUI"
	Window.Author = Window.Config.Author or "inspired by windui"
	Window.Tabs = {}
	Window.CurrentTab = nil
	
	-- Create ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SeizureUI"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	
	-- Create Background Frame
	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Parent = ScreenGui
	Background.AnchorPoint = Vector2.new(0.5, 0.5)
	Background.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
	Background.BorderSizePixel = 0
	Background.Position = UDim2.new(0.5, 0, 0.5, 0)
	Background.Size = UDim2.new(0, 652, 0, 392)
	Background.ClipsDescendants = true
	
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0.02, 0)
	UICorner.Parent = Background
	
	-- Header Section
	local icon = Instance.new("ImageLabel")
	icon.Name = "icon"
	icon.Parent = Background
	icon.BackgroundTransparency = 1
	icon.Position = UDim2.new(0.02, 0, 0.028, 0)
	icon.Size = UDim2.new(0, 35, 0, 35)
	icon.Image = "rbxassetid://156513166"
	
	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0.2, 0)
	iconCorner.Parent = icon
	
	local title = Instance.new("TextLabel")
	title.Name = "title"
	title.Parent = Background
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0.094, 0, 0.028, 0)
	title.Size = UDim2.new(0, 548, 0, 21)
	title.Font = Enum.Font.GothamBold
	title.Text = Window.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "subtitle"
	subtitle.Parent = Background
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.new(0.094, 0, 0.064, 0)
	subtitle.Size = UDim2.new(0, 548, 0, 21)
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = Window.Author
	subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	subtitle.TextSize = 12
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Tab Container (Left Side)
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Parent = Background
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0.019, 0, 0.145, 0)
	TabContainer.Size = UDim2.new(0, 120, 0, 300)
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabContainer
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 8)
	
	-- Content Container (Right Side)
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = Background
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0.22, 0, 0.143, 0)
	ContentContainer.Size = UDim2.new(0, 492, 0, 320)
	
	-- Make draggable
	local dragging = false
	local dragInput, mousePos, framePos
	
	Background.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = Background.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	Background.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			Background.Position = UDim2.new(
				framePos.X.Scale,
				framePos.X.Offset + delta.X,
				framePos.Y.Scale,
				framePos.Y.Offset + delta.Y
			)
		end
	end)
	
	-- Tab Creation
	function Window:CreateTab(tabConfig)
		local Tab = {}
		Tab.Name = tabConfig.Name or "Tab"
		Tab.Elements = {}
		
		-- Create Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = "Tab_" .. Tab.Name
		TabButton.Parent = TabContainer
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 0, 21)
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = Tab.Name
		TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabButton.TextSize = 14
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		
		-- Create Tab Content
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = "Content_" .. Tab.Name
		TabContent.Parent = ContentContainer
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.ScrollBarThickness = 4
		TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
		TabContent.Visible = false
		
		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.Parent = TabContent
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 8)
		
		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
		end)
		
		-- Tab Click Handler
		TabButton.MouseButton1Click:Connect(function()
			-- Hide all tabs
			for _, tab in pairs(Window.Tabs) do
				tab.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
				tab.Content.Visible = false
			end
			
			-- Show this tab
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabContent.Visible = true
			Window.CurrentTab = Tab
		end)
		
		Tab.Button = TabButton
		Tab.Content = TabContent
		
		-- Auto-select first tab
		if #Window.Tabs == 0 then
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabContent.Visible = true
			Window.CurrentTab = Tab
		end
		
		table.insert(Window.Tabs, Tab)
		
		-- Button Creation Function
		function Tab:CreateButton(buttonConfig)
			local buttonFrame = Instance.new("Frame")
			buttonFrame.Name = "Button"
			buttonFrame.Parent = TabContent
			buttonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			buttonFrame.BorderSizePixel = 0
			buttonFrame.Size = UDim2.new(1, 0, 0, 42)
			
			local buttonCorner = Instance.new("UICorner")
			buttonCorner.CornerRadius = UDim.new(0.1, 0)
			buttonCorner.Parent = buttonFrame
			
			local buttonLabel = Instance.new("TextLabel")
			buttonLabel.Parent = buttonFrame
			buttonLabel.BackgroundTransparency = 1
			buttonLabel.Position = UDim2.new(0.026, 0, 0, 0)
			buttonLabel.Size = UDim2.new(0.95, 0, 1, 0)
			buttonLabel.Font = Enum.Font.Gotham
			buttonLabel.Text = buttonConfig.Name or "Button"
			buttonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			buttonLabel.TextSize = 14
			buttonLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local clickButton = Instance.new("TextButton")
			clickButton.Parent = buttonFrame
			clickButton.BackgroundTransparency = 1
			clickButton.Size = UDim2.new(1, 0, 1, 0)
			clickButton.Text = ""
			
			clickButton.MouseButton1Click:Connect(function()
				if buttonConfig.Callback then
					buttonConfig.Callback()
				end
			end)
			
			-- Hover effect
			clickButton.MouseEnter:Connect(function()
				TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
			end)
			
			clickButton.MouseLeave:Connect(function()
				TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
			end)
			
			return buttonFrame
		end
		
		return Tab
	end
	
	return Window
end

return SeizureUI
