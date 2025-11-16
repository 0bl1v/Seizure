# SeizureUI Documentation

SeizureUI is a modern and user-friendly UI framework designed for Roblox. Below are examples and usage details for creating GUI components using SeizureUI.

---

## Creating a Window (`createwindow`)

```lua
local window = seizureui:createwindow({
    title = "My Super Hub",
    description = "Inspired by WindUI",
    icon = "rbxassetid://12345678",
    size = UDim2.new(0, 652, 0, 392)
})
```

### Parameters:

| Field         | Type   | Description                                            |
| ------------- | ------ | ------------------------------------------------------ |
| `title`       | string | The title text of the window                           |
| `description` | string | A secondary description text displayed below the title |
| `icon`        | string | Icon used in the title header (Roblox asset ID)        |
| `size`        | UDim2  | The size of the window                                 |

---

## Creating a Tab (`createtab`)

```lua
local tab = window:createtab({
    name = "Home"
})
```

### Parameters:

| Field  | Type   | Description         |
| ------ | ------ | ------------------- |
| `name` | string | The name of the tab |

---

## Creating a Button (`createbutton`)

```lua
tab:createbutton({
    name = "Click Me",
    callback = function()
        print("Button clicked")
    end
})
```

### Parameters:

| Field      | Type     | Description                                |
| ---------- | -------- | ------------------------------------------ |
| `name`     | string   | The button label                           |
| `callback` | function | Function called when the button is clicked |

---

## Creating a Toggle (`createtoggle`)

```lua
tab:createtoggle({
    name = "ESP",
    default = false,
    callback = function(value)
        print("ESP status:", value)
    end
})
```

### Parameters:

| Field      | Type     | Description                                                                       |
| ---------- | -------- | --------------------------------------------------------------------------------- |
| `name`     | string   | The toggle label                                                                  |
| `default`  | boolean  | Default toggle state (`true` for on, `false` for off)                             |
| `callback` | function | Function called when the toggle state changes, receiving `value` as the new state |
