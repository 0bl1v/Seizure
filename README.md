## window

``` lua
local window = seizureui:createwindow({
    title = "my super hub",
    description = "inspired by windui",
    icon = "rbxassetid://12345678",
    size = udim2.new(0, 652, 0, 400)
})
```

## tab

``` lua
local tab1 = window:createtab({
    name = "home"
})
```

## button

``` lua
tab1:createbutton({
    name = "click me",
    callback = function()
        print("button clicked")
    end
})
```

## toggle

``` lua
tab1:createtoggle({
    name = "esp",
    default = false,
    callback = function(v)
        print(v)
    end
})
```
