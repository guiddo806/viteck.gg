--// init
repeat task.wait() until game:IsLoaded();
cloneref = cloneref ~= nil and cloneref or function(f) return f end; 
getgenv = getgenv ~= nil and getgenv or function() return _G end; 
if not gethui then gethui = function() return enviroment.players.LocalPlayer.PlayerGui end end;
local enviroment = setmetatable({}, { __index = function(_, index)
    local v = index:gsub("_%l", string.upper):gsub("_", ""):gsub("^%l", string.upper);
    return cloneref(game:GetService(v));
end});
--
do -- checks
    if not isfolder("viteck/") then
		makefolder("viteck/");
	end
    --
	if not isfolder("viteck/configs/") then
		makefolder("viteck/configs/");
	end
	--
	if not isfolder("viteck/lua/") then
		makefolder("viteck/lua/");
	end
end
--
local viteck = {
    fonts = { 
        cache = {}, 
        options = { Graph_35 = {}, Smallest_Pixel = {}, Templeos = {} },
    },
    utilities = {}, functions = {},
};

-- variables
local workspace      = enviroment.workspace;
local camera         = workspace.CurrentCamera;
local local_plr      = enviroment.players.LocalPlayer;
local get_mouse      = local_plr:GetMouse();
local pid_name       = enviroment.MarketplaceService:GetProductInfo(game.PlaceId).Name
local game_id        = game.GameId
--
do -- fonts
    function viteck.fonts.cache:Register_Font(Name, Weight, Style, Asset)
        if not isfolder("viteck") then makefolder("viteck") end
        local asset = "viteck/" .. Asset.Id;
        local font = "viteck/" .. Name .. ".font";
        if not isfile(asset) then writefile(asset, Asset.Font) end
        writefile(font, enviroment.HttpService:JSONEncode({ name = Name, faces = {{ name = "Regular", weight = Weight, style = Style, assetId = getcustomasset(asset) }} }))
        return getcustomasset(font)
    end    
    --
    viteck.fonts.options = ({
        Graph_35          = Font.new(viteck.fonts.cache:Register_Font("Graph_35", 200, "normal", { Id = "Graph_35.ttf", Font = crypt.base64.decode("https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/assets/fonts/graph_35") })),
        Smallest_Pixel    = Font.new(viteck.fonts.cache:Register_Font("Smallest_Pixel", 200, "normal", { Id = "Smallest_Pixel.ttf", Font = crypt.base64.decode("https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/assets/fonts/smallest_pixel") })),
        Templeos          = Font.new(viteck.fonts.cache:Register_Font("Templeos", 200, "normal", { Id = "Templeos.ttf", Font = crypt.base64.decode("https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/assets/fonts/templeos") }))
    });
