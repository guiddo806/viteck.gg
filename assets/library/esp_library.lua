local ESP = {}
local Drawing = require("Drawing") -- Предполагаем, что Drawing API доступен
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

-- Настройки по умолчанию
ESP.Settings = {
    Enabled = false,
    Box = false,
    Name = false,
    Distance = false,
    Weapon = false,
    Skeleton = false,
    TeamCheck = false,
    AICheck = false,
    SleeperCheck = false,
    TextOutline = false,
    BoxOutline = false,
    SkeletonOutline = false,
    MaxDistance = 1500,
    BoxType = "corner",
    BoxColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- Хранилище для ESP-объектов
local has_esp = {}
local entity_list
local cache_2 = {}

-- Инициализация entity_list
for _, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "GetEntityFromPart") then
        entity_list = debug.getupvalue(rawget(v, "GetEntityFromPart"), 1)
        break
    end
end

if not entity_list then
    warn("Entity list not found. ESP will not function.")
end

-- Вспомогательные функции
local vertices = {
    Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1), Vector3.new(-1, 1, 1), Vector3.new(-1, -1, 1),
    Vector3.new(1, -1, -1), Vector3.new(1, 1, -1), Vector3.new(1, 1, 1), Vector3.new(1, -1, 1)
}

local function is_body_part(name)
    return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm") or name:find("Hand") or name:find("Foot")
end

local function get_bounding_box(parts)
    local min, max
    for _, part in ipairs(parts) do
        local cframe, size = part.CFrame, part.Size
        local min_pos = (cframe - size * 0.5).Position
        local max_pos = (cframe + size * 0.5).Position
        min = min or min_pos
        min = Vector3.new(math.min(min.X, min_pos.X), math.min(min.Y, min_pos.Y), math.min(min.Z, min_pos.Z))
        max = max or max_pos
        max = Vector3.new(math.max(max.X, max_pos.X), math.max(max.Y, max_pos.Y), math.max(max.Z, max_pos.Z))
    end
    local center = (min + max) * 0.5
    return CFrame.new(center, Vector3.new(center.X, center.Y, max.Z)), max - min
end

local function world_to_screen(world)
    local screen, in_bounds = Camera:WorldToViewportPoint(world)
    return Vector2.new(screen.X, screen.Y), in_bounds
end

local function calculate_corners(cframe, size)
    local min_x, min_y = Camera.ViewportSize.X, Camera.ViewportSize.Y
    local max_x, max_y = 0, 0
    for _, vertex in ipairs(vertices) do
        local screen, in_bounds = world_to_screen((cframe + size * 0.5 * vertex).Position)
        if in_bounds then
            min_x = math.min(min_x, screen.X)
            min_y = math.min(min_y, screen.Y)
            max_x = math.max(max_x, screen.X)
            max_y = math.max(max_y, screen.Y)
        end
    end
    return {
        top_left = Vector2.new(math.floor(min_x), math.floor(min_y)),
        bottom_right = Vector2.new(math.floor(max_x), math.floor(max_y))
    }
end

