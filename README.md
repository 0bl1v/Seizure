# seizure

## window
creates the main window

**code block name:** window setup  
place after requiring the module

**fields**  
- title: string  
- description: string  
- icon: string  
- size: udim2  

**example**
```lua
local window = seizureui:createwindow({
    title = "my super hub",
    description = "inspired by windui",
    icon = "rbxassetid://12345678",
    size = udim2.new(0, 652, 0, 400)
})
