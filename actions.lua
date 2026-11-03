-- actions.lua | Sound Horeg Controller
local TweenSvc = game:GetService("TweenService")

local function rWait(a, b)
    task.wait(a + math.random() * ((b or a) - a))
end

local function getRemotes(keywords)
    local found = {}
    pcall(function()
        for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local n = v.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw) then
                        table.insert(found, v)
                        break
                    end
                end
            end
        end
    end)
    return found
end

return function(cfg, player)

    local function power(obj)
        -- 1. ClickDetector semua part
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("ClickDetector") then
                pcall(fireclickdetector, v)
                rWait(0.05, 0.15)
            end
        end

        -- 2. ProximityPrompt
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                pcall(fireproximityprompt, v)
                rWait(0.05, 0.12)
            end
        end

        -- 3. BoolValue power
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("BoolValue") then
                local n = v.Name:lower()
                if n:find("power") or n:find("ison")
                or n:find("activ") or n:find("enabl") then
                    pcall(function() v.Value = true end)
                end
            end
        end

        -- 4. Attribute
        for _, k in ipairs(cfg.powerAttrs) do
            pcall(function()
                if obj:GetAttribute(k) ~= nil then
                    obj:SetAttribute(k, true)
                end
            end)
        end

        -- 5. RemoteEvent
        for _, rem in ipairs(getRemotes({"power","on","activ","turn"})) do
            pcall(function() rem:FireServer(obj, true) end)
            rWait(0.05, 0.1)
        end

        -- 6. TouchInterest bagian power
        pcall(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in ipairs(obj:GetDescendants()) do
                if v:IsA("BasePart") then
                    local n = v.Name:lower()
                    if n:find("power") or n:find("switch")
                    or n:find("btn")   or n:find("button") then
                        firetouchinterest(hrp, v, 0)
                        rWait(0.04, 0.08)
                        firetouchinterest(hrp, v, 1)
                    end
                end
            end
        end)
    end

    local function knob(obj)
        -- 1. Rotate BasePart knob secara fisik
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("BasePart") then
                local n = v.Name:lower()
                if n:find("knob") or n:find("dial")
                or n:find("rotary") or n:find("wheel") then
                    pcall(function()
                        TweenSvc:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
                            CFrame = v.CFrame * CFrame.Angles(0, math.rad(150), 0)
                        }):Play()
                        local cd = v:FindFirstChildWhichIsA("ClickDetector")
                        if cd then fireclickdetector(cd) end
                    end)
                    rWait(0.1, 0.2)
                end
            end
        end

        -- 2. NumberValue / IntValue
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                local n = v.Name:lower()
                if n:find("volume") or n:find("knob") or n:find("gain")
                or n:find("level")  or n:find("val") then
                    pcall(function()
                        v.Value = v:IsA("IntValue") and 100 or 1
                    end)
                end
            end
            if v:IsA("Sound") then
                pcall(function()
                    v.Volume = 1
                    if not v.IsPlaying then v:Play() end
                end)
            end
        end

        -- 3. Attribute
        for _, k in ipairs(cfg.knobAttrs) do
            pcall(function()
                if obj:GetAttribute(k) ~= nil then
                    obj:SetAttribute(k, 1)
                end
            end)
        end

        -- 4. RemoteEvent knob/volume
        for _, rem in ipairs(getRemotes({"knob","volume","gain","level","rotat","dial"})) do
            pcall(function() rem:FireServer(obj, 1) end)
            rWait(0.05, 0.1)
        end

        -- 5. TouchInterest knob
        pcall(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in ipairs(obj:GetDescendants()) do
                if v:IsA("BasePart") then
                    local n = v.Name:lower()
                    if n:find("knob") or n:find("dial") then
                        firetouchinterest(hrp, v, 0)
                        rWait(0.05, 0.1)
                        firetouchinterest(hrp, v, 1)
                    end
                end
            end
        end)
    end

    return { power = power, knob = knob }
end