local function get_skeleton_connections(model)
    local connections = {}
    local parts = {}

    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and is_body_part(part.Name) then
            parts[part.Name] = part
        end
    end

    local skeleton_pairs = {
        {"Torso", "Head"}, {"LowerTorso", "Torso"}, {"Torso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"Torso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }

    for _, pair in ipairs(skeleton_pairs) do
        local part1 = parts[pair[1]]
        local part2 = parts[pair[2]]
        if part1 and part2 then
            table.insert(connections, {part1, part2})
        end
    end

    return connections
end

local function sleep_check(model)
    local animation_controller = model:FindFirstChild("AnimationController")
    if animation_controller then
        local animations = animation_controller:GetPlayingAnimationTracks()
        for _, v in pairs(animations) do
            if v.IsPlaying and v.Animation.AnimationId == "rbxassetid://13280887764" then
                return true
            end
        end
    end
    return false
end

local function get_weapon(entity)
    return rawget(entity, "equippedItem") and rawget(rawget(entity, "equippedItem"), "type") or "None"
end

local function get_entity_name(entity_data, model)
    local head = model:FindFirstChild("Head")
    local name = "Player"
    local has_teamtag = false

    if head then
        local nametag = head:FindFirstChild("Nametag")
        local teamtag = head:FindFirstChild("TeamTag")
        
        if nametag and nametag:FindFirstChild("tag") and nametag.tag:IsA("TextLabel") then
            if nametag.tag.TextTransparency < 1 and nametag.tag.Visible and nametag.tag.Text ~= "" then
                name = nametag.tag.Text
            end
        end

        if teamtag and teamtag.Enabled then
            has_teamtag = true
        end
    end

    local entity_type = rawget(entity_data, "type")
    local entity_name = rawget(entity_data, "Name")
    if entity_type == "Player" and entity_name and name == "Entity" then
        name = entity_name
    elseif entity_type ~= "Player" then
        name = entity_name or entity_type or "Player"
    end

    return name, has_teamtag
end

-- Создание ESP-объекта для сущности
local function create_esp()
    local instance = {
        corner_lines = {},
        corner_outlines = {},
        skeleton_lines = {},
        skeleton_outlines = {},
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        weapon = Drawing.new("Text")
    }

    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = ESP.Settings.BoxColor
        line.Thickness = 1
        line.Transparency = 1
        line.ZIndex = 2
        instance.corner_lines[i] = line

        local outline = Drawing.new("Line")
        outline.Visible = false
        outline.Color = Color3.fromRGB(0, 0, 0)
        outline.Thickness = 3
        outline.Transparency = 1
        outline.ZIndex = 1
        instance.corner_outlines[i] = outline
    end

    for i = 1, 14 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = ESP.Settings.SkeletonColor
        line.Thickness = 1
        line.Transparency = 1
        line.ZIndex = 2
        instance.skeleton_lines[i] = line

        local outline = Drawing.new("Line")
        outline.Visible = false
        outline.Color = Color3.fromRGB(0, 0, 0)
        outline.Thickness = 3
        outline.Transparency = 1
        outline.ZIndex = 1
        instance.skeleton_outlines[i] = outline
    end

    instance.name.Visible = false
    instance.name.Color = ESP.Settings.TextColor
    instance.name.Size = 15
    instance.name.Center = true
    instance.name.Outline = ESP.Settings.TextOutline
    instance.name.OutlineColor = Color3.fromRGB(0, 0, 0)
    instance.name.ZIndex = 3

    instance.distance.Visible = false
    instance.distance.Color = ESP.Settings.TextColor
    instance.distance.Size = 15
    instance.distance.Center = false
    instance.distance.Outline = ESP.Settings.TextOutline
    instance.distance.OutlineColor = Color3.fromRGB(0, 0, 0)
    instance.distance.ZIndex = 3

    instance.weapon.Visible = false
    instance.weapon.Color = ESP.Settings.TextColor
    instance.weapon.Size = 15
    instance.weapon.Center = true
    instance.weapon.Outline = ESP.Settings.TextOutline
    instance.weapon.OutlineColor = Color3.fromRGB(0, 0, 0)
    instance.weapon.ZIndex = 3

    return instance
end

-- Очистка ESP-объекта
local function cleanup_esp(entity_data)
    local instance = has_esp[entity_data]
    if instance then
        for _, line in pairs(instance.corner_lines) do line:Remove() end
        for _, line in pairs(instance.corner_outlines) do line:Remove() end
        for _, line in pairs(instance.skeleton_lines) do line:Remove() end
        for _, line in pairs(instance.skeleton_outlines) do line:Remove() end
        instance.name:Remove()
        instance.distance:Remove()
        instance.weapon:Remove()
        has_esp[entity_data] = nil
    end
end

-- Основная функция ESP
function ESP:Enable()
    if self.connection then return end
    
    self.connection = RunService.RenderStepped:Connect(function()
        if not self.Settings.Enabled then return end
        if not Camera then Camera = Workspace.CurrentCamera end
        if not Camera then return end

        local active_entities = {}
        for entity_data, _ in pairs(has_esp) do
            active_entities[entity_data] = true
        end

        for _, entity_data in pairs(entity_list) do
            local model = rawget(entity_data, "model")
            if not model or not model:FindFirstChild("Head") or not model:FindFirstChild("LowerTorso") then
                cleanup_esp(entity_data)
                active_entities[entity_data] = nil
                continue
            end

            local root = model:FindFirstChild("HumanoidRootPart")
            local sleeping = rawget(entity_data, "sleeping")
            local entity_type = rawget(entity_data, "type")

            if not root then
                cleanup_esp(entity_data)
                active_entities[entity_data] = nil
                continue
            end

            if self.Settings.AICheck and entity_type ~= "Player" then
                cleanup_esp(entity_data)
                active_entities[entity_data] = nil
                continue
            end

            if not has_esp[entity_data] then
                has_esp[entity_data] = create_esp()
                table.insert(cache_2, entity_data)
            end

            local instance = has_esp[entity_data]
            local _, on_screen = Camera:WorldToViewportPoint(root.Position)
            local distance = (Camera.CFrame.Position - root.Position).Magnitude

            if on_screen and distance <= self.Settings.MaxDistance then
                local parts = {}
                for _, part in ipairs(model:GetChildren()) do
                    if part:IsA("BasePart") and is_body_part(part.Name) then
                        table.insert(parts, part)
                    end
                end
                if #parts == 0 then
                    for _, line in pairs(instance.corner_lines) do line.Visible = false end
                    for _, line in pairs(instance.corner_outlines) do line.Visible = false end
                    for _, line in pairs(instance.skeleton_lines) do line.Visible = false end
                    for _, line in pairs(instance.skeleton_outlines) do line.Visible = false end
                    instance.name.Visible = false
                    instance.distance.Visible = false
                    instance.weapon.Visible = false
                    continue
                end

                if self.Settings.SleeperCheck and (sleeping or sleep_check(model)) then
                    for _, line in pairs(instance.corner_lines) do line.Visible = false end
                    for _, line in pairs(instance.corner_outlines) do line.Visible = false end
                    for _, line in pairs(instance.skeleton_lines) do line.Visible = false end
                    for _, line in pairs(instance.skeleton_outlines) do line.Visible = false end
                    instance.name.Visible = false
                    instance.distance.Visible = false
                    instance.weapon.Visible = false
                    continue
                end

                local corners = calculate_corners(get_bounding_box(parts))
                local center_x = (corners.top_left.X + corners.bottom_right.X) / 2
                local center_y = (corners.top_left.Y + corners.bottom_right.Y) / 2
                local width = corners.bottom_right.X - corners.top_left.X
                local height = corners.bottom_right.Y - corners.top_left.Y

                local entity_name, has_teamtag = get_entity_name(entity_data, model)
                local esp_color = (self.Settings.TeamCheck and has_teamtag) and Color3.fromRGB(0, 255, 0) or self.Settings.BoxColor

                if self.Settings.Box then
                    for _, line in pairs(instance.corner_lines) do line.Color = esp_color end
                    if self.Settings.BoxType == "corner" then
                        local w = width * 0.3
                        local h = height * 0.3

                        local top_left = corners.top_left
                        local top_right = Vector2.new(corners.bottom_right.X, corners.top_left.Y)
                        local bottom_left = Vector2.new(corners.top_left.X, corners.bottom_right.Y)
                        local bottom_right = corners.bottom_right

                        instance.corner_lines[1].From = top_left
                        instance.corner_lines[1].To = Vector2.new(top_left.X + w, top_left.Y)
                        instance.corner_outlines[1].From = top_left
                        instance.corner_outlines[1].To = Vector2.new(top_left.X + w, top_left.Y)
                        instance.corner_lines[2].From = top_left
                        instance.corner_lines[2].To = Vector2.new(top_left.X, top_left.Y + h)
                        instance.corner_outlines[2].From = top_left
                        instance.corner_outlines[2].To = Vector2.new(top_left.X, top_left.Y + h)

                        instance.corner_lines[3].From = top_right
                        instance.corner_lines[3].To = Vector2.new(top_right.X - w, top_right.Y)
                        instance.corner_outlines[3].From = top_right
                        instance.corner_outlines[3].To = Vector2.new(top_right.X - w, top_right.Y)
                        instance.corner_lines[4].From = top_right
                        instance.corner_lines[4].To = Vector2.new(top_right.X, top_right.Y + h)
                        instance.corner_outlines[4].From = top_right
                        instance.corner_outlines[4].To = Vector2.new(top_right.X, top_right.Y + h)

                        instance.corner_lines[5].From = bottom_left
                        instance.corner_lines[5].To = Vector2.new(bottom_left.X + w, bottom_left.Y)
                        instance.corner_outlines[5].From = bottom_left
                        instance.corner_outlines[5].To = Vector2.new(bottom_left.X + w, bottom_left.Y)
                        instance.corner_lines[6].From = bottom_left
                        instance.corner_lines[6].To = Vector2.new(bottom_left.X, bottom_left.Y - h)
                        instance.corner_outlines[6].From = bottom_left
                        instance.corner_outlines[6].To = Vector2.new(bottom_left.X, bottom_left.Y - h)

                        instance.corner_lines[7].From = bottom_right
                        instance.corner_lines[7].To = Vector2.new(bottom_right.X - w, bottom_right.Y)
                        instance.corner_outlines[7].From = bottom_right
                        instance.corner_outlines[7].To = Vector2.new(bottom_right.X - w, bottom_right.Y)
                        instance.corner_lines[8].From = bottom_right
                        instance.corner_lines[8].To = Vector2.new(bottom_right.X, bottom_right.Y - h)
                        instance.corner_outlines[8].From = bottom_right
                        instance.corner_outlines[8].To = Vector2.new(bottom_right.X, bottom_right.Y - h)

                        for i = 1, 8 do
                            instance.corner_lines[i].Visible = true
                            instance.corner_outlines[i].Visible = self.Settings.BoxOutline
                        end
                    elseif self.Settings.BoxType == "box" then
                        local top_left = corners.top_left
                        local bottom_right = corners.bottom_right
                        local top_right = Vector2.new(bottom_right.X, top_left.Y)
                        local bottom_left = Vector2.new(top_left.X, bottom_right.Y)

                        instance.corner_lines[1].From = top_left
                        instance.corner_lines[1].To = top_right
                        instance.corner_outlines[1].From = top_left
                        instance.corner_outlines[1].To = top_right
                        instance.corner_lines[1].Visible = true
                        instance.corner_outlines[1].Visible = self.Settings.BoxOutline

                        instance.corner_lines[2].From = top_right
                        instance.corner_lines[2].To = bottom_right
                        instance.corner_outlines[2].From = top_right
                        instance.corner_outlines[2].To = bottom_right
                        instance.corner_lines[2].Visible = true
                        instance.corner_outlines[2].Visible = self.Settings.BoxOutline

                        instance.corner_lines[3].From = bottom_right
                        instance.corner_lines[3].To = bottom_left
                        instance.corner_outlines[3].From = bottom_right
                        instance.corner_outlines[3].To = bottom_left
                        instance.corner_lines[3].Visible = true
                        instance.corner_outlines[3].Visible = self.Settings.BoxOutline

                        instance.corner_lines[4].From = bottom_left
                        instance.corner_lines[4].To = top_left
                        instance.corner_outlines[4].From = bottom_left
                        instance.corner_outlines[4].To = top_left
                        instance.corner_lines[4].Visible = true
                        instance.corner_outlines[4].Visible = self.Settings.BoxOutline

                        for i = 5, 8 do
                            instance.corner_lines[i].Visible = false
                            instance.corner_outlines[i].Visible = false
                        end
                    end
                else
                    for _, line in pairs(instance.corner_lines) do line.Visible = false end
                    for _, line in pairs(instance.corner_outlines) do line.Visible = false end
                end

                if self.Settings.Skeleton then
                    for _, line in pairs(instance.skeleton_lines) do line.Color = self.Settings.SkeletonColor end
                    local connections = get_skeleton_connections(model)
                    for i, connection in ipairs(connections) do
                        if i > 14 then break end
                        local part1, part2 = connection[1], connection[2]
                        local pos1, in_bounds1 = world_to_screen(part1.Position)
                        local pos2, in_bounds2 = world_to_screen(part2.Position)
                        local line = instance.skeleton_lines[i]
                        local outline = instance.skeleton_outlines[i]

                        if in_bounds1 and in_bounds2 then
                            line.From = pos1
                            line.To = pos2
                            outline.From = pos1
                            outline.To = pos2
                            line.Visible = true
                            outline.Visible = self.Settings.SkeletonOutline
                        else
                            line.Visible = false
                            outline.Visible = false
                        end
                    end
                    for i = #connections + 1, 14 do
                        instance.skeleton_lines[i].Visible = false
                        instance.skeleton_outlines[i].Visible = false
                    end
                else
                    for _, line in pairs(instance.skeleton_lines) do line.Visible = false end
                    for _, line in pairs(instance.skeleton_outlines) do line.Visible = false end
                end

                if self.Settings.Name then
                    instance.name.Visible = true
                    instance.name.Text = entity_name
                    instance.name.Position = Vector2.new(center_x - 16, center_y - height/2 - 15)
                    instance.name.Color = self.Settings.TextColor
                    
                    if self.Settings.Distance then
                        instance.distance.Visible = true
                        instance.distance.Text = "[" .. math.floor(distance) .. "]"
                        instance.distance.Position = Vector2.new(center_x - 16 + instance.name.TextBounds.X/2 + 2, center_y - height/2 - 15)
                        instance.distance.Color = self.Settings.TextColor
                    else
                        instance.distance.Visible = false
                    end
                else
                    instance.name.Visible = false
                    instance.distance.Visible = false
                end

                if self.Settings.Weapon then
                    instance.weapon.Visible = true
                    local weapon = get_weapon(entity_data)
                    instance.weapon.Text = weapon
                    instance.weapon.Position = Vector2.new(center_x, center_y + height/2 + 0)
                    instance.weapon.Color = self.Settings.TextColor
                else
                    instance.weapon.Visible = false
                end

            else
                for _, line in pairs(instance.corner_lines) do line.Visible = false end
                for _, line in pairs(instance.corner_outlines) do line.Visible = false end
                for _, line in pairs(instance.skeleton_lines) do line.Visible = false end
                for _, line in pairs(instance.skeleton_outlines) do line.Visible = false end
                instance.name.Visible = false
                instance.distance.Visible = false
                instance.weapon.Visible = false
            end

            active_entities[entity_data] = nil
        end

        for entity_data, _ in pairs(active_entities) do
            cleanup_esp(entity_data)
        end
    end)

    Workspace.ChildAdded:Connect(function(child)
        task.delay(1.5, function()
            for _, entity_data in pairs(entity_list) do
                local model = rawget(entity_data, "model")
                if model and model == child and model:FindFirstChild("Head") and model:FindFirstChild("LowerTorso") and not table.find(cache_2, entity_data) then
                    table.insert(cache_2, entity_data)
                    if not has_esp[entity_data] then
                        has_esp[entity_data] = create_esp()
                    end
                end
            end
        end)
    end)
end

-- Отключение ESP
function ESP:Disable()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    for entity_data in pairs(has_esp) do
        cleanup_esp(entity_data)
    end
end

-- Переключение ESP
function ESP:Toggle(state)
    self.Settings.Enabled = state
    if state then
        self:Enable()
    else
        self:Disable()
    end
end

-- Методы для управления настройками
function ESP:SetBox(state)
    self.Settings.Box = state
end

function ESP:SetName(state)
    self.Settings.Name = state
end

function ESP:SetDistance(state)
    self.Settings.Distance = state
end

function ESP:SetWeapon(state)
    self.Settings.Weapon = state
end

function ESP:SetSkeleton(state)
    self.Settings.Skeleton = state
end

function ESP:SetTeamCheck(state)
    self.Settings.TeamCheck = state
end

function ESP:SetAICheck(state)
    self.Settings.AICheck = state
end

function ESP:SetSleeperCheck(state)
    self.Settings.SleeperCheck = state
end

function ESP:SetTextOutline(state)
    self.Settings.TextOutline = state
    if next(has_esp) then
        for _, instance in pairs(has_esp) do
            instance.name.Outline = state
            instance.distance.Outline = state
            instance.weapon.Outline = state
        end
    end
end

function ESP:SetBoxOutline(state)
    self.Settings.BoxOutline = state
    if next(has_esp) then
        for _, instance in pairs(has_esp) do
            for _, outline in pairs(instance.corner_outlines) do
                if self.Settings.Box then
                    outline.Visible = state
                end
            end
        end
    end
end

function ESP:SetSkeletonOutline(state)
    self.Settings.SkeletonOutline = state
    if next(has_esp) then
        for _, instance in pairs(has_esp) do
            for _, outline in pairs(instance.skeleton_outlines) do
                if self.Settings.Skeleton then
                    outline.Visible = state
                end
            end
        end
    end
end

function ESP:SetMaxDistance(distance)
    self.Settings.MaxDistance = distance
end

function ESP:SetBoxType(box_type)
    if box_type == "corner" or box_type == "box" then
        self.Settings.BoxType = box_type
    end
end

function ESP:SetBoxColor(color)
    self.Settings.BoxColor = color
    for _, instance in pairs(has_esp) do
        for _, line in pairs(instance.corner_lines) do
            line.Color = color
        end
    end
end

function ESP:SetSkeletonColor(color)
    self.Settings.SkeletonColor = color
    for _, instance in pairs(has_esp) do
        for _, line in pairs(instance.skeleton_lines) do
            line.Color = color
        end
    end
end

function ESP:SetTextColor(color)
    self.Settings.TextColor = color
    for _, instance in pairs(has_esp) do
        instance.name.Color = color
        instance.distance.Color = color
        instance.weapon.Color = color
    end
end

return ESP
