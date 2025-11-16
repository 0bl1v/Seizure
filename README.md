# seizureui module doc

## window

``` lua
local window = seizureui:createwindow({
    title = "my super hub",
    description = "inspired by windui",
    icon = "rbxassetid://12345678",
    size = udim2.new(0, 652, 0, 392)
})
```

## tab

``` lua
local tab = window:createtab({
    name = "home"
})
```

## button

``` lua
tab:createbutton({
    name = "click me",
    callback = function()
        print("clicked")
    end
})
```

## toggle

``` lua
tab:createtoggle({
    name = "esp",
    default = false,
    callback = function(v)
        print(v)
    end
})
```
