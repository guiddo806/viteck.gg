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
    if not isfolder("viteck.pel/") then
		makefolder("viteck.pel/");
	end
    --
	if not isfolder("viteck.pel/configs/") then
		makefolder("viteck.pel/configs/");
	end
	--
	if not isfolder("viteck.pel/lua/") then
		makefolder("viteck.pel/lua/");
	end
end
--
loadstring([[ 
    if not LPH_OBFUSCATED then
        function LPH_NO_VIRTUALIZE(f) return f end
        function LPH_JIT(...) return ... end
        function LPH_JIT_MAX(...) return ... end
        function LPH_NO_UPVALUES(f) return (function(...) return f(...) end) end
        function LPH_ENCSTR(...) return ... end
        function LPH_ENCNUM(...) return ... end
        function LPH_CRASH() return print(debug.traceback()) end
    end
]])();
--
local viteck_pel = {
    target = {
		entry = nil, 
		part = nil, 
		distance = math.huge 
	},
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
local fps            = enviroment.stats.Workspace["Heartbeat"];
local ping           = enviroment.stats.Network.ServerStatsItem["Data Ping"];
local sky            = enviroment.lighting:FindFirstChildOfClass("Sky") or cloneref(Instance.new("Sky", enviroment.lighting));
local pid_name       = enviroment.MarketplaceService:GetProductInfo(game.PlaceId).Name
local game_id        = game.GameId
local end_time       = os.clock();

do -- fonts
    function viteck_pel.fonts.cache:Register_Font(Name, Weight, Style, Asset)
        if not isfolder("viteck.pel") then makefolder("viteck.pel") end
        local asset = "viteck.pel/" .. Asset.Id;
        local font = "viteck.pel/" .. Name .. ".font";
        if not isfile(asset) then writefile(asset, Asset.Font) end
        writefile(font, enviroment.HttpService:JSONEncode({ name = Name, faces = {{ name = "Regular", weight = Weight, style = Style, assetId = getcustomasset(asset) }} }))
        return getcustomasset(font)
    end    
    --
    viteck_pel.fonts.options = ({
        Graph_35          = Font.new(viteck_pel.fonts.cache:Register_Font("Graph_35", 200, "normal", { Id = "Graph_35.ttf", Font = crypt.base64.decode("https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/assets/fonts/graph_35") })),
        Smallest_Pixel    = Font.new(viteck_pel.fonts.cache:Register_Font("Smallest_Pixel", 200, "normal", { Id = "Smallest_Pixel.ttf", Font = crypt.base64.decode("https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/assets/fonts/smallest_pixel") })),
        Templeos          = Font.new(viteck_pel.fonts.cache:Register_Font("Templeos", 200, "normal", { Id = "Templeos.ttf", Font = crypt.base64.decode("https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/assets/fonts/templeos") }))
    });
end
--
local library = ({
    open = true,
    font_size = 6,
    font = viteck_pel.fonts.options.Graph_35,
    ui_key = Enum.KeyCode.Insert,
    keybind_list = nil;
    screen_gui = nil,
    noti_screen_gui = nil,
    watermark_screen_gui = nil,
    keybind_screen_gui = nil,
    holder = nil,
    --
    menu_colors = {
        background = Color3.fromRGB(13, 13, 13),
        accent = Color3.fromRGB(10, 10, 10),
        inline_accent = Color3.fromRGB(255, 48, 93),
        shadow_accent = Color3.fromRGB(0, 0, 0),
    };
    --
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
    --
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
            --
            for class, property in pairs(properties) do
                if obj:IsA(class) then
                    obj[property] = library.menu_colors.inline_accent
                end
            end
            --
            if obj:IsA("ScrollingFrame") then
                obj.ScrollBarImageColor3 = library.menu_colors.inline_accent
            end
        end
        --
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
                elseif typeof(Value2) == "table" and Value.Mode then
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
    function library:notification(message, duration, color, player)
        local notification = {
            Container = nil, Objects = {}
        };
    
        local notif_ui = cloneref(Instance.new("ScreenGui", gethui()))
        local notifcontainer = Instance.new('Frame', notif_ui)
        local outline = Instance.new("Frame")
        local inline = Instance.new("Frame")
        local value = library:create("TextLabel", true)
        local uipadding = Instance.new("UIPadding")
        local time_line = Instance.new("Frame")
        local base_position = Vector2.new(25, 65) -- fixed X, starting Y position for notifications
        local player_image = Instance.new("ImageLabel")
    
        do -- properties
            notif_ui.Name = "notification"
            notif_ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            notif_ui.IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets
            notif_ui.IgnoreGuiInset = true
            library.noti_screen_gui = notif_ui
    
            notifcontainer.Name = library:random_string(10)
            notifcontainer.Position = UDim2.new(0, base_position.X, 0, base_position.Y + (#library.notifications * 25))
            notifcontainer.AutomaticSize = Enum.AutomaticSize.X
            notifcontainer.Size = UDim2.new(0, 0, 0, 18)
            notifcontainer.BackgroundColor3 = Color3.new(1, 1, 1)
            notifcontainer.BackgroundTransparency = 1
            notifcontainer.BorderSizePixel = 0
            notifcontainer.BorderColor3 = Color3.new(0, 0, 0)
            notifcontainer.ZIndex = 99999999
            notification.Container = notifcontainer
    
            outline.Name = library:random_string(10)
            outline.AutomaticSize = Enum.AutomaticSize.X
            outline.BackgroundColor3 = library.menu_colors.background
            outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            outline.Position = UDim2.new(0.01, 0, 0.02, 0)
            outline.Size = UDim2.new(0, 0, 0, 18)
            outline.Parent = notifcontainer
            outline.BackgroundTransparency = 1
            table.insert(notification.Objects, outline)
    
            inline.Name = library:random_string(10)
            inline.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            inline.BorderSizePixel = 0
            inline.Position = UDim2.new(0, 1, 0, 0)
            inline.Size = UDim2.new(1, 0, 1, -1)
            inline.BackgroundTransparency = 1
            inline.Parent = outline
            table.insert(notification.Objects, inline)
    
            if player then
                local imagedata = enviroment.players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                player_image.Image = imagedata
                player_image.Size = UDim2.new(0, 14, 0, 14)
                player_image.Position = UDim2.new(0, 4, 0.8, -13)
                player_image.BackgroundTransparency = 1
                player_image.Parent = inline
                value.Position = UDim2.new(0, 20, 0, 0)
                table.insert(notification.Objects, player_image)
            end
    
            value.Name = library:random_string(10)
            value.Text = message
            value.TextColor3 = Color3.fromRGB(255, 255, 255)
            value.TextStrokeTransparency = 0
            value.TextXAlignment = Enum.TextXAlignment.Left
            value.AutomaticSize = Enum.AutomaticSize.X
            value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            value.BackgroundTransparency = 1
            value.Size = UDim2.new(0, 0, 1, 0)
            value.TextTransparency = 1
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
            time_line.BackgroundColor3 = color or library.menu_colors.accent
            time_line.BorderColor3 = Color3.fromRGB(0, 0, 0)
            time_line.BorderSizePixel = 0
            time_line.Size = UDim2.new(0, 0, 1, 0) -- start at 0 size
            time_line.Parent = outline
            time_line.BackgroundTransparency = 1
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
                table.remove(library.notifications, table.find(library.notifications, notification))
                notif_ui:Destroy()
                notification.Container:Destroy()
    
                for i = index, #library.notifications do
                    local notif = library.notifications[i]
                    local newPosition = UDim2.new(0, base_position.X, 0, base_position.Y + (i - 1) * 25)
                    enviroment.tween_service:Create(notif.Container, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPosition}):Play()
                end
            end
        end
    
        task.spawn(function()
            outline.AnchorPoint = Vector2.new(1, 0)
            for _, v in next, notification.Objects do
                if v:IsA("Frame") then
                    enviroment.tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                elseif v:IsA("ImageLabel") then
                    enviroment.tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                end
            end
            enviroment.tween_service:Create(outline, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(0, 0)}):Play()
            enviroment.tween_service:Create(value, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            enviroment.tween_service:Create(player_image, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
            enviroment.tween_service:Create(time_line, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
            task.wait(duration)
            notification:remove()
        end)
    
        table.insert(library.notifications, notification)
        notifcontainer.Position = UDim2.new(0, base_position.X, 0, base_position.Y + (#library.notifications - 1) * 25)
    
        return notification
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
            Outline.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Outline.BorderColor3 = Color3.fromRGB(35, 35, 35)
            Outline.Position = UDim2.new(0.5, 0, 0.02, 0)
            Outline.BorderSizePixel = 2
            Outline.AnchorPoint = Vector2.new(0.5, 0) 
            Outline.Size = UDim2.new(0, 0, 0, 16)
            Outline.Visible = false
            Outline.Parent = watermark_ui

            TopLine.Name = library:random_string(10)
            TopLine.AutomaticSize = Enum.AutomaticSize.X
            TopLine.BackgroundColor3 = Color3.fromRGB(35,35,35)
            TopLine.Position = UDim2.new(0.5, 0, 0, 0)  
            TopLine.BorderSizePixel = 0
            TopLine.ZIndex = 99
            TopLine.AnchorPoint = Vector2.new(0.5, 0) 
            TopLine.Size = UDim2.new(1, 0, 0, 1) 
            TopLine.Parent = Outline
            
            watermark_stroke.Name = library:random_string(10)
            watermark_stroke.Color = Color3.fromRGB(0, 0, 0)
            watermark_stroke.LineJoinMode = Enum.LineJoinMode.Miter
            watermark_stroke.Thickness = 1
            watermark_stroke.Parent = Outline
    
            Inline.Name = library:random_string(10)
            Inline.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.Parent = Outline
    
            Value.FontFace = library.font
            Value.TextSize = library.font_size
            Value.Name = library:random_string(10)
            Value.Text = watermark.name
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.RichText = true;
            Value.TextStrokeTransparency = 0
            Value.TextXAlignment = Enum.TextXAlignment.Left
            Value.AutomaticSize = Enum.AutomaticSize.X
            Value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.RichText = true
            Value.Size = UDim2.new(0, 0, 1, 0)
            Value.Parent = Inline
    
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
        
        function watermark:SetVisible(State)
            Outline.Visible = State;
        end
    
        return watermark;
    end
    -- 
    function library:NewPicker(name, default, defaultalpha, parent, count, flag, callback)
        local Icon = Instance.new("TextButton", parent)
        local Outline4 = Instance.new("Frame")
        local ColorWindow = Instance.new("Frame")
        local ColorInline = Instance.new("Frame")
        local Color = library:create("TextButton")
        local text_color = Instance.new("TextButton")
        local text_color_outline = Instance.new("Frame")
        local text_color_stroke = Instance.new("UIStroke")
        local Sat = Instance.new("ImageLabel")
        local Val = Instance.new("ImageLabel")
        local Outline = Instance.new("Frame")
        local UIStroke = Instance.new("UIStroke")
        local Alpha = Instance.new("ImageButton")
        local Outline1 = Instance.new("Frame")
        local UIStroke1 = Instance.new("UIStroke")
        local UIStroke2 = Instance.new("UIStroke")
        local UIGradient = Instance.new("UIGradient")
        local Hue = Instance.new("ImageButton")
        local Outline2 = Instance.new("Frame")
        local UIStroke3 = Instance.new("UIStroke")

        do -- properties
            Icon.Name = "Icon_Colorpicker"
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.BackgroundColor3 = default
            Icon.BorderColor3 = Color3.fromRGB(36, 36, 36)
            Icon.BorderSizePixel = 1
            if count == 1 then
                Icon.Position = UDim2.new(1, - (count * 18), 0.5, 0)
            else
                Icon.Position = UDim2.new(1, - (count * 16) - (count * 2), 0.5, 0)
            end
            Icon.Size = UDim2.new(0, 15, 0, 10)
            Icon.Text = ""
            Icon.ZIndex = 99
            Icon.AutoButtonColor = false
            
            Outline4.Name = "Outline"
            Outline4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Outline4.BackgroundTransparency = 1
            Outline4.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline4.BorderSizePixel = 0
            Outline4.Position = UDim2.new(0, -1, 0, -1)
            Outline4.Size = UDim2.new(1, 2, 1, 2)
            Outline4.ZIndex = 99
            Outline4.Parent = Icon
        
            UIStroke.Name = "UIStroke"
            UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke.Parent = Outline4
        
            ColorWindow.Name = "ColorWindow"
            ColorWindow.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorWindow.BackgroundColor3 = Color3.fromRGB(36,36,36)
            ColorWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorWindow.Parent = Icon
            ColorWindow.Position = UDim2.new(1, 0, 1, 2)
            ColorWindow.AnchorPoint = Vector2.new(1,0)
            ColorWindow.Size = UDim2.new(0, 195, 0, 170)
            ColorWindow.ZIndex = 99
            ColorWindow.Visible = false
        
            ColorInline.Name = "ColorInline"
            ColorInline.BackgroundColor3 = Color3.fromRGB(15,15,15)
            ColorInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorInline.BorderSizePixel = 0
            ColorInline.Position = UDim2.new(0, 1, 0, 1)
            ColorInline.Size = UDim2.new(1, -2, 1, -2)

            text_color.Name = "Text Color"
            text_color.FontFace = library.font
            text_color.Parent = ColorInline
            text_color.TextStrokeTransparency = 0
            text_color.TextSize = library.font_size
            text_color.AutoButtonColor = false
            text_color.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
            text_color.BorderColor3 = Color3.fromRGB(35, 35, 35)
            text_color.Position = UDim2.new(0, 5, 1, -17)
            text_color.Size = UDim2.new(0, 183, 0, 12)

            text_color_outline.Name = "Outline"
            text_color_outline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            text_color_outline.BackgroundTransparency = 1
            text_color_outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            text_color_outline.BorderSizePixel = 0
            text_color_outline.Position = UDim2.new(0, -1, 0, -1)
            text_color_outline.Size = UDim2.new(1, 2, 1, 2)
            text_color_outline.ZIndex = 99
            text_color_outline.Parent = text_color

            text_color_stroke.Name = "UIStroke"
            text_color_stroke.Color = Color3.fromRGB(0, 0, 0)
            text_color_stroke.LineJoinMode = Enum.LineJoinMode.Miter
            text_color_stroke.Parent = text_color_outline

            Color.Name = "Color"
            Color.FontFace = library.font
            Color.Text = ""
            Color.TextColor3 = Color3.fromRGB(0, 0, 0)
            Color.TextSize = library.font_size
            Color.AutoButtonColor = false
            Color.BackgroundColor3 = default
            Color.BorderColor3 = Color3.fromRGB(17,17,17)
            Color.Position = UDim2.new(0, 6, 0, 6)
            Color.Size = UDim2.new(0, 145, 1, -30)
        
            Sat.Name = "Sat"
            Sat.Image = "http://www.roblox.com/asset/?id=14684562507"
            Sat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sat.BackgroundTransparency = 1
            Sat.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Sat.BorderSizePixel = 0
            Sat.Size = UDim2.new(1, 0, 1, 0)
            Sat.Parent = Color
        
            Val.Name = "Val"
            Val.Image = "http://www.roblox.com/asset/?id=14684563800"
            Val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Val.BackgroundTransparency = 1
            Val.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Val.BorderSizePixel = 0
            Val.Size = UDim2.new(1, 0, 1, 0)
            Val.Parent = Color
        
            Outline.Name = "Outline"
            Outline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Outline.BackgroundTransparency = 1
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.BorderSizePixel = 0
            Outline.Position = UDim2.new(0, -1, 0, -1)
            Outline.Size = UDim2.new(1, 2, 1, 2)
        
            UIStroke.Name = "UIStroke"
            UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke.Color = Color3.fromRGB(35, 35, 35)
            UIStroke.Parent = Outline
        
            Outline.Parent = Color
            Color.Parent = ColorInline
        
            Alpha.Name = "Alpha"
            Alpha.AutoButtonColor = false
            Alpha.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Alpha.BorderColor3 = Color3.fromRGB(17,17,17)
            Alpha.BorderSizePixel = 0
            Alpha.Position = UDim2.new(1, -16, 0, 6)
            Alpha.Size = UDim2.new(0, 10, 1, -30)
            Alpha.Parent = ColorInline
        
            Outline1.Name = "Outline"
            Outline1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Outline1.BackgroundTransparency = 1
            Outline1.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline1.BorderSizePixel = 0
            Outline1.Position = UDim2.new(0, -1, 0, -1)
            Outline1.Size = UDim2.new(1, 2, 1, 2)
        
            UIStroke1.Name = "UIStroke"
            UIStroke1.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke1.Parent = Outline1
            UIStroke1.Color = Color3.fromRGB(35, 35, 35)
            Outline1.Parent = Alpha
        
            UIStroke2.Name = "UIStroke"
            UIStroke2.Color = Color3.fromRGB(0,0,0)
            UIStroke2.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke2.Parent = Alpha
        
            Hue.Name = "Hue"
            Hue.Image = "http://www.roblox.com/asset/?id=14684557999"
            Hue.AutoButtonColor = false
            Hue.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Hue.BorderColor3 = Color3.fromRGB(17, 17, 17)
            Hue.Position = UDim2.new(1, -33, 0, 6)
            Hue.Size = UDim2.new(0, 10, 1, -30)
        
            Outline2.Name = "Outline"
            Outline2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Outline2.BackgroundTransparency = 1
            Outline2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline2.BorderSizePixel = 0
            Outline2.Position = UDim2.new(0, -1, 0, -1)
            Outline2.Size = UDim2.new(1, 2, 1, 2)
        
            UIStroke3.Name = "UIStroke"
            UIStroke3.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke3.Color = Color3.fromRGB(35, 35, 35)
            UIStroke3.Parent = Outline2
        
            Outline2.Parent = Hue
            Hue.Parent = ColorInline
            ColorInline.Parent = ColorWindow
        end
    
        -- // Connections
        local mouseover = false
        local hue, sat, val = default:ToHSV()
        local hsv = default:ToHSV()
        local alpha = defaultalpha
        local oldcolor = hsv
        local slidingsaturation = false
        local slidinghue = false
        local slidingalpha = false
    
        local function update()
            local real_pos = enviroment.UserInputService:GetMouseLocation()
            local mouse_position = Vector2.new(real_pos.X - 5, real_pos.Y - 30)
            local relative_palette = (mouse_position - Color.AbsolutePosition)
            local relative_hue     = (mouse_position - Hue.AbsolutePosition)
            local relative_opacity = (mouse_position - Alpha.AbsolutePosition)
            --
            if slidingsaturation then
                sat = math.clamp(1 - relative_palette.X / Color.AbsoluteSize.X, 0, 1)
                val = math.clamp(1 - relative_palette.Y / Color.AbsoluteSize.Y, 0, 1)
            elseif slidinghue then
                hue = math.clamp(relative_hue.Y / Hue.AbsoluteSize.Y, 0, 1)
            elseif slidingalpha then
                alpha = math.clamp(relative_opacity.X / Alpha.AbsoluteSize.X, 0, 1)
            end
    
            hsv = Color3.fromHSV(hue, sat, val)
            Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            Icon.BackgroundColor3 = hsv
    
            if flag then
                library.flags[flag] = library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
            end
    
            local hexValue = string.format("#%02X%02X%02X", math.floor(hsv.r * 255), math.floor(hsv.g * 255), math.floor(hsv.b * 255))
            local rgbColor = Color3.fromRGB(math.floor(hsv.r * 255), math.floor(hsv.g * 255), math.floor(hsv.b * 255))
            
            text_color.Text = hexValue
            text_color.TextColor3 = rgbColor
            
            callback(library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
        end
    
        local function set(color, a)
            if type(color) == "table" then
                a = color[4]
                color = Color3.fromHSV(color[1], color[2], color[3])
            end
            if type(color) == "string" then
                color = Color3.fromHex(color)
            end
    
            local oldcolor = hsv
            local oldalpha = alpha
    
            hue, sat, val = color:ToHSV()
            alpha = a or 1
            hsv = Color3.fromHSV(hue, sat, val)
    
            if hsv ~= oldcolor then
                Icon.BackgroundColor3 = hsv
                Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)

                local hexValue = string.format("#%02X%02X%02X", math.floor(hsv.r * 255), math.floor(hsv.g * 255), math.floor(hsv.b * 255))
                local rgbColor = Color3.fromRGB(math.floor(hsv.r * 255), math.floor(hsv.g * 255), math.floor(hsv.b * 255))
                
                text_color.Text = hexValue
                text_color.TextColor3 = rgbColor
                
                if flag then
                    library.flags[flag] = library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
                end
    
                callback(library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
            end
        end
    
        flags[flag] = set
        set(default, defaultalpha)
    
        Sat.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slidingsaturation = true
                update()
            end
        end)
    
        Sat.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slidingsaturation = false
                update()
            end
        end)
    
        Hue.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slidinghue = true
                update()
            end
        end)
    
        Hue.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slidinghue = false
                update()
            end
        end)
    
        Alpha.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slidingalpha = true
                update()
            end
        end)
    
        Alpha.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slidingalpha = false
                update()
            end
        end)
    
        library:connection(enviroment.UserInputService.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if slidingalpha then
                    update()
                end
    
                if slidinghue then
                    update()
                end
    
                if slidingsaturation then
                    update()
                end
            end
        end)
    
        local colorpickertypes = {}
    
        function colorpickertypes:Set(color, newalpha)
            set(color, newalpha)
        end
    
        library:connection(enviroment.UserInputService.InputBegan, function(Input)
            if ColorWindow.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not library:IsMouseOverFrame(ColorWindow) and not library:IsMouseOverFrame(Icon) and not library:IsMouseOverFrame(parent) then
                    ColorWindow.Visible = false
                    parent.ZIndex = 1
                end
            end
        end)
    
        Icon.MouseButton1Down:Connect(function()
            ColorWindow.Visible = true
            parent.ZIndex = 5
    
            if slidinghue then
                slidinghue = false
            end
    
            if slidingsaturation then
                slidingsaturation = false
            end
    
            if slidingalpha then
                slidingalpha = false
            end
        end)
    
        return colorpickertypes, ColorWindow
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
        --local cursor = library:create("ImageLabel", true)
        --local background_glow = library:create("ImageLabel", true)
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
            background.Size = UDim2.new(0, 615, 0, 500)
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
            inline_background.BackgroundColor3 = library.menu_colors.background
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
            page_inline.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
            if options.position == "center" then
                title.Position = UDim2.new(0.5, 0, 0, 8)
                title.Size = UDim2.new(0, 590, 0, 15)
                title.TextXAlignment = Enum.TextXAlignment.Center
            else
                title.Position = UDim2.new(0, 307, 0, 7)
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
    
        -- library:resize(resize, background)

        function window:keybind_list() 
            local NKeyList = {Keybinds = {}};
            library.keybind_list = NKeyList;
            
            local keybind = cloneref(Instance.new("ScreenGui", gethui()))
            local Background = Instance.new("Frame")
            local Name = library:create("TextLabel", true)
            local Tab = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")

            keybind.Name = "Keybinds List"
            keybind.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            keybind.IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets
            library.keybind_screen_gui = keybind
            
            Background.Name = "Background"
            Background.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
            Background.BorderColor3 = Color3.fromRGB(25, 25, 25)
            Background.Position = UDim2.new(0.01, 0, 0.488, 0)
            Background.Size = UDim2.new(0, 164, 0, 24)
            Background.Visible = false
            Background.AutomaticSize = Enum.AutomaticSize.XY
            Background.Parent = keybind
    
            Name.Name = "Name"
            Name.Parent = Background
            Name.BackgroundTransparency = 0
            Name.BackgroundColor3 = library.menu_colors.inline_accent
            Name.BorderColor3 = Color3.fromRGB(25, 25, 25)
            Name.BorderSizePixel = 0
            Name.Size = UDim2.new(1, 0, 0, 22)
            Name.FontFace = library.font
            Name.Text = "Keybinds List"
            Name.TextStrokeTransparency = 0
            Name.TextColor3 = Color3.fromRGB(255, 255, 255)
            Name.TextSize = library.font_size
            Name.RichText = true
    
            Tab.Name = "Tab"
            Tab.Visible = true 
            Tab.Parent = Background
            Tab.BackgroundColor3 = library.menu_colors.background
            Tab.BackgroundTransparency = 1.000
            Tab.BorderColor3 = Color3.fromRGB(25, 25, 25)
            Tab.Position = UDim2.new(0, 0, 0, 25)
            Tab.Size = UDim2.new(1, 0, 0, -20)
            Tab.AutomaticSize = Enum.AutomaticSize.Y
    
            UIListLayout.Parent = Tab
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
    
            -- Functions
            function NKeyList:SetVisible(State)
                Background.Visible = State;
            end;
            
            function NKeyList:NewKey(Key, Name)
                local KName = library:create("TextLabel", true)
                local KeyValue = {}
                
                KName.Name = "Name"
                KName.Parent = Tab
                KName.AnchorPoint = Vector2.new(0.5, 0.5)
                KName.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
                KName.BackgroundTransparency = 1
                KName.BorderColor3 = Color3.fromRGB(25, 25, 25)
                KName.BorderSizePixel = 0
                KName.Position = UDim2.new(0.5, 0, -1.85000002, 0)
                KName.Size = UDim2.new(0, 0, 0, 0)
                KName.FontFace = library.font
                KName.TextColor3 = Color3.fromRGB(200, 200, 200)
                KName.TextSize = library.font_size
                KName.AutomaticSize = Enum.AutomaticSize.XY
                
                function KeyValue:SetVisible(State)
                    KName.Visible = State;
                end;
                
                function KeyValue:Update(NKey, NewName)
                    KName.Text = string.format("[%s]: %s", tostring(NKey), NewName)
                end                                                  
                return KeyValue
            end;
            return NKeyList
        end
        window:keybind_list()
    
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
            tab_button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
            button_stroke.Color = Color3.fromRGB(35, 35, 35)
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
            right.Position = UDim2.new(0.5, 4, 0, 0)
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
    
            local tweens = {}
            for _, v in pairs(library.screen_gui:GetDescendants()) do
                if table.find({"Tab", "SectionOutline", "SectionInline", "Toggle_Outline", "Toggle_Inline", "Keybind_Outline", "Keybind_Inline", "Slider_Accent", "Slider_Outline", "Slider_Inline", "Toggle_Accent", "Button_Outline", "Button_Inline", "List_ContentOutline", "List_ContentInline", "List_Outline", "List_Inline", "ModeBox", "Icon_Line", "ContentOutline", "ContentInline", "Textbox_Outline", "Textbox_Inline", "Icon_Colorpicker"}, v.Name) then
                    if bool then v.BackgroundTransparency = 1 end
                    table.insert(tweens, enviroment.tween_service:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { BackgroundTransparency = bool and 0 or 1 }))
                end
    
                if v:IsA("TextLabel") and v.Name ~= "Window_Name" then
                    if bool then v.TextTransparency = 1 end
                    table.insert(tweens, enviroment.tween_service:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { TextTransparency = bool and 0 or 1 }))
                end        
            end
            
            for _, tween in ipairs(tweens) do 
                tween:Play() 
            end        
        
            enviroment.tween_service:Create(tab_button, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                BackgroundColor3 = bool and library.menu_colors.background or Color3.fromRGB(20, 20, 20),
                TextColor3 = bool and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(125, 125, 125),
            }):Play()
        
            enviroment.tween_service:Create(button_stroke, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Thickness = bool and 0 or 1,
            }):Play()
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
            section_outline.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            section_outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            section_outline.Size = UDim2.new(1, 0, 0, 20)
            section_outline.Parent = (section.side == "left" and section.page.elements.left) or (section.side == "center" and section.page.elements.center) or (section.side == "right" and section.page.elements.right)
            section_outline.ZIndex = 10 - #section.page.sections
    
            section_inline.Name = "SectionInline"
            section_inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
            section_inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            section_inline.BorderSizePixel = 0
            section_inline.Position = UDim2.new(0, 1, 0, 1)
            section_inline.Size = UDim2.new(1, -2, 1, -2)
            section_inline.Parent = section_outline
    
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
            title.Parent = section_inline
    
            section_content.Name = "SectionContent"
            section_content.AutomaticSize = Enum.AutomaticSize.Y
            section_content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            section_content.BackgroundTransparency = 1
            section_content.BorderColor3 = Color3.fromRGB(0, 0, 0)
            section_content.BorderSizePixel = 0
            section_content.Position = UDim2.new(0, 4, 0, 12)
            section_content.Size = UDim2.new(1, -8, 0, 0)
            section_content.Parent = section_inline
    
            UIListLayout.Name = "UIListLayout"
            UIListLayout.Padding = UDim.new(0, 10)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = section_content
    
            UIPadding.Name = "UIPadding"
            UIPadding.PaddingBottom = UDim.new(0, 6)
            UIPadding.Parent = section_content
        end    
    
        -- // Elements
        section.elements = {
            section_content = section_content;
        }
    
        -- // Returning
        section.page.sections[#section.page.sections + 1] = section
        return setmetatable(section, library.sections)
    end
    --
    function sections:toggle(properties)
        if not properties then properties = {} end
        --
        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Risk = properties.Risk or properties.Risky or properties.risk or properties.risky or false,
            Name = properties.Name or properties.name or "Toggle",
            State = (
                properties.state or properties.State or properties.def or properties.Def or properties.default or properties.Default or false
            ),
            Callback = (
                properties.callback or properties.Callback or properties.callBack or properties.CallBack or function() end
            ),
            Flag = (
                properties.flag or properties.Flag or properties.pointer or properties.Pointer or library.NextFlag()
            ),
            Toggled = false,
            Colorpickers = 0,
        };
        --
        local NewToggle = Instance.new("TextButton")
        local Inline = Instance.new("Frame")
        local Outline = Instance.new("Frame")
        local Accent = library:create("Frame", true)
        local Title = Instance.new("TextLabel")
    
        do -- properties
            NewToggle.Name = "NewToggle"
            NewToggle.FontFace = library.font
            NewToggle.Text = ""
            NewToggle.TextColor3 = Color3.fromRGB(114, 42, 42)
            NewToggle.TextSize = library.font_size
            NewToggle.AutoButtonColor = false
            NewToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewToggle.BackgroundTransparency = 1
            NewToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewToggle.BorderSizePixel = 0
            NewToggle.Size = UDim2.new(1, 0, 0, 10)
            NewToggle.Parent = Toggle.Section.elements.section_content
        
            Outline.Name = "Toggle_Outline"
            Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.Size = UDim2.new(0, 10, 0, 10)
            Outline.Parent = NewToggle
        
            Inline.Name = "Toggle_Inline"
            Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.Parent = Outline
        
            Accent.Name = "Toggle_Accent"
            Accent.BackgroundColor3 = library.menu_colors.inline_accent
            Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Accent.BorderSizePixel = 0
            Accent.Size = UDim2.new(1, 0, 1, 0)
            Accent.Parent = Inline
            Accent.BackgroundTransparency = 1
            Accent.Visible = false
        
            Title.Name = "Title"
            Title.FontFace = library.font
            Title.TextSize = library.font_size
            Title.TextColor3 = Toggle.Risk and Color3.fromRGB(75, 0, 0) or Color3.fromRGB(125, 125, 125)
            Title.TextStrokeTransparency = 0
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.BorderSizePixel = 0
            Title.Position = UDim2.new(0, 16, 0, 0)
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.Parent = NewToggle
            Title.Text = Toggle.Name
        end
    
        -- functions
        local function set_state()
            Toggle.Toggled = not Toggle.Toggled
            library.flags[Toggle.Flag] = Toggle.Toggled
            Toggle.Callback(Toggle.Toggled)

            if Toggle.Risk then
                enviroment.tween_service:Create(Accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = Toggle.Toggled and 0 or 1}):Play()
                enviroment.tween_service:Create(Title, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = not Toggle.Toggled and Color3.fromRGB(75, 0, 0) or Color3.fromRGB(255, 0, 0)}):Play()
            else
                enviroment.tween_service:Create(Accent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = Toggle.Toggled and 0 or 1}):Play()
                enviroment.tween_service:Create(Title, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = not Toggle.Toggled and Color3.fromRGB(125, 125, 125) or Color3.fromRGB(255, 255, 255)}):Play()
            end

            if not Toggle.Toggled then
                Accent.Visible = false
            else
                Accent.Visible = true
            end
        end    
        --
        library:connection(NewToggle.MouseButton1Down, set_state)
    
        function Toggle:keybind(Properties)
            local Properties = Properties or {}
            local State, Key = false
            local Keybind = {
                Section = self,
                Name = Properties.name or Properties.Name or "Keybind",
                State = (
                    Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil
                ),
                Mode = (Properties.mode or Properties.Mode or "Toggle"),
                UseKey = (Properties.UseKey or false),
                Ignore = (Properties.ignore or Properties.Ignore or false),
                Callback = (
                    Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
                ),
                Flag = (
                    Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
                ),
                ShowInList = (Properties.ShowInList or false),
                Binding = nil,
            };
            --
            local ModeBox = Instance.new("Frame")
            local Hold = Instance.new("TextButton")
            local Toggle = Instance.new("TextButton")
            local Always = Instance.new("TextButton")
            local kOutline = Instance.new("Frame")
            local KInline = Instance.new("TextButton")
            local Value = Instance.new("TextLabel")
            local Outline4 = Instance.new("Frame")
            local ListValue;
            if not Keybind.Ignore then
                ListValue = library.keybind_list:NewKey(Keybind.State, Keybind.Name)
            end
    
            do -- properties
                kOutline.Name = "Keybind_Outline"
                kOutline.AnchorPoint = Vector2.new(0, 0.5)
                kOutline.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                kOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                kOutline.Position = UDim2.new(1, -35, 0.5, 0)
                kOutline.Size = UDim2.new(0, 35, 0, 12)
                kOutline.Parent = NewToggle
    
                KInline.Name = "Keybind_Inline"
                KInline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                KInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                KInline.BorderSizePixel = 0
                KInline.Position = UDim2.new(0, 1, 0, 1)
                KInline.Size = UDim2.new(1, -2, 1, -2)
                KInline.FontFace = library.font
                KInline.Text = ""
                KInline.TextColor3 = Color3.fromRGB(0, 0, 0)
                KInline.TextSize = library.font_size
                KInline.AutoButtonColor = false
                KInline.Parent = kOutline
    
                Value.Name = "Value"
                Value.FontFace = library.font
                Value.Text = "MB2"
                Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                Value.TextSize = library.font_size
                Value.TextStrokeTransparency = 0
                Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Value.BackgroundTransparency = 1
                Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Value.BorderSizePixel = 0
                Value.Position = UDim2.new(0, 1, 0, 0)
                Value.Size = UDim2.new(1, 0, 1, 0)
                Value.Parent = KInline
    
                ModeBox.Name = "ModeBox"
                ModeBox.Parent = kOutline
                ModeBox.AnchorPoint = Vector2.new(0,0.5)
                ModeBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                ModeBox.BorderColor3 = Color3.fromRGB(35, 35, 35)
                ModeBox.BorderSizePixel = 1
                ModeBox.Size = UDim2.new(0, 65, 0, 60)
                ModeBox.ZIndex = 99
                ModeBox.Position = UDim2.new(0,45,1.5,0)
                ModeBox.Visible = false
    
                Outline4.Name = "Outline"
                Outline4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Outline4.BackgroundTransparency = 1
                Outline4.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Outline4.BorderSizePixel = 0
                Outline4.Position = UDim2.new(0, -1, 0, 1)
                Outline4.Size = UDim2.new(1, 2, 1, 2)
                Outline4.Parent = ModeBox
    
                Hold.Name = "Hold"
                Hold.Parent = ModeBox
                Hold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Hold.BackgroundTransparency = 1.000
                Hold.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Hold.BorderSizePixel = 0
                Hold.Size = UDim2.new(1, 0, 0.333000004, 0)
                Hold.ZIndex = 2
                Hold.FontFace = library.font
                Hold.Text = "Hold"
                Hold.TextColor3 = Keybind.Mode == "Hold" and Color3.fromRGB(255,255,255) or Color3.fromRGB(145,145,145)
                Hold.TextSize = library.font_size
                Hold.TextStrokeTransparency = 0
    
                Toggle.Name = "Toggle"
                Toggle.Parent = ModeBox
                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.BackgroundTransparency = 1.000
                Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle.BorderSizePixel = 0
                Toggle.Position = UDim2.new(0, 0, 0.333000004, 0)
                Toggle.Size = UDim2.new(1, 0, 0.333000004, 0)
                Toggle.ZIndex = 2
                Toggle.FontFace = library.font
                Toggle.Text = "Toggle"
                Toggle.TextColor3 = Keybind.Mode == "Toggle" and Color3.fromRGB(255,255,255) or Color3.fromRGB(145,145,145)
                Toggle.TextSize = library.font_size
                Toggle.TextStrokeTransparency = 0
    
                Always.Name = "Always"
                Always.Parent = ModeBox
                Always.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Always.BackgroundTransparency = 1.000
                Always.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Always.BorderSizePixel = 0
                Always.Position = UDim2.new(0, 0, 0.666999996, 0)
                Always.Size = UDim2.new(1, 0, 0.333000004, 0)
                Always.ZIndex = 2
                Always.FontFace = library.font
                Always.Text = "Always"
                Always.TextColor3 = Keybind.Mode == "Always" and Color3.fromRGB(255,255,255) or Color3.fromRGB(145,145,145)
                Always.TextSize = library.font_size
                Always.TextStrokeTransparency = 0
            end
    
            -- functions
            local function set(newkey)
                if string.find(tostring(newkey), "Enum") then
                    if c then
                        c:Disconnect()
                        if Keybind.Flag then library.flags[Keybind.Flag] = false end
                        Keybind.Callback(false)
                    end
            
                    if tostring(newkey):find("Enum.KeyCode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                    end
            
                    if newkey == Enum.KeyCode.Backspace then
                        Key = nil
                        if Keybind.UseKey and Keybind.Flag then library.flags[Keybind.Flag] = Key end
                        Keybind.Callback(Key)
                        local text = "None"
                        Value.Text = text
                        ListValue:Update(text, Keybind.Name)
                        --inline_text_keybind.Visible = false
                    elseif newkey then
                        Key = newkey
                        if Keybind.UseKey and Keybind.Flag and Keybind.ShowInList then library.flags[Keybind.Flag] = Key end
                        Keybind.Callback(Key)
                        local text = library.keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", "")
                        Value.Text = text
                        ListValue:Update(text, Keybind.Name)
                        --inline_text_keybind.Visible = true
                        --inline_text_keybind.Text = tostring(newkey)
                    end
            
                    library.flags[Keybind.Flag .. "_KEY"] = newkey
                elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
                    if not Keybind.UseKey then
                        library.flags[Keybind.Flag .. "_KEY STATE"] = newkey
                        Keybind.Mode = newkey
                        ListValue:Update((library.keys[Key] or tostring(Key):gsub("Enum.KeyCode.", "")), Keybind.Name)
                        if Keybind.Mode == "Always" then
                            State = true
                            if Keybind.Flag then library.flags[Keybind.Flag] = State end
                            Keybind.Callback(true)
                            ListValue:SetVisible(true)
                        end
                    end
                else
                    State = newkey
                    if Keybind.Flag then library.flags[Keybind.Flag] = newkey end
                    Keybind.Callback(newkey)
                end
            end
            
            set(Keybind.State)
            set(Keybind.Mode)
            
            KInline.MouseButton1Click:Connect(function()
                if not Keybind.Binding then
                    Value.Text = "..."
                    Keybind.Binding = library:connection(
                        enviroment.user_input_service.InputBegan,
                        function(input, gpe)
                            set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                            library:Disconnect(Keybind.Binding)
                            task.wait()
                            Keybind.Binding = nil
                        end
                    );
                end
            end)
            
            library:connection(enviroment.user_input_service.InputBegan, function(inp)
                if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
                    if Keybind.Mode == "Hold" then
                        if Keybind.Flag then library.flags[Keybind.Flag] = true end
                        c = library:connection(enviroment.run_service.RenderStepped, LPH_NO_VIRTUALIZE(function()
                            if Keybind.Callback then Keybind.Callback(true) end
                        end))
                        ListValue:SetVisible(true)
                    elseif Keybind.Mode == "Toggle" then
                        State = not State
                        if Keybind.Flag then library.flags[Keybind.Flag] = State end
                        Keybind.Callback(State)
                        ListValue:SetVisible(State)
                    end
                end
            end)
            
            library:connection(enviroment.user_input_service.InputEnded, function(inp)
                if Keybind.Mode == "Hold" and not Keybind.UseKey then
                    if Key and (inp.KeyCode == Key or inp.UserInputType == Key) and c then
                        c:Disconnect()
                        if Keybind.Flag then library.flags[Keybind.Flag] = false end
                        if Keybind.Callback then Keybind.Callback(false) end
                        ListValue:SetVisible(false)
                    end
                end
            end)        
            --
            library:connection(KInline.MouseButton2Down, function()
                ModeBox.Visible = true
                NewToggle.ZIndex = 5
            end)
            --
            library:connection(Hold.MouseButton1Down, function()
                set("Hold")
                Hold.TextColor3 = Color3.fromRGB(255,255,255)
                Toggle.TextColor3 = Color3.fromRGB(145,145,145)
                Always.TextColor3 = Color3.fromRGB(145,145,145)
                ModeBox.Visible = false
                NewToggle.ZIndex = 1
            end)
            --
            library:connection(Toggle.MouseButton1Down, function()
                set("Toggle")
                Hold.TextColor3 = Color3.fromRGB(145,145,145)
                Toggle.TextColor3 = Color3.fromRGB(255,255,255)
                Always.TextColor3 = Color3.fromRGB(145,145,145)
                ModeBox.Visible = false
                NewToggle.ZIndex = 1
            end)
            --
            library:connection(Always.MouseButton1Down, function()
                set("Always")
                Hold.TextColor3 = Color3.fromRGB(145,145,145)
                Toggle.TextColor3 = Color3.fromRGB(145,145,145)
                Always.TextColor3 = Color3.fromRGB(255,255,255)
                ModeBox.Visible = false
                NewToggle.ZIndex = 1
            end)
            --
            library:connection(enviroment.UserInputService.InputBegan, function(Input)
                if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not library:IsMouseOverFrame(ModeBox) then
                        ModeBox.Visible = false
                        NewToggle.ZIndex = 1
                    end
                end
            end)
            --
            library.flags[Keybind.Flag .. "_KEY"] = Keybind.State
            library.flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
            flags[Keybind.Flag] = set
            flags[Keybind.Flag .. "_KEY"] = set
            flags[Keybind.Flag .. "_KEY STATE"] = set
            --
            function Keybind:Set(key)
                set(key)
            end
    
            return Keybind
        end
    
        function Toggle:Colorpicker(Properties)
            local Properties = Properties or {}
            local Colorpicker = {
                State = (
                    Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Color3.fromRGB(255, 0, 0)
                ),
                Alpha = (
                    Properties.alpha or Properties.Alpha or Properties.transparency or Properties.Transparency or 1
                ),
                Callback = (
                    Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
                ),
                Flag = (
                    Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
                ),
            }
            -- // Functions
            Toggle.Colorpickers = Toggle.Colorpickers + 1
            local colorpickertypes = library:NewPicker(
                "",
                Colorpicker.State,
                Colorpicker.Alpha,
                NewToggle,
                Toggle.Colorpickers,
                Colorpicker.Flag,
                Colorpicker.Callback
            );
        
            function Colorpicker:Set(color)
                colorpickertypes:set(color)
            end
    
            return Colorpicker
        end
    
        -- functions
        function Toggle.Set(bool)
            bool = type(bool) == "boolean" and bool or false
            if Toggle.Toggled ~= bool then
                set_state()
            end
        end
        Toggle.Set(Toggle.State)
        library.flags[Toggle.Flag] = Toggle.State
        flags[Toggle.Flag] = Toggle.Set
    
        return Toggle
    end
    --
    function sections:slider(Properties)
        if not Properties then Properties = {} end
        --
        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Name = Properties.Name or nil,
            Min = (
                Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0
            ),
            State = (
                Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or 10
            ),
            Max = (
                Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 100
            ),
            Sub = (
                Properties.suffix or Properties.Suffix or Properties.ending or Properties.Ending or Properties.prefix or Properties.Prefix or Properties.measurement or Properties.Measurement or ""
            ),
            Decimals = (
                Properties.decimals or Properties.Decimals or 1
            ),
            Callback = (
                Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
            ),
            Flag = (
                Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
            ),
            Disabled = (Properties.Disabled or Properties.disable or nil),
        }
        local TextValue = ("[value]" .. Slider.Sub) -- for slider name
        --
        local NewSlider = Instance.new("Frame")
        local Outline = Instance.new("Frame")
        local Inline = Instance.new("TextButton")
        local Accent = library:create("TextButton", true)
        local Value = Instance.new("TextLabel")
        local Title = Instance.new("TextLabel")
        
        do -- properties
            NewSlider.Name = "NewSlider"
            NewSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewSlider.BackgroundTransparency = 1
            NewSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewSlider.BorderSizePixel = 0
            NewSlider.Size = UDim2.new(1, 0, 0, Slider.Name ~= nil and 26 or 12)
            NewSlider.Parent = Slider.Section.elements.section_content
    
            Outline.Name = "Slider_Outline"
            Outline.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.Position = UDim2.new(0, 0, 1, -12)
            Outline.Size = UDim2.new(1, 0, 0, 12)
            Outline.Parent = NewSlider
    
            Inline.Name = "Slider_Inline"
            Inline.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.FontFace = library.font
            Inline.Text = ""
            Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
            Inline.TextSize = library.font_size
            Inline.AutoButtonColor = false
            Inline.Parent = Outline
    
            Accent.Name = "Slider_Accent"
            Accent.BackgroundColor3 = library.menu_colors.inline_accent
            Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Accent.BorderSizePixel = 0
            Accent.Size = UDim2.new(0, 0, 1, 0)
            Accent.Parent = Inline
            Accent.FontFace = library.font
            Accent.Text = ""
            Accent.TextColor3 = Color3.fromRGB(0, 0, 0) 
            Accent.TextSize = library.font_size
            Accent.AutoButtonColor = false
    
            Value.Name = "Value"
            Value.FontFace = library.font
            Value.Text = "0"
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = library.font_size
            Value.TextStrokeTransparency = 0
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.Parent = Inline
    
            Title.Name = "Title"
            Title.FontFace = library.font
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = library.font_size
            Title.TextStrokeTransparency = 0
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.Position = UDim2.new(0, 2, 0, 0)
            Title.BorderSizePixel = 0
            Title.Size = UDim2.new(1, 0, 0, 10)
            Title.Parent = NewSlider
            Title.Text = Slider.Name ~= nil and Slider.Name or ""
            Title.Visible = Slider.Name ~= nil and true or false
        end
    
        -- functions
        local Sliding = false
        local Val = Slider.State
        local current_tween 
        local function is_set(value)
            value = math.clamp(library:round(value, Slider.Decimals), Slider.Min, Slider.Max)
            local targetSize = UDim2.new((value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
            
            if current_tween then
                current_tween:Cancel()
            end
        
            current_tween = enviroment.tween_service:Create( Accent, TweenInfo.new(0.13, Enum.EasingStyle.Linear), {Size = targetSize} )
            current_tween:Play()
            
            Value.Text = Slider.Disabled and value == Slider.Min and Slider.Disabled or TextValue:gsub("%[value%]", string.format("%.14g", value))
            local inlineWidth = Inline.AbsoluteSize.X
            local targetPositionX = inlineWidth * targetSize.X.Scale
            local horizontalOffset = 0
            local verticalOffset = 1 

            Value.Position = UDim2.new(
                0, targetPositionX - Value.AbsoluteSize.X / 2 + horizontalOffset, 
                1, -Value.AbsoluteSize.Y / 2 + verticalOffset 
            );
            Val = value
            library.flags[Slider.Flag] = value  
            Slider.Callback(value)
        end    
        --
        local function is_sliding(input)
            is_set(((Slider.Max - Slider.Min) * ((input.Position.X - Inline.AbsolutePosition.X) / Inline.AbsoluteSize.X)) + Slider.Min)
        end
        --
        for _, obj in pairs({Inline, Accent}) do
            library:connection(obj.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    is_sliding(input)
                end
            end)
            library:connection(obj.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Sliding = false end
            end)
        end
        --
        library:connection(enviroment.user_input_service.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and Sliding then
                is_sliding(input)
            end
        end)
        --
        function Slider:Set(value) 
            is_set(value) 
        end;
        flags[Slider.Flag] = is_set
        library.flags[Slider.Flag] = Slider.State
        is_set(Slider.State)
        return Slider
    end
    -- 
    function sections:button(properties)
        local properties = properties or {}
        local button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Name = properties.Name or "button",
            Callback = (
                properties.callback or properties.Callback or properties.callBack or properties.CallBack or function() end
            ),
        };
        --
        local NewButton = Instance.new("Frame")
        local Outline = Instance.new("Frame")
        local Inline = Instance.new("TextButton")
        local Value = Instance.new("TextLabel")
    
        do -- properties
            NewButton.Name = "NewButton"
            NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewButton.BackgroundTransparency = 1
            NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewButton.BorderSizePixel = 0
            NewButton.Size = UDim2.new(1, 0, 0, 16)
            NewButton.Parent = button.Section.elements.section_content
        
            Outline.Name = "Button_Outline"
            Outline.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.Position = UDim2.new(0, 0, 1, -16)
            Outline.Size = UDim2.new(1,0, 0, 16)
            Outline.Parent = NewButton
        
            Inline.Name = "Button_Inline"
            Inline.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.FontFace = library.font
            Inline.Text = ""
            Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
            Inline.TextSize = library.font_size
            Inline.AutoButtonColor = false
            Inline.Parent = Outline
    
            Value.Name = "Value"
            Value.FontFace = library.font
            Value.Text = button.Name
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = library.font_size
            Value.TextStrokeTransparency = 0
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.Parent = Inline
        end
        --
        library:connection(Inline.MouseButton1Down, function()
            button.Callback()
            Value.TextColor3 = library.menu_colors.inline_accent
            task.wait(0.1)
            Value.TextColor3 = Color3.fromRGB(255,255,255)
        end)
        --
        function button:button(properties)
            local properties = properties or {}
            local InButton = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = properties.Name or "button",
                Callback = (
                    properties.callback or properties.Callback or properties.callBack or properties.CallBack or function() end
                ),
            }
            --
            Outline.Size = UDim2.new(0.5, -4, 0, 16)
            local iOutline = Instance.new("Frame")
            local iInline = Instance.new("TextButton")
            local iValue = Instance.new("TextLabel")
            
            do -- properties
                iOutline.Name = "Button_Outline"
                iOutline.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
                iOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                iOutline.Position = UDim2.new(0.5, 4, 1, -16)
                iOutline.Size = UDim2.new(0.5, -4, 0, 16)
                iOutline.Parent = NewButton
        
                iInline.Name = "Button_Inline"
                iInline.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                iInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                iInline.BorderSizePixel = 0
                iInline.Position = UDim2.new(0, 1, 0, 1)
                iInline.Size = UDim2.new(1, -2, 1, -2)
                iInline.FontFace = library.font
                iInline.Text = ""
                iInline.TextColor3 = Color3.fromRGB(0, 0, 0)
                iInline.TextSize = library.font_size
                iInline.AutoButtonColor = false
                iInline.Parent = iOutline
    
                iValue.Name = "Value"
                iValue.FontFace = library.font
                iValue.Text = InButton.Name
                iValue.TextColor3 = Color3.fromRGB(255, 255, 255)
                iValue.TextSize = library.font_size
                iValue.TextStrokeTransparency = 0
                iValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                iValue.BackgroundTransparency = 1
                iValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
                iValue.BorderSizePixel = 0
                iValue.Size = UDim2.new(1, 0, 1, 0)
                iValue.Parent = iInline
            end
            --
            library:connection(iInline.MouseButton1Down, function()
                InButton.Callback()
                iValue.TextColor3 = library.menu_colors.inline_accent
                task.wait(0.1)
                iValue.TextColor3 = Color3.fromRGB(255,255,255)
            end)
        end
    
        return button
    end
    -- 
    function sections:list(Properties)
        local Properties = Properties or {};
        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Open = false,
            Name = Properties.Name or Properties.name or nil,
            Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {
                "1", "2", "3",
            }),
            Max = (
                Properties.Max or Properties.max or nil
            ),
            ScrollMax = (
                Properties.ScrollingMax or Properties.scrollingmax or nil
            ),
            State = (
                Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil
            ),
            Callback = (
                Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
            ),
            Flag = (
                Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
            ),
            OptionInsts = {},
        }
        --
        local NewList = Instance.new("Frame")
        local Outline = Instance.new("Frame")
        local Inline = Instance.new("TextButton")
        local Value = Instance.new("TextLabel")
        local Icon = Instance.new("TextLabel")
        local Icon_Line = Instance.new("Frame")
        local ContentOutline = Instance.new("Frame")
        local ContentInline = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
        local Title = Instance.new("TextLabel")
    
        do -- properties
            NewList.Name = "NewList"
            NewList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewList.BackgroundTransparency = 1
            NewList.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewList.BorderSizePixel = 0
            NewList.Size = UDim2.new(1, 0, 0, Dropdown.Name ~= nil and 30 or 16)
            NewList.Parent = Dropdown.Section.elements.section_content
    
            Outline.Name = "List_Outline"
            Outline.BackgroundColor3 = Color3.fromRGB(36,36,36)
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.Position = UDim2.new(0, 0, 1, -16)
            Outline.Size = UDim2.new(1, 0, 0, 16)
            Outline.Parent = NewList
    
            Inline.Name = "List_Inline"
            Inline.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.FontFace = library.font
            Inline.Text = ""
            Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
            Inline.TextSize = library.font_size
            Inline.AutoButtonColor = false
            Inline.Parent = Outline
    
            Value.Name = "Value"
            Value.FontFace = library.font
            Value.Text = "None"
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = library.font_size
            Value.TextStrokeTransparency = 0
            Value.TextXAlignment = Enum.TextXAlignment.Left
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.Position = UDim2.new(0, 4, 0, 0)
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.Parent = Inline
    
            Icon.Name = "Icon"
            Icon.FontFace = library.font
            Icon.Text = ">"
            Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.TextSize = library.font_size
            Icon.TextStrokeTransparency = 0
            Icon.TextXAlignment = Enum.TextXAlignment.Right
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.BackgroundTransparency = 1
            Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Icon.BorderSizePixel = 0
            Icon.Position = UDim2.new(0, -4, 0, 0)
            Icon.Size = UDim2.new(1, 0, 1, 0)
            Icon.Parent = Inline
    
            Icon_Line.Name = "Icon_Line"
            Icon_Line.BorderSizePixel = 0
            Icon_Line.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Icon_Line.Size = UDim2.new(0, 1, 1, 0)
            Icon_Line.Position = UDim2.new(0, 155, 0, 0)
            Icon_Line.Parent = Inline
    
            ContentOutline.Name = "List_ContentOutline"
            ContentOutline.AutomaticSize = Enum.AutomaticSize.Y
            ContentOutline.BackgroundColor3 = Color3.fromRGB(15,15,15)
            ContentOutline.BorderColor3 = Color3.fromRGB(36, 36, 36)
            ContentOutline.Position = UDim2.new(0, 1, 1, 2)
            ContentOutline.Size = UDim2.new(1, -2, 0, 0)
            ContentOutline.Visible = false
            ContentOutline.Parent = Outline
    
            ContentInline.Name = "List_ContentInline"
            ContentInline.BackgroundColor3 = Color3.fromRGB(15,15,15)
            ContentInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ContentInline.BorderSizePixel = 0
            ContentInline.Position = UDim2.new(0, 2, 0, 1)
            ContentInline.Size = UDim2.new(1, -3, 1, 0)
            ContentInline.Parent = ContentOutline
    
            UIListLayout.Name = "UIListLayout"
            UIListLayout.Padding = UDim.new(0, 2)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = ContentInline
    
            UIPadding.Name = "UIPadding"
            UIPadding.PaddingBottom = UDim.new(0, 2)
            UIPadding.PaddingTop = UDim.new(0, 2)
            UIPadding.Parent = ContentInline
    
            Title.Name = "Title"
            Title.FontFace = library.font
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = library.font_size
            Title.TextStrokeTransparency = 0
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.BorderSizePixel = 0
            Title.Size = UDim2.new(1, 0, 0, 10)
            Title.Parent = NewList
            Title.Visible = Dropdown.Name ~= nil and true or false
            Title.Text = Dropdown.Name ~= nil and Dropdown.Name or ""
        end
    
        -- // Connections
        library:connection(Inline.MouseButton1Down, function()
            ContentOutline.Visible = not ContentOutline.Visible
            if ContentOutline.Visible then
                Icon.Text = "v"
                NewList.ZIndex = 5
            else
                Icon.Text = ">"
                NewList.ZIndex = 1
            end
        end)
        library:connection(enviroment.UserInputService.InputBegan, function(Input)
            if ContentOutline.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not library:IsMouseOverFrame(ContentOutline) and not library:IsMouseOverFrame(Inline) then
                    ContentOutline.Visible = false
                    NewList.ZIndex = 1
                    Icon.Text = ">"
                end
            end
        end)
        --
        local chosen = Dropdown.Max and {} or nil
        local Count = 0
        --
        local function handleoptionclick(option, button, text)
            button.MouseButton1Down:Connect(function()
                if Dropdown.Max then
                    if table.find(chosen, option) then
                        table.remove(chosen, table.find(chosen, option))
    
                        local textchosen = {}
                        local cutobject = false
    
                        for _, opt in next, chosen do
                            table.insert(textchosen, opt)
                        end
    
                        Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")
                        text.TextColor3 = Color3.fromRGB(145,145,145)
                        
                        library.flags[Dropdown.Flag] = chosen
                        Dropdown.Callback(chosen)
                    else
                        if #chosen == Dropdown.Max then
                            Dropdown.OptionInsts[chosen[1]].accent.Visible = false
                            table.remove(chosen, 1)
                        end
    
                        table.insert(chosen, option)
    
                        local textchosen = {}
                        local cutobject = false
    
                        for _, opt in next, chosen do
                            table.insert(textchosen, opt)
                        end
    
                        Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")
                        text.TextColor3 = Color3.fromRGB(255,255,255)
    
                        library.flags[Dropdown.Flag] = chosen
                        Dropdown.Callback(chosen)
                    end
                else
                    for opt, tbl in next, Dropdown.OptionInsts do
                        if opt ~= option then
                            tbl.text.TextColor3 = Color3.fromRGB(145,145,145)
                        end
                    end
                    chosen = option
                    Value.Text = option
                    text.TextColor3 = Color3.fromRGB(255,255,255)
                    ContentOutline.Visible = false
                    NewList.ZIndex = 1
                    Icon.Text = ">"
                    library.flags[Dropdown.Flag] = option
                    Dropdown.Callback(option)
                end
            end)
        end
        --
        local function createoptions(tbl)
            for _, option in next, tbl do
                Dropdown.OptionInsts[option] = {}
                --
                local NewOption = Instance.new("TextButton")
                NewOption.Name = "NewOption"
                NewOption.FontFace = library.font
                NewOption.Text = ""
                NewOption.TextColor3 = Color3.fromRGB(255, 255, 255)
                NewOption.TextSize = library.font_size
                NewOption.TextStrokeTransparency = 0
                NewOption.TextWrapped = true
                NewOption.TextXAlignment = Enum.TextXAlignment.Left
                NewOption.AutoButtonColor = false
                NewOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                NewOption.BackgroundTransparency = 1
                NewOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
                NewOption.BorderSizePixel = 0
                NewOption.Size = UDim2.new(1, 0, 0, 14)
                NewOption.Parent = ContentInline
    
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Name = "OptionLabel"
                OptionLabel.FontFace = library.font
                OptionLabel.Text = option
                OptionLabel.TextColor3 = Color3.fromRGB(145, 145, 145)
                OptionLabel.TextSize = library.font_size
                OptionLabel.TextStrokeTransparency = 0
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                OptionLabel.BorderSizePixel = 0
                OptionLabel.Position = UDim2.new(0, 4, 0, 0)
                OptionLabel.Size = UDim2.new(1, 0, 1, 0)
                OptionLabel.Parent = NewOption
    
                Dropdown.OptionInsts[option].text = OptionLabel
                Count = Count + 1
    
                handleoptionclick(option, NewOption, OptionLabel)
            end
        end
        createoptions(Dropdown.Options)
        --
        local set
        set = function(option)
            if Dropdown.Max then
                table.clear(chosen)
                option = type(option) == "table" and option or {}
    
                for opt, tbl in next, Dropdown.OptionInsts do
                    if not table.find(option, opt) then
                        tbl.text.TextColor3 = Color3.fromRGB(145,145,145)
                    end
                end
    
                for _, opt in next, option do
                    if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
                        table.insert(chosen, opt)
                        Dropdown.OptionInsts[opt].text.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end
    
                local textchosen = {}
                local cutobject = false
    
                for _, opt in next, chosen do
                    table.insert(textchosen, opt)
                end
    
                Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")
    
                library.flags[Dropdown.Flag] = chosen
                Dropdown.Callback(chosen)
            end
        end
        --
        function Dropdown:Set(option)
            if Dropdown.Max then
                set(option)
            else
                for opt, tbl in next, Dropdown.OptionInsts do
                    if opt ~= option then
                        tbl.text.TextColor3 = Color3.fromRGB(145,145,145)
                    end
                end
                if table.find(Dropdown.Options, option) then
                    chosen = option
                    Dropdown.OptionInsts[option].text.TextColor3 = Color3.fromRGB(255,255,255)
                    Value.Text = option
                    library.flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                else
                    chosen = nil
                    Value.Text = "None"
                    library.flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                end
            end
        end
        --
        function Dropdown:Refresh(tbl)
            for _, opt in next, Dropdown.OptionInsts do
                coroutine.wrap(function()
                    pcall(function()
                        opt.button:Destroy()
                    end)
                end)()
            end
            table.clear(Dropdown.OptionInsts)
    
            createoptions(tbl)
    
            if Dropdown.Max then
                table.clear(chosen)
            else
                chosen = nil
            end
    
            library.flags[Dropdown.Flag] = chosen
            Dropdown.Callback(chosen)
        end
    
        if Dropdown.Max then
            flags[Dropdown.Flag] = set
        else
            flags[Dropdown.Flag] = Dropdown
        end
        Dropdown:Set(Dropdown.State)
        return Dropdown
    end
    -- 
    function sections:Textbox(Properties)
        local Properties = Properties or {}
        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Name = (Properties.Name or Properties.name or nil),
            Placeholder = (
                Properties.placeholder or Properties.Placeholder or Properties.holder or Properties.Holder or ""
            ),
            State = (
                Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or ""
            ),
            Callback = (
                Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
            ),
            Flag = (
                Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
            ),
        }
        --
        local NewBox = Instance.new("TextButton")
        local Outline = Instance.new("Frame")
        local Inline = Instance.new("Frame")
        local Value = Instance.new("TextBox")
        local Title = Instance.new("TextLabel")
    
        do -- properties
            NewBox.Name = "NewBox"
            NewBox.FontFace = library.font
            NewBox.Text = ""
            NewBox.TextColor3 = Color3.fromRGB(0, 0, 0)
            NewBox.TextSize = library.font_size
            NewBox.AutoButtonColor = false
            NewBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewBox.BackgroundTransparency = 1
            NewBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewBox.BorderSizePixel = 0
            NewBox.Size = UDim2.new(1, 0, 0, Textbox.Name ~= nil and 30 or 16)
            NewBox.Parent = Textbox.Section.elements.section_content
    
            Outline.Name = "Textbox_Outline"
            Outline.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.Position = UDim2.new(0, 0, 1, -16)
            Outline.Size = UDim2.new(1, 0, 0, 16)
            Outline.Parent = NewBox
    
            Inline.Name = "Textbox_Inline"
            Inline.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.Parent = Outline
    
            Value.Name = "Value"
            Value.FontFace = library.font
            Value.Text = Textbox.State
            Value.PlaceholderText = Textbox.Placeholder
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.PlaceholderColor3 = Color3.fromRGB(145,145,145)
            Value.TextSize = library.font_size
            Value.TextStrokeTransparency = 0
            Value.TextXAlignment = Enum.TextXAlignment.Left
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.Position = UDim2.new(0, 4, 0, 0)
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.Parent = Inline
            Value.ClearTextOnFocus = false
    
            Title.Name = "Title"
            Title.FontFace = library.font
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = library.font_size
            Title.TextStrokeTransparency = 0
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.BorderSizePixel = 0
            Title.Size = UDim2.new(1, 0, 0, 10)
            Title.Parent = NewBox
            Title.Text = Textbox.Name ~= nil and Textbox.Name or ""
            Title.Visible = Textbox.Name ~= nil and true or false
        end
    
        -- // Connections
        Value.FocusLost:Connect(function()
            Textbox.Callback(Value.Text)
            library.flags[Textbox.Flag] = Value.Text
        end)
        --
        local function set(str)
            Value.Text = str
            library.flags[Textbox.Flag] = str
            Textbox.Callback(str)
        end
    
        -- // Return
        flags[Textbox.Flag] = set
        return Textbox
    end
    -- 
    function sections:ListBox(Properties)
        local Properties = Properties or {};
        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Open = false, 
            Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {
                "1", "2", "3",
            }),
            Max = (Properties.Max or Properties.max or nil),
            ScrollMax = (Properties.ScrollingMax or Properties.scrollingmax or nil),
            State = (
                Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil
            ),
            Callback = (
                Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
            ),
            Flag = (
                Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
            ),
            OptionInsts = {},
        };
        --
        local NewList = Instance.new("TextButton")
        local ContentOutline = Instance.new("Frame")
        local ContentInline = library:create("ScrollingFrame", true, true)
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
    
        do -- properties
            NewList.Name = "NewList"
            NewList.FontFace = library.font
            NewList.Text = ""
            NewList.TextColor3 = Color3.fromRGB(0, 0, 0)
            NewList.TextSize = library.font_size
            NewList.AutoButtonColor = false
            NewList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewList.BackgroundTransparency = 1
            NewList.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewList.BorderSizePixel = 0
            NewList.Size = UDim2.new(1, 0, 0, (14 * Dropdown.ScrollMax) + (2 * Dropdown.ScrollMax) + 4)
            NewList.Parent = Dropdown.Section.elements.section_content
    
            ContentOutline.Name = "ContentOutline"
            ContentOutline.AutomaticSize = Enum.AutomaticSize.Y
            ContentOutline.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            ContentOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ContentOutline.Size = UDim2.new(1, 0, 1, 0)
            ContentOutline.Parent = NewList
    
            ContentInline.Name = "ContentInline"
            ContentInline.AutomaticCanvasSize = Enum.AutomaticSize.Y
            ContentInline.BottomImage = "rbxassetid://7783554086"
            ContentInline.CanvasSize = UDim2.new()
            ContentInline.MidImage = "rbxassetid://7783554086"
            ContentInline.ScrollBarImageColor3 = library.menu_colors.inline_accent
            ContentInline.ScrollBarThickness = 4
            ContentInline.TopImage = "rbxassetid://7783554086"
            ContentInline.Active = true
            ContentInline.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            ContentInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ContentInline.BorderSizePixel = 0
            ContentInline.Position = UDim2.new(0, 1, 0, 1)
            ContentInline.Size = UDim2.new(1, -2, 1, -2)
            ContentInline.Parent = ContentOutline
    
            UIListLayout.Name = "UIListLayout"
            UIListLayout.Padding = UDim.new(0, 2)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = ContentInline
    
            UIPadding.Name = "UIPadding"
            UIPadding.PaddingBottom = UDim.new(0, 2)
            UIPadding.PaddingTop = UDim.new(0, 2)
            UIPadding.Parent = ContentInline
        end
        --
        local chosen = Dropdown.Max and {} or nil
        local Count = 0
        --
        local function handleoptionclick(option, button, text)
            button.MouseButton1Down:Connect(function()
                if Dropdown.Max then
                    if table.find(chosen, option) then
                        table.remove(chosen, table.find(chosen, option))
    
                        local textchosen = {}
                        for _, opt in next, chosen do
                            table.insert(textchosen, opt)
                        end
    
                        text.TextColor3 = Color3.fromRGB(125,125,125)
    
                        library.flags[Dropdown.Flag] = chosen
                        Dropdown.Callback(chosen)
                    else
                        if #chosen == Dropdown.Max then
                            Dropdown.OptionInsts[chosen[1]].accent.Visible = false
                            table.remove(chosen, 1)
                        end
    
                        table.insert(chosen, option)
    
                        local textchosen = {}
                        for _, opt in next, chosen do
                            table.insert(textchosen, opt)
                        end
    
                        text.TextColor3 = library.menu_colors.inline_accent
                        library.flags[Dropdown.Flag] = chosen
                        Dropdown.Callback(chosen)
                    end
                else
                    for opt, tbl in next, Dropdown.OptionInsts do
                        if opt ~= option then
                            tbl.text.TextColor3 = Color3.fromRGB(125,125,125)
                        end
                    end
                    chosen = option
                    text.TextColor3 = library.menu_colors.inline_accent
                    library.flags[Dropdown.Flag] = option
                    Dropdown.Callback(option)
                end
            end)
        end
        --
        local function createoptions(tbl)
            for _, option in next, tbl do
                Dropdown.OptionInsts[option] = {}
                --
                local NewOption = Instance.new("TextButton")
                local OptionLabel = library:create("TextLabel", true)
    
                do -- properties
                    NewOption.Name = "NewOption"
                    NewOption.FontFace = library.font
                    NewOption.Text = ""
                    NewOption.TextColor3 = library.menu_colors.inline_accent
                    NewOption.TextSize = library.font_size
                    NewOption.TextStrokeTransparency = 0
                    NewOption.TextWrapped = true
                    NewOption.TextXAlignment = Enum.TextXAlignment.Left
                    NewOption.AutoButtonColor = false
                    NewOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    NewOption.BackgroundTransparency = 1
                    NewOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    NewOption.BorderSizePixel = 0
                    NewOption.Size = UDim2.new(1, 0, 0, 14)
                    NewOption.Parent = ContentInline
        
                    OptionLabel.Name = "OptionLabel"
                    OptionLabel.FontFace = library.font
                    OptionLabel.Text = option
                    OptionLabel.TextColor3 = Color3.fromRGB(125, 125, 125)
                    OptionLabel.TextSize = library.font_size
                    OptionLabel.TextStrokeTransparency = 0
                    OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                    OptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    OptionLabel.BackgroundTransparency = 1
                    OptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    OptionLabel.BorderSizePixel = 0
                    OptionLabel.Position = UDim2.new(0, 4, 0, 0)
                    OptionLabel.Size = UDim2.new(1, 0, 1, 0)
                    OptionLabel.Parent = NewOption
                end
    
                Dropdown.OptionInsts[option].text = OptionLabel
                Count = Count + 1
                handleoptionclick(option, NewOption, OptionLabel)
            end
        end
        createoptions(Dropdown.Options)
        --
        local set
        set = function(option)
            if Dropdown.Max then
                table.clear(chosen)
                option = type(option) == "table" and option or {}
    
                for opt, tbl in next, Dropdown.OptionInsts do
                    if not table.find(option, opt) then
                        tbl.text.TextColor3 = Color3.fromRGB(125,125,125)
                    end
                end
    
                for i, opt in next, option do
                    if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
                        table.insert(chosen, opt)
                        Dropdown.OptionInsts[opt].text.TextColor3 = library.menu_colors.inline_accent
                    end
                end
    
                local textchosen = {}
                for _, opt in next, chosen do
                    table.insert(textchosen, opt)
                end
    
                library.flags[Dropdown.Flag] = chosen
                Dropdown.Callback(chosen)
            end
        end
        --
        function Dropdown:Set(option)
            if Dropdown.Max then
                set(option)
            else
                for opt, tbl in next, Dropdown.OptionInsts do
                    if opt ~= option then
                        tbl.text.TextColor3 = Color3.fromRGB(125,125,125)
                    end
                end
                if table.find(Dropdown.Options, option) then
                    chosen = option
                    Dropdown.OptionInsts[option].text.TextColor3 = library.menu_colors.inline_accent
                    library.flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                else
                    chosen = nil
                    library.flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                end
            end
        end
        --
        function Dropdown:Refresh(tbl)
            for _, opt in next, Dropdown.OptionInsts do
                coroutine.wrap(function()
                    opt.button:Destroy()
                end)()
            end
            table.clear(Dropdown.OptionInsts)
    
            createoptions(tbl)
    
            if Dropdown.Max then
                table.clear(chosen)
            else
                chosen = nil
            end
    
            library.flags[Dropdown.Flag] = chosen
            Dropdown.Callback(chosen)
        end
    
        -- // Returning
        if Dropdown.Max then
            flags[Dropdown.Flag] = set
        else
            flags[Dropdown.Flag] = Dropdown
        end
        Dropdown:Set(Dropdown.State)
        return Dropdown
    end
    -- 
    function sections:Colorpicker(Properties)
        local Properties = Properties or {}
        local Colorpicker = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Name = (Properties.Name or "Colorpicker"),
            State = (
                Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Color3.fromRGB(255, 0, 0)
            ),
            Alpha = (
                Properties.alpha or Properties.Alpha
                    or Properties.transparency
                    or Properties.Transparency
                    or 1
            ),
            Callback = (
                Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
            ),
            Flag = (
                Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
            ),
            Colorpickers = 0,
        }
        --
        local NewColor = Instance.new("TextButton")
        local Title = Instance.new("TextLabel")
    
        do -- properties
            NewColor.Name = "NewColor"
            NewColor.FontFace = library.font
            NewColor.Text = ""
            NewColor.TextColor3 = Color3.fromRGB(0, 0, 0)
            NewColor.TextSize = library.font_size
            NewColor.AutoButtonColor = false
            NewColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewColor.BackgroundTransparency = 1
            NewColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewColor.BorderSizePixel = 0
            NewColor.Size = UDim2.new(1, 0, 0, 10)
            NewColor.Parent = Colorpicker.Section.elements.section_content
        
            Title.Name = "Title"
            Title.FontFace = library.font
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = library.font_size
            Title.TextStrokeTransparency = 0
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.BorderSizePixel = 0
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.Parent = NewColor
            Title.Text = Colorpicker.Name
        end
    
        -- // Functions
        Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
        local colorpickertypes = library:NewPicker(
            Colorpicker.Name,
            Colorpicker.State,
            Colorpicker.Alpha,
            NewColor,
            Colorpicker.Colorpickers,
            Colorpicker.Flag,
            Colorpicker.Callback
        )
    
        function Colorpicker:Set(color)
            colorpickertypes:set(color, false, true)
        end
    
        function Colorpicker:Colorpicker(Properties)
            local Properties = Properties or {}
            local NewColorpicker = {
                State = (
                    Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Color3.fromRGB(255, 0, 0)
                ),
                Alpha = (
                    Properties.alpha or Properties.Alpha or Properties.transparency or Properties.Transparency or 1
                ),
                Callback = (
                    Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
                ),
                Flag = (
                    Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
                ),
            }
            -- // Functions
            Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
            local Newcolorpickertypes = library:NewPicker(
                "",
                NewColorpicker.State,
                NewColorpicker.Alpha,
                NewColor,
                Colorpicker.Colorpickers,
                NewColorpicker.Flag,
                NewColorpicker.Callback
            )
    
            function NewColorpicker:Set(color)
                Newcolorpickertypes:Set(color)
            end
    
            -- // Returning
            return NewColorpicker
        end
    
        -- // Returning
        return Colorpicker
    end
    -- 
    function sections:keybind(Properties)
        local Properties = Properties or {}
        local Keybind = {
            Section = self,
            Name = Properties.name or Properties.Name or "Keybind",
            State = (
                Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil
            ),
            Mode = (Properties.mode or Properties.Mode or "Toggle"),
            UseKey = (Properties.UseKey or false),
            Ignore = (Properties.ignore or Properties.Ignore or false),
            Callback = (
                Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end
            ),
            Flag = (
                Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or library.NextFlag()
            ),
            Binding = nil,
        }
        local State, Key = false
        --
        local ModeBox = Instance.new("Frame")
        local Hold = Instance.new("TextButton")
        local Toggle = Instance.new("TextButton")
        local Always = Instance.new("TextButton")
        local NewBind = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local Outline = Instance.new("Frame")
        local Inline = Instance.new("TextButton")
        local Value = Instance.new("TextLabel")
        local Outline4 = Instance.new("Frame")
        local UIStroke = Instance.new("UIStroke")
        local ListValue;
        if not Keybind.Ignore then
            ListValue = library.keybind_list:NewKey(Keybind.State, Keybind.Name)
        end
        --
        do -- properties
            NewBind.Name = "NewBind"
            NewBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewBind.BackgroundTransparency = 1
            NewBind.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewBind.BorderSizePixel = 0
            NewBind.Size = UDim2.new(1, 0, 0, 10)
            NewBind.Parent = Keybind.Section.elements.section_content
        
            Title.Name = "Title"
            Title.FontFace = library.font
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = library.font_size
            Title.TextStrokeTransparency = 0
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.BorderSizePixel = 0
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.Parent = NewBind
            Title.Text = Keybind.Name
        
            Outline.Name = "Keybind_Outline"
            Outline.AnchorPoint = Vector2.new(1, 0.5)
            Outline.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline.Position = UDim2.new(1, -1, 0.5, 0)
            Outline.Size = UDim2.new(0, 35, 0, 12)
            Outline.Parent = NewBind
        
            Inline.Name = "Keybind_Inline"
            Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Inline.BorderSizePixel = 0
            Inline.Position = UDim2.new(0, 1, 0, 1)
            Inline.Size = UDim2.new(1, -2, 1, -2)
            Inline.FontFace = library.font
            Inline.Text = ""
            Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
            Inline.TextSize = library.font_size
            Inline.AutoButtonColor = false
            Inline.Parent = Outline
        
            Value.Name = "Value"
            Value.FontFace = library.font
            Value.Text = "MB2"
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = library.font_size
            Value.TextStrokeTransparency = 0
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1
            Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Value.BorderSizePixel = 0
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.Parent = Inline
            Outline.Size = UDim2.new(0, Value.TextBounds.X + 10, 1, 0)
        
            ModeBox.Name = "ModeBox"
            ModeBox.Parent = Outline
            ModeBox.AnchorPoint = Vector2.new(0,0.5)
            ModeBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
            ModeBox.BorderColor3 = Color3.fromRGB(17,17,17)
            ModeBox.BorderSizePixel = 1
            ModeBox.Size = UDim2.new(0, 65, 0, 60)
            ModeBox.Position = UDim2.new(0,40,0.5,0)
            ModeBox.Visible = false
            
            Outline4.Name = "Outline"
            Outline4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Outline4.BackgroundTransparency = 1
            Outline4.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Outline4.BorderSizePixel = 0
            Outline4.Position = UDim2.new(0, -1, 0, -1)
            Outline4.Size = UDim2.new(1, 2, 1, 2)
            Outline4.Parent = ModeBox
        
            UIStroke.Name = "UIStroke"
            UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke.Parent = Outline4
        
            Hold.Name = "Hold"
            Hold.Parent = ModeBox
            Hold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Hold.BackgroundTransparency = 1.000
            Hold.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Hold.BorderSizePixel = 0
            Hold.Size = UDim2.new(1, 0, 0.333000004, 0)
            Hold.ZIndex = 2
            Hold.FontFace = library.font
            Hold.Text = "Hold"
            Hold.TextColor3 = Keybind.Mode == "Hold" and Color3.fromRGB(255,255,255) or Color3.fromRGB(145,145,145)
            Hold.TextSize = library.font_size
            Hold.TextStrokeTransparency = 0
        
            Toggle.Name = "Toggle"
            Toggle.Parent = ModeBox
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.BackgroundTransparency = 1.000
            Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.BorderSizePixel = 0
            Toggle.Position = UDim2.new(0, 0, 0.333000004, 0)
            Toggle.Size = UDim2.new(1, 0, 0.333000004, 0)
            Toggle.ZIndex = 2
            Toggle.FontFace = library.font
            Toggle.Text = "Toggle"
            Toggle.TextColor3 = Keybind.Mode == "Toggle" and Color3.fromRGB(255,255,255) or Color3.fromRGB(145,145,145)
            Toggle.TextSize = library.font_size
            Toggle.TextStrokeTransparency = 0
        
            Always.Name = "Always"
            Always.Parent = ModeBox
            Always.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Always.BackgroundTransparency = 1.000
            Always.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Always.BorderSizePixel = 0
            Always.Position = UDim2.new(0, 0, 0.666999996, 0)
            Always.Size = UDim2.new(1, 0, 0.333000004, 0)
            Always.ZIndex = 2
            Always.FontFace = library.font
            Always.Text = "Always"
            Always.TextColor3 = Keybind.Mode == "Always" and Color3.fromRGB(255,255,255) or Color3.fromRGB(145,145,145)
            Always.TextSize = library.font_size
            Always.TextStrokeTransparency = 0
        end
    
        -- functions
        local function set(newkey)
            if string.find(tostring(newkey), "Enum") then
                if c then
                    c:Disconnect()
                    if Keybind.Flag then
                        library.flags[Keybind.Flag] = false
                    end
                    Keybind.Callback(false)
                end
                if tostring(newkey):find("Enum.KeyCode.") then
                    newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                elseif tostring(newkey):find("Enum.UserInputType.") then
                    newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                end
                if newkey == Enum.KeyCode.Backspace then
                    Key = nil
                    if Keybind.UseKey then
                        if Keybind.Flag then
                            library.flags[Keybind.Flag] = Key
                        end
                        Keybind.Callback(Key)
                    end
                    local text = "None"
                    Value.Text = text
                    if not Keybind.Ignore then
                        ListValue:Update(text, Keybind.Name)
                    end
                    Outline.Size = UDim2.new(0, Value.TextBounds.X + 10, 1, 0)
                elseif newkey ~= nil then
                    Key = newkey
                    if Keybind.UseKey then
                        if Keybind.Flag then
                            library.flags[Keybind.Flag] = Key
                        end
                        Keybind.Callback(Key)
                    end
                    local text = (library.keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
    
                    Value.Text = text
                    if not Keybind.Ignore then
                        ListValue:Update(text, Keybind.Name)
                    end
                    Outline.Size = UDim2.new(0, Value.TextBounds.X + 10, 1, 0)
                end
                library.flags[Keybind.Flag .. "_KEY"] = newkey
            elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
                if not Keybind.UseKey then
                    library.flags[Keybind.Flag .. "_KEY STATE"] = newkey
                    Keybind.Mode = newkey
                    if not Keybind.Ignore then
                        ListValue:Update((library.keys[Key] or tostring(Key):gsub("Enum.KeyCode.", "")), Keybind.Name)
                    end
                    if Keybind.Mode == "Always" then
                        State = true
                        if Keybind.Flag then
                            library.flags[Keybind.Flag] = State
                        end
                        Keybind.Callback(true)
                        ListValue:SetVisible(true)
                    end
                end
            else
                State = newkey
                if Keybind.Flag then
                    library.flags[Keybind.Flag] = newkey
                end
                Keybind.Callback(newkey)
            end
        end
        --
        set(Keybind.State)
        set(Keybind.Mode)
        Inline.MouseButton1Click:Connect(function()
            if not Keybind.Binding then
    
                Value.Text = "..."
    
                Keybind.Binding = library:connection(
                    enviroment.UserInputService.InputBegan,
                    function(input, gpe)
                        set( input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType )
                        library:Disconnect(Keybind.Binding)
                        task.wait()
                        Keybind.Binding = nil
                    end
                );
            end
        end)
        --
        library:connection(enviroment.UserInputService.InputBegan, function(inp)
            if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
                if Keybind.Mode == "Hold" then
                    if Keybind.Flag then
                        library.flags[Keybind.Flag] = true
                    end
                    c = library:connection(enviroment.RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        if Keybind.Callback then
                            Keybind.Callback(true)
                        end
                    end))
                    if not Keybind.Ignore then
                        ListValue:SetVisible(true)
                    end
                elseif Keybind.Mode == "Toggle" then
                    State = not State
                    if Keybind.Flag then
                        library.flags[Keybind.Flag] = State
                    end
                    Keybind.Callback(State)
                    if not Keybind.Ignore then
                        ListValue:SetVisible(State)
                    end
                end
            end
        end)
        --
        library:connection(enviroment.UserInputService.InputEnded, function(inp)
            if Keybind.Mode == "Hold" and not Keybind.UseKey then
                if Key ~= "" or Key ~= nil then
                    if inp.KeyCode == Key or inp.UserInputType == Key then
                        if c then
                            c:Disconnect()
                            if Keybind.Flag then
                                library.flags[Keybind.Flag] = false
                            end
                            if Keybind.Callback then
                                Keybind.Callback(false)
                            end
                            if not Keybind.Ignore then
                                ListValue:SetVisible(false)
                            end
                        end
                    end
                end
            end
        end)
        --
        library:connection(Inline.MouseButton2Down, function()
            ModeBox.Visible = true
            NewBind.ZIndex = 5
        end)
        --
        library:connection(Hold.MouseButton1Down, function()
            set("Hold")
            Hold.TextColor3 = Color3.fromRGB(255,255,255)
            Toggle.TextColor3 = Color3.fromRGB(145,145,145)
            Always.TextColor3 = Color3.fromRGB(145,145,145)
            ModeBox.Visible = false
            NewBind.ZIndex = 1
        end)
        --
        library:connection(Toggle.MouseButton1Down, function()
            set("Toggle")
            Hold.TextColor3 = Color3.fromRGB(145,145,145)
            Toggle.TextColor3 = Color3.fromRGB(255,255,255)
            Always.TextColor3 = Color3.fromRGB(145,145,145)
            ModeBox.Visible = false
            NewBind.ZIndex = 1
        end)
        --
        library:connection(Always.MouseButton1Down, function()
            set("Always")
            Hold.TextColor3 = Color3.fromRGB(145,145,145)
            Toggle.TextColor3 = Color3.fromRGB(145,145,145)
            Always.TextColor3 = Color3.fromRGB(255,255,255)
            ModeBox.Visible = false
            NewBind.ZIndex = 1
        end)
        --
        library:connection(enviroment.UserInputService.InputBegan, function(Input)
            if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not library:IsMouseOverFrame(ModeBox) then
                    ModeBox.Visible = false
                    NewBind.ZIndex = 1
                end
            end
        end)
        --
        library.flags[Keybind.Flag .. "_KEY"] = Keybind.State
        library.flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
        flags[Keybind.Flag] = set
        flags[Keybind.Flag .. "_KEY"] = set
        flags[Keybind.Flag .. "_KEY STATE"] = set
        --
        function Keybind:Set(key)
            set(key)
        end
    
        return Keybind
    end
    --
    do -- fade out & blur
        local blur_effect = cloneref(Instance.new("BlurEffect", enviroment.lighting))
        local is_fading = false;
        local black_bg = Instance.new("Frame")
        black_bg.Name = "DarkenFilter"
        black_bg.Size = UDim2.new(9999, 0, 9999, 0)
        black_bg.Position = UDim2.new(0, 0, 0, -100) 
        black_bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        black_bg.ZIndex = -9999 
        black_bg.Visible = library.open
        black_bg.BackgroundTransparency = 0.5
        black_bg.Parent = cloneref(Instance.new("ScreenGui", gethui()))
        --enviroment.user_input_service.MouseIconEnabled = not library.open
        
        library:connection(enviroment.user_input_service.InputBegan, function(input)
            if input.KeyCode == library.ui_key and not is_fading then
                is_fading = true
                if not library.open then
                    library.screen_gui.Enabled = true
                    black_bg.Visible = true
                end
    
                local tweens = {}
                for _, v in pairs(library.screen_gui:GetDescendants()) do
                    if v.Name == "Outline_Background" or v.Name == "Background" or v.Name == "Inline_Background" or v.Name == "SectionOutline" or v.Name == "SectionInline" or v.Name == "Toggle_Outline" or v.Name == "Toggle_Inline" or v.Name == "Keybind_Outline" or v.Name == "Keybind_Inline" or v.Name == "Slider_Accent" or v.Name == "Slider_Outline" or v.Name == "Slider_Inline" or v.Name == "Toggle_Accent" or v.Name == "Button_Outline" or v.Name == "Button_Inline" or v.Name == "List_ContentOutline" or v.Name == "List_ContentInline" or v.Name == "List_Outline" or v.Name == "List_Inline" or v.Name == "ModeBox" or v.Name == "Icon_Line" or v.Name == "Tab" or v.Name == "ContentOutline" or v.Name == "ContentInline" or v.Name == "Textbox_Outline" or v.Name == "Textbox_Inline" or v.Name == "Icon_Colorpicker" then
                        table.insert(tweens, enviroment.tween_service:Create(v, TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = library.open and 1 or 0 }))
                    end
    
                    if v:IsA("UIStroke") then
                        table.insert(tweens, enviroment.tween_service:Create(v, TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Transparency = library.open and 1 or 0 }))
                    end
                    if v:IsA("ImageLabel") then 
                        table.insert(tweens, enviroment.tween_service:Create(v, TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { ImageTransparency = library.open and 1 or 0 }))
                    end
                    if v:IsA("TextLabel") or v:IsA("TextButton") then
                        table.insert(tweens, enviroment.tween_service:Create(v, TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { TextTransparency = library.open and 1 or 0 }))
                    end
                end
                
                if flags["darken_filter"] then
                    local blackbg_tween = enviroment.tween_service:Create(black_bg, TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = library.open and 1 or 0.5 })
                    table.insert(tweens, blackbg_tween)
                end
                
                local blur_tween = enviroment.tween_service:Create(blur_effect, TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Size = flags["blur_filter"] and not library.open and 20 or 0 })
                table.insert(tweens, blur_tween)
                
                for _, tween in ipairs(tweens) do 
                    tween:Play() 
                end
                
                library.open = not library.open
                --enviroment.user_input_service.MouseIconEnabled = not library.open
                
                blur_tween.Completed:Connect(function() 
                    if not library.open then
                        library.screen_gui.Enabled = false
                        black_bg.Visible = false
                    end
                    is_fading = false 
                end)
            end
        end)    
    end
end