end
--
local library = ({
    open = true,
    blur = false,
    size = UDim2.new(0, 750, 0, 600),
    font_size = 7,
    font = viteck.fonts.options.Graph_35,
    ui_key = Enum.KeyCode.RightShift,
    screen_gui = nil,
    holder = nil,
    menu_colors = {
        background = Color3.fromRGB(13, 13, 13),
        main = Color3.fromRGB(21, 21, 21),
        accent = Color3.fromRGB(219, 112, 112),
        inline_accent = Color3.fromRGB(255, 48, 93),
        outline = Color3.fromRGB(35, 35, 35)
    };

    keys = {
        [Enum.KeyCode.LeftShift] = "LS", [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC", [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.LeftAlt] = "LA", [Enum.KeyCode.RightAlt] = "RA", [Enum.KeyCode.CapsLock] = "Caps",
    
        [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2", [Enum.KeyCode.Three] = "3", 
        [Enum.KeyCode.Four] = "4", [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8", [Enum.KeyCode.Nine] = "9", [Enum.KeyCode.Zero] = "0",
    
        [Enum.KeyCode.KeypadOne] = "Num1", [Enum.KeyCode.KeypadTwo] = "Num2", [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4", [Enum.KeyCode.KeypadFive] = "Num5", [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7", [Enum.KeyCode.KeypadEight] = "Num8", [Enum.KeyCode.KeypadNine] = "Num9", 
        [Enum.KeyCode.KeypadZero] = "Num0",
    
        [Enum.KeyCode.Minus] = "-", [Enum.KeyCode.Equals] = "=", [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[", [Enum.KeyCode.RightBracket] = "]", 
        [Enum.KeyCode.RightParenthesis] = ")", [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ";", [Enum.KeyCode.Quote] = "'", [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",", [Enum.KeyCode.Period] = ".", [Enum.KeyCode.Slash] = "/", 
        [Enum.KeyCode.Asterisk] = "*", [Enum.KeyCode.Plus] = "+", [Enum.KeyCode.Backquote] = "`",
    
        [Enum.UserInputType.MouseButton1] = "M1", [Enum.UserInputType.MouseButton2] = "M2", 
        [Enum.UserInputType.MouseButton3] = "M3"
    };  
    
    theme = {};
    pages = {}; 
    page_amount = 0;
    sections = {};
    flags = {};
    un_named_flags = 0;
    notifications = {};
});

-- set
local flags = {}; -- Ignore
library.__index = library
library.pages.__index = library.pages
library.sections.__index = library.sections

do -- menu functions
    function library:create(inst, theme)
        local obj = Instance.new(inst)
    
        if theme ~= false then
            table.insert(library.theme, obj)
            local properties = {
                Frame = "BackgroundColor3", 
                TextButton = "BackgroundColor3", 
                TextLabel = "TextColor3", 
                TextBox = "TextColor3", 
                ImageLabel = "ImageColor3", 
                ImageButton = "ImageColor3", 
                UIStroke = "Color"
            };
    
            for class, property in pairs(properties) do
                if obj:IsA(class) then
                    obj[property] = library.menu_colors.inline_accent
                end
            end

            if obj:IsA("ScrollingFrame") then
                obj.ScrollBarImageColor3 = library.menu_colors.inline_accent
            end
        end
    
        return obj
    end    
    --
    function library.NextFlag()
        library.un_named_flags = library.un_named_flags + 1
        return string.format("%.14g", library.un_named_flags)
    end
    --
    function library:IsMouseOverFrame(Frame)
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

        if get_mouse.X >= AbsPos.X and get_mouse.X <= AbsPos.X + AbsSize.X
            and get_mouse.Y >= AbsPos.Y and get_mouse.Y <= AbsPos.Y + AbsSize.Y then

            return true;
        end;
    end;
    --
    function library:random_string(length)
        local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local result = "" -- input
        for _ = 1, length do
            local random = math.random(1, #charset)
            result = result .. charset:sub(random, random);
        end
        return result;
    end
    --
    function library:connection(signal, callback)
        local connection = signal:Connect(callback)
        return connection
    end    
    --
    function library:Disconnect(Connection)
        Connection:Disconnect()
    end  
    --
    function library:round(Number, Float)
        return Float * math.floor(Number / Float)
    end
    -- 
    function library:resize(object, background)
        local dragging, currentsize
        library:connection(object.MouseButton1Down, function()
            dragging = true
        end)
        
        library:connection(get_mouse.Move, function()
            if dragging then
                local X = math.clamp(enviroment.user_input_service:GetMouseLocation().X - background.AbsolutePosition.X, 590, 1180)
                local Y = math.clamp((enviroment.user_input_service:GetMouseLocation().Y - 36) - background.AbsolutePosition.Y, 470, 940)
                currentsize = UDim2.new(0, X, 0, Y)
                background.Size = currentsize
            end
        end)
        
        library:connection(enviroment.user_input_service.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end    
    -- 
    function library:RGBA(r, g, b, alpha)
        local rgb = Color3.fromRGB(r, g, b)
        local mt = table.clone(getrawmetatable(rgb))

        setreadonly(mt, false)
        local old = mt.__index

        mt.__index = newcclosure(function(self, key)
            if key:lower() == "transparency" then
                return alpha
            end
            return old(self, key)
        end)

        setrawmetatable(rgb, mt)
        return rgb
    end
    -- 
    function library:GetConfig()
        local Config = ""
        for Index, Value in pairs(self.flags) do
            if Index ~= "ConfigConfig_List" and Index ~= "ConfigConfig_Load" and Index ~= "ConfigConfig_Save" then
                local Value2 = Value
                local Final = ""
                --
                if typeof(Value2) == "Color3" then
                    local hue, sat, val = Value2:ToHSV()
                    --
                    Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
                elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
                    local hue, sat, val = Value2.Color:ToHSV()
                    --
                    Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
                elseif typeof(Value2) == "table" and Value2.Mode then
                    local Values = Value.current
                    --
                    Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
                elseif Value2 ~= nil then
                    if typeof(Value2) == "boolean" then
                        Value2 = ("bool(%s)"):format(tostring(Value2))
                    elseif typeof(Value2) == "table" then
                        local New = "table("
                        --
                        for _, Value3 in pairs(Value2) do
                            New = New .. Value3 .. ","
                        end
                        --
                        if New:sub(#New) == "," then
                            New = New:sub(0, #New - 1)
                        end
                        --
                        Value2 = New .. ")"
                    elseif typeof(Value2) == "string" then
                        Value2 = ("string(%s)"):format(Value2)
                    elseif typeof(Value2) == "number" then
                        Value2 = ("number(%s)"):format(Value2)
                    end
                    --
                    Final = Value2
                end
                --
                Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
            end
        end
        --
        return Config
    end
    --
    function library:LoadConfig(Config)
        local Table = string.split(Config, "\n")
        local Table2 = {}
        for _, Value in pairs(Table) do
            local Table3 = string.split(Value, ":")
            --
            if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
                local Value = Table3[2]:sub(2, #Table3[2])
                --
                if Value:sub(1, 3) == "rgb" then
                    local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                    --
                    Value = Table4
                elseif Value:sub(1, 3) == "key" then
                    local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                    --
                    if Table4[1] == "nil" and Table4[2] == "nil" then
                        Table4[1] = nil
                        Table4[2] = nil
                    end
                    --
                    Value = Table4
                elseif Value:sub(1, 4) == "bool" then
                    local Bool = Value:sub(6, #Value - 1)
                    --
                    Value = Bool == "true"
                elseif Value:sub(1, 5) == "table" then
                    local Table4 = string.split(Value:sub(7, #Value - 1), ",")
                    --
                    Value = Table4
                elseif Value:sub(1, 6) == "string" then
                    local String = Value:sub(8, #Value - 1)
                    --
                    Value = String
                elseif Value:sub(1, 6) == "number" then
                    local Number = tonumber(Value:sub(8, #Value - 1))
                    --
                    Value = Number
                end
                --
                Table2[Table3[1]] = Value
            end
        end
        --
        for i, v in pairs(Table2) do
            if flags[i] then
                if typeof(flags[i]) == "table" then
                    flags[i]:Set(v)
                else
                    flags[i](v)
                end
            end
        end
    end  
end
--
do -- menu elements
    function library:notification(options)
        local message = options.message or "Notification"
        local duration = options.duration or 5
        local color = options.color or library.menu_colors.accent
        local player = options.player
        local success, notification = pcall(function()
            local notification = {
                Container = nil, Objects = {}
            }
            local notif_ui = cloneref(Instance.new("ScreenGui", library.screen_gui.Parent))
            local notifcontainer = Instance.new('Frame', notif_ui)
            local outline = Instance.new("Frame")
            local inline = Instance.new("Frame")
            local value = library:create("TextLabel", true)
            local uipadding = Instance.new("UIPadding")
            local time_line = Instance.new("Frame")
            local base_position = Vector2.new(5, 65)
            local player_image = player and Instance.new("ImageLabel")
            do
                notif_ui.Name = "notification_" .. library:random_string(10)
                notif_ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                notif_ui.IgnoreGuiInset = true
                library.noti_screen_gui = notif_ui
                notifcontainer.Name = library:random_string(10)
                notifcontainer.Position = UDim2.new(0, base_position.X, 0, base_position.Y + (#library.notifications * 25))
                notifcontainer.AutomaticSize = Enum.AutomaticSize.X
                notifcontainer.Size = UDim2.new(0, 0, 0, 18)
                notifcontainer.BackgroundTransparency = 1
                notifcontainer.BorderSizePixel = 0
                notifcontainer.ZIndex = 1000
                notification.Container = notifcontainer
                outline.Name = library:random_string(10)
                outline.AutomaticSize = Enum.AutomaticSize.X
                outline.BackgroundColor3 = library.menu_colors.background
                outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                outline.Position = UDim2.new(0, 0, 0, 0)
                outline.Size = UDim2.new(0, 0, 0, 18)
                outline.BackgroundTransparency = 0
                outline.Parent = notifcontainer
                table.insert(notification.Objects, outline)
                inline.Name = library:random_string(10)
                inline.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
                inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                inline.BorderSizePixel = 0
                inline.Position = UDim2.new(0, 1, 0, 1)
                inline.Size = UDim2.new(1, -2, 1, -2)
                inline.BackgroundTransparency = 0
                inline.Parent = outline
                table.insert(notification.Objects, inline)
                if player then
                    local success, imagedata = pcall(function()
                        return enviroment.players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                    end)
                    if success then
                        player_image.Image = imagedata
                        player_image.Size = UDim2.new(0, 14, 0, 14)
                        player_image.Position = UDim2.new(0, 4, 0, 2)
                        player_image.BackgroundTransparency = 1
                        player_image.Parent = inline
                        value.Position = UDim2.new(0, 20, 0, 0)
                        table.insert(notification.Objects, player_image)
                    end
                end
                value.Name = library:random_string(10)
                value.Text = message
                value.TextColor3 = Color3.fromRGB(255, 255, 255)
                value.TextStrokeTransparency = 0
                value.TextXAlignment = Enum.TextXAlignment.Left
                value.AutomaticSize = Enum.AutomaticSize.X
                value.BackgroundTransparency = 1
                value.Size = UDim2.new(0, 0, 1, 0)
                value.TextTransparency = 0
                value.Parent = inline
                value.FontFace = library.font
                value.TextSize = library.font_size
                table.insert(notification.Objects, value)
                uipadding.Name = library:random_string(10)
                uipadding.PaddingLeft = UDim.new(0, 5)
                uipadding.PaddingRight = UDim.new(0, 5)
                uipadding.PaddingTop = UDim.new(0, 1)
                uipadding.Parent = value
                time_line.Name = library:random_string(10)
                time_line.BackgroundColor3 = color
                time_line.BorderColor3 = Color3.fromRGB(0, 0, 0)
                time_line.BorderSizePixel = 0
                time_line.Size = UDim2.new(0, 0, 0, 1)
                time_line.Position = UDim2.new(0, 0, 1, -1)
                time_line.BackgroundTransparency = 0
                time_line.Parent = outline
                time_line.ZIndex = -1
                table.insert(notification.Objects, time_line)
            end
            function notification:remove()
                local index = table.find(library.notifications, notification)
                if index then
                    for _, v in ipairs(notification.Objects) do
                        if v:IsA("Frame") or v:IsA("ImageLabel") then
                            enviroment.tween_service:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                        elseif v:IsA("TextLabel") then
                            enviroment.tween_service:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
                        end
                    end
                    task.wait(0.5)
                    table.remove(library.notifications, index)
                    notif_ui:Destroy()
                    for i = index, #library.notifications do
                        local notif = library.notifications[i]
                        local newPosition = UDim2.new(0, base_position.X, 0, base_position.Y + (i - 1) * 25)
                        enviroment.tween_service:Create(notif.Container, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPosition}):Play()
                    end
                end
            end
            task.spawn(function()
                enviroment.tween_service:Create(time_line, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 1)}):Play()
                task.wait(duration)
                notification:remove()
            end)
            if #library.notifications > 5 then
                library.notifications[1]:remove()
            end
            table.insert(library.notifications, notification)
            return notification
        end)
        if not success then
            warn("Notification creation failed:", notification)
        end
    end
    --
    function library:watermark(properties)
        local watermark = {
            name = (properties.Name or properties.name or "watermark text | placeholder");
        };
        --
        local watermark_ui = cloneref(Instance.new("ScreenGui", gethui()))
        local Outline = Instance.new("Frame")
        local TopLine = library:create("Frame", true)
        local Inline = Instance.new("Frame")
        local Value = library:create("TextLabel", true)
        local UIPadding = Instance.new("UIPadding")
        local watermark_stroke = Instance.new("UIStroke")
    
        do -- properties
            watermark_ui.Name = "Watermark"
            watermark_ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            watermark_ui.IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets
            watermark_ui.IgnoreGuiInset = true
            library.watermark_screen_gui = watermark_ui

            Outline.Name = library:random_string(10)
            Outline.AutomaticSize = Enum.AutomaticSize.X
            Outline.BackgroundColor3 = library.menu_colors.main
            Outline.BorderColor3 = library.menu_colors.outline
            Outline.Position = UDim2.new(0.5, 0, 0.02, 0)
            Outline.BorderSizePixel = 0
            Outline.AnchorPoint = Vector2.new(0.5, 0) 
            Outline.Size = UDim2.new(0, 0, 0, 20)
            Outline.Visible = false
            Outline.Parent = watermark_ui

            watermark_stroke.Name = library:random_string(10)
            watermark_stroke.Color = Color3.fromRGB(70, 70, 70)
            watermark_stroke.LineJoinMode = Enum.LineJoinMode.Miter
            watermark_stroke.Thickness = 1
            watermark_stroke.Parent = Outline
    
            Value.FontFace = library.font
            Value.TextSize = library.font_size
            Value.Name = library:random_string(10)
            Value.Text = watermark.name
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.RichText = true;
            Value.TextStrokeTransparency = 0
            Value.TextXAlignment = Enum.TextXAlignment.Center
            Value.AutomaticSize = Enum.AutomaticSize.X
            Value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.RichText = true
            Value.Size = UDim2.new(0, 0, 1, 0)
            Value.Parent = Outline

			UIPadding.Name = library:random_string(10)
            UIPadding.PaddingLeft = UDim.new(0, 5)
            UIPadding.PaddingRight = UDim.new(0, 5)
            UIPadding.Parent = Value
        end
        
        -- functions
        function watermark:update_text(NewText)
            Value.Text = NewText;
        end
    
        function watermark:Position(NewPositionX, NewPositionY)
            if NewPositionX ~= nil then
                self.HorizontalPosition = NewPositionX
            end
            if NewPositionY ~= nil then
                self.VerticalPosition = NewPositionY
            end
            Outline.Position = UDim2.new(self.HorizontalPosition, 0, self.VerticalPosition, 0);
        end
        
        function watermark:enabled(State)
            Outline.Visible = State;
        end
    
        return watermark;
    end
    --
    local pages = library.pages;
    local sections = library.sections;
    -- 
    function library:window(options)
        local window = {
            name = (options.Name or options.name or "Name");
            position = (options.position == "left" and Enum.TextXAlignment.Left) or (options.position == "center" and Enum.TextXAlignment.Center) or (options.position == "right" and Enum.TextXAlignment.Right) or Enum.TextXAlignment.Left,
            dragging = { false, UDim2.new(0, 0, 0, 0) };
            page_amount = options.Amount or options.amount or 5;
            elements = {};
            sections = {};
            pages = {}; 
        };
        --
        local UI = cloneref(Instance.new("ScreenGui", gethui()))
        local background = Instance.new("Frame")
        local ui_stroke_bg = Instance.new("UIStroke")
        local outline_background = library:create("Frame")
        local ui_stroke_bg2 = Instance.new("UIStroke")
        local inline_background = Instance.new("Frame")
        local ui_stroke_bg3 = Instance.new("UIStroke")
        local title = library:create("TextLabel")
        local tabs = Instance.new("Frame")
        local tabs_layout = Instance.new("UIListLayout")
        local page_inline = Instance.new("Frame")
        
        do -- properties
            UI.Name = "UI"
            UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            UI.IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets
            library.screen_gui = UI
    
            background.Name = "Outline_Background"
            background.AnchorPoint = Vector2.new(0.5, 0.5)
            background.BackgroundColor3 = library.menu_colors.background
            background.BackgroundTransparency = 0
            background.Position = UDim2.new(0.5, 0, 0.5, 0)
            background.BorderColor3 = Color3.fromRGB(0, 0, 0)
            background.BorderSizePixel = 2
            background.Size = library.size
            background.ZIndex = 1
            background.Parent = UI                                                               
    
            ui_stroke_bg.Name = library:random_string(10)
            ui_stroke_bg.Color = Color3.fromRGB(35, 35, 35)
            ui_stroke_bg.LineJoinMode = Enum.LineJoinMode.Miter
            ui_stroke_bg.Thickness = 1
            ui_stroke_bg.Parent = background
    
            outline_background.Name = "Background"
            outline_background.AnchorPoint = Vector2.new(0.5, 0.5)
            outline_background.BackgroundColor3 = library.menu_colors.background
            outline_background.BackgroundTransparency = 0
            outline_background.Position = UDim2.new(0.5, 0, 0.5, 0)
            outline_background.BorderColor3 = Color3.fromRGB(0, 0, 0)
            outline_background.BorderSizePixel = 2
            outline_background.Size = UDim2.new(1, -10, 1, -10)
            outline_background.ZIndex = 1
            outline_background.Parent = background
    
            ui_stroke_bg2.Name = library:random_string(10)
            ui_stroke_bg2.Color = Color3.fromRGB(35, 35, 35)
            ui_stroke_bg2.LineJoinMode = Enum.LineJoinMode.Miter
            ui_stroke_bg2.Thickness = 1
            ui_stroke_bg2.Parent = outline_background
    
            inline_background.Name = "Inline_Background"
            inline_background.AnchorPoint = Vector2.new(0.5, 0.5)
            inline_background.BackgroundTransparency = 0
            inline_background.BackgroundColor3 = library.menu_colors.main
            inline_background.Position = UDim2.new(0.5, 0, 0.5, 7)
            inline_background.BorderColor3 = Color3.fromRGB(0, 0, 0)
            inline_background.BorderSizePixel = 2
            inline_background.Size = UDim2.new(1, -12, 1, -25) 
            inline_background.ZIndex = 1
            inline_background.Parent = outline_background   
    
            ui_stroke_bg3.Name = library:random_string(10)
            ui_stroke_bg3.Color = Color3.fromRGB(35, 35, 35)
            ui_stroke_bg3.LineJoinMode = Enum.LineJoinMode.Miter
            ui_stroke_bg3.Thickness = 1
            ui_stroke_bg3.Parent = inline_background
    
            page_inline.Name = library:random_string(10)
            page_inline.BackgroundColor3 = library.menu_colors.main
            page_inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            page_inline.BorderSizePixel = 0
            page_inline.BackgroundTransparency = 1
            page_inline.Position = UDim2.new(0, 5, 0, 50)
            page_inline.Size = UDim2.new(1, -10, 1, -55)
            page_inline.Parent = inline_background
    
            title.Name = "Window_Name"
            title.FontFace = library.font
            title.Text = window.name
            title.RichText = true
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = library.font_size
            title.TextStrokeTransparency = 0
            title.BackgroundTransparency = 1
            title.AnchorPoint = Vector2.new(0.5, 0)
            title.BorderSizePixel = 0
            if options.position == "left" then
                title.Position = UDim2.new(0, 307, 0, 7)
                title.Size = UDim2.new(0, 590, 0, 15)
                title.TextXAlignment = window.position
            elseif options.position == "center" then
                title.Position = UDim2.new(0.5, 0, 0, 7)
                title.Size = UDim2.new(0, 590, 0, 15)
                title.TextXAlignment = window.position
            elseif options.position == "right" then
                title.Position = UDim2.new(0, 446, 0, 7)
                title.Size = UDim2.new(0, 590, 0, 15)
                title.TextXAlignment = window.position
            end
            title.Parent = background
            title.ZIndex = 1
    
            tabs.Name = library:random_string(10)
            tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            tabs.BackgroundTransparency = 1
            tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
            tabs.BorderSizePixel = 0
            tabs.Position = UDim2.new(0, 0, 0, 0)
            tabs.Size = UDim2.new(1, 0, 0, 45)
            tabs.ZIndex = 2
            tabs.Parent = inline_background
    
            tabs_layout.Name = library:random_string(10)
            tabs_layout.Padding = UDim.new(0, 1)  
            tabs_layout.FillDirection = Enum.FillDirection.Horizontal
            tabs_layout.SortOrder = Enum.SortOrder.LayoutOrder
            tabs_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
            tabs_layout.Parent = tabs
        end
    
        -- elements
        window.elements = {
            tab_holder = tabs,
            holder = page_inline,
            base = background,
        };
        
        library:connection(enviroment.user_input_service.InputBegan, function(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == library.ui_key then
                library.open = not library.open
                library.screen_gui.Enabled = library.open
            end
        end)
        
        library:connection(background.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                window.dragging[1], window.dragging[2] = true, enviroment.user_input_service:GetMouseLocation()
            end
        end)
        
        library:connection(enviroment.user_input_service.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                window.dragging[1] = false
            end
        end)
        
        library:connection(enviroment.user_input_service.InputChanged, function(input)
            if window.dragging[1] and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse_pos = enviroment.user_input_service:GetMouseLocation()
    
                local x_pos = math.clamp(background.Position.X.Offset + (mouse_pos.X - window.dragging[2].X), -camera.ViewportSize.X / 2 + background.AbsoluteSize.X / 2, camera.ViewportSize.X / 2 - background.AbsoluteSize.X / 2)
                local y_pos = math.clamp(background.Position.Y.Offset + (mouse_pos.Y - window.dragging[2].Y), -camera.ViewportSize.Y / 2 + background.AbsoluteSize.Y / 2, camera.ViewportSize.Y / 2 - background.AbsoluteSize.Y / 2)
    
                background.Position = UDim2.new(background.Position.X.Scale, x_pos, background.Position.Y.Scale, y_pos)
                window.dragging[2] = mouse_pos
            end
        end) 
    
        function window:update_tabs()
            for _, page in pairs(window.pages) do
                page:Turn(page.open)
            end
        end
    
        library.holder = background
        library.page_amount = window.page_amount;
        return setmetatable(window, library)
    end
    --
    function library:page(properties)
        if not properties then properties = {} end
        --
        local page = {
            name = properties.Name or properties.name or "Page",
            window = self,
            open = false,
            sections = {},
            pages = {},
            elements = {},
            weapons = {},
            icons = properties.Weapons or properties.weapons or false,
        };
        --
        local tab_button = Instance.new("TextButton")
        local button_outline = library:create("Frame")
        local button_stroke = Instance.new("UIStroke")
        local new_page = Instance.new("Frame")
        local ui_list_layout_left = Instance.new("UIListLayout")
        local ui_list_layout_center = Instance.new("UIListLayout")
        local ui_list_layout_right = Instance.new("UIListLayout")
        local right = Instance.new("Frame")
        local left = Instance.new("Frame")
        local center = Instance.new("Frame")
    
        do -- properties
            tab_button.Name = "Tab"
            tab_button.FontFace = library.font
            tab_button.TextSize = library.font_size
            tab_button.Text = page.name
            tab_button.TextColor3 = Color3.fromRGB(150, 150, 150)
            tab_button.TextStrokeTransparency = 0
            tab_button.TextSize = library.font_size
            tab_button.AutoButtonColor = false
            tab_button.BackgroundColor3 = library.menu_colors.background
            tab_button.BackgroundTransparency = 0
            tab_button.BorderSizePixel = 0
            tab_button.Parent = page.window.elements.tab_holder    
            tab_button.FontFace = library.font
            tab_button.TextSize = library.font_size
    
            button_outline.Name = library:random_string(10)
            button_outline.BackgroundTransparency = 1
            button_outline.Position = UDim2.new(0, 0, 0, 0)
            button_outline.Size = UDim2.new(1, 0, 1, 0) 
            button_outline.BorderSizePixel = 0
            button_outline.Parent = tab_button
        
            button_stroke.Name = library:random_string(10)
            button_stroke.Color = library.menu_colors.outline
            button_stroke.LineJoinMode = Enum.LineJoinMode.Miter
            button_stroke.Thickness = 1
            button_stroke.Parent = button_outline
    
            new_page.Name = library:random_string(10)
            new_page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            new_page.BackgroundTransparency = 1
            new_page.BorderColor3 = Color3.fromRGB(0, 0, 0)
            new_page.BorderSizePixel = 0
            new_page.Position = UDim2.new(0, -2, 0, 2)
            new_page.Size = UDim2.new(1, 4, 1, 0)
            new_page.Visible = false
            new_page.Parent = page.window.elements.holder
            
            left.Name = library:random_string(10)
            left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            left.BackgroundTransparency = 1
            left.BorderColor3 = Color3.fromRGB(0, 0, 0)
            left.BorderSizePixel = 0
            left.Size = UDim2.new(0.333, -4, 1, 0)
            left.ZIndex = 3
            left.Parent = new_page
    
            ui_list_layout_left.Name = "UIListLayout"
            ui_list_layout_left.Padding = UDim.new(0, 6)
            ui_list_layout_left.SortOrder = Enum.SortOrder.LayoutOrder
            ui_list_layout_left.Parent = left
    
            center.Name = library:random_string(10)
            center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            center.BackgroundTransparency = 1
            center.BorderColor3 = Color3.fromRGB(0, 0, 0)
            center.BorderSizePixel = 0
            center.Position = UDim2.new(0.333, 3, 0, 0)
            center.Size = UDim2.new(0.333, -4, 1, 0)
            center.ZIndex = 2
            center.Parent = new_page
    
            ui_list_layout_center.Name = "UIListLayout"
            ui_list_layout_center.Padding = UDim.new(0, 6)
            ui_list_layout_center.SortOrder = Enum.SortOrder.LayoutOrder
            ui_list_layout_center.Parent = center
    
            right.Name = library:random_string(10)
            right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            right.BackgroundTransparency = 1
            right.BorderColor3 = Color3.fromRGB(0, 0, 0)
            right.BorderSizePixel = 0
            right.Position = UDim2.new(0.666000009, 6, 0, 0)
            right.Size = UDim2.new(0.333, -4, 1, 0)
            right.ZIndex = 1
            right.Parent = new_page
    
            ui_list_layout_right.Name = "UIListLayout"
            ui_list_layout_right.Padding = UDim.new(0, 6)
            ui_list_layout_right.SortOrder = Enum.SortOrder.LayoutOrder
            ui_list_layout_right.Parent = right
        end
    
        do -- page fixer
            local pages = {};
            for _, v in pairs(page.window.elements.tab_holder:GetChildren()) do
                if v:IsA("GuiObject") and not v:IsA("UIListLayout") and not v:IsA("UIGridLayout") then
                    table.insert(pages, v);
                end
            end
            local page_amm = #pages;
            if page_amm > 0 then
                for i, child in ipairs(pages) do
                    if i == 1 then
                        child.Size = UDim2.new(1 / page_amm, 0, 1, 0);
                    else
                        child.Size = UDim2.new(1 / page_amm, -1, 1, 0);
                    end
                end
            end        
        end    
    
        function page:Turn(bool)
            page.open = bool
            new_page.Visible = bool
            tab_button.BackgroundColor3 = bool and library.menu_colors.main or library.menu_colors.background
            tab_button.TextColor3 = bool and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(125, 125, 125)
            button_stroke.Thickness = bool and 0 or 1
        end
        
        library:connection(tab_button.MouseButton1Down, function()
            if not page.open then
                for _, v in pairs(page.window.pages) do
                    if v.open and v ~= page then
                        v:Turn(false);
                    end
                end
                page:Turn(true);
            end
        end)
    
        -- elements
        page.elements = {
            left = left,
            center = center,
            right = right,
            button = tab_button,
            main = new_page,
        };
        
        if #page.window.pages == 0 then
            page:Turn(true)
        end
        page.window.pages[#page.window.pages + 1] = page
        library.pages[#library.pages + 1] = page
        page.window:update_tabs()
        return setmetatable(page, library.pages)
    end
    --
    function pages:section(properties)
        if not properties then properties = {} end
        --
        local section = {
            name = properties.name or properties.Name or "Section",
            page = self,
            side = (properties.side),
            elements = {},
            content = {},
            sections = {},
        };
    
        local section_outline = Instance.new("Frame")
        local section_inline = Instance.new("Frame")
        local title = Instance.new("TextLabel")
        local section_content = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
    
        do -- properties
            section_outline.Name = "SectionOutline"
            section_outline.AutomaticSize = Enum.AutomaticSize.Y
            section_outline.BackgroundColor3 = library.menu_colors.main
            section_outline.BorderSizePixel = 1
            section_outline.BorderColor3 = library.menu_colors.outline
            section_outline.Size = UDim2.new(1, 0, 0, 20)
            section_outline.Parent = (section.side == "left" and section.page.elements.left) or (section.side == "center" and section.page.elements.center) or (section.side == "right" and section.page.elements.right)
            section_outline.ZIndex = 10 - #section.page.sections
    
            title.Name = "Title"
            title.FontFace = library.font
            title.Text = section.name
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = library.font_size
            title.TextStrokeTransparency = 0
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.BackgroundTransparency = 1
            title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            title.BorderSizePixel = 0
            title.Position = UDim2.new(0, 5, 0, -10)
            title.Size = UDim2.new(0, 200, 0, 20)
            title.Parent = section_outline
    
            section_content.Name = "SectionContent"
            section_content.AutomaticSize = Enum.AutomaticSize.Y
            section_content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            section_content.BackgroundTransparency = 1
            section_content.BorderColor3 = Color3.fromRGB(0, 0, 0)
            section_content.BorderSizePixel = 0
            section_content.Position = UDim2.new(0, 4, 0, 12)
            section_content.Size = UDim2.new(1, -8, 0, 0)
            section_content.Parent = section_outline
    
            UIListLayout.Name = "UIListLayout"
            UIListLayout.Padding = UDim.new(0, 10)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = section_content
    
            UIPadding.Name = "UIPadding"
            UIPadding.PaddingBottom = UDim.new(0, 6)
            UIPadding.Parent = section_content
        end    
    
        section.elements = {
            section_content = section_content;
        }
    
        section.page.sections[#section.page.sections + 1] = section
        return setmetatable(section, library.sections)
    end
    --
end
