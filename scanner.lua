-- scanner.lua | Sound Horeg Controller
return function(cfg, player, snapshot)

    local function isMine(obj)
        -- M1: Attribute owner
        for _, k in ipairs(cfg.ownerKeys) do
            local v = obj:GetAttribute(k)
            if v then
                local s = tostring(v)
                if s == player.Name or s == tostring(player.UserId) then
                    return true
                end
            end
            -- M2: Child StringValue / IntValue
            local c = obj:FindFirstChild(k)
            if c and (c:IsA("StringValue") or c:IsA("IntValue")) then
                local s = tostring(c.Value)
                if s == player.Name or s == tostring(player.UserId) then
                    return true
                end
            end
        end

        -- M3: Parent folder = nama player
        local par = obj.Parent
        while par and par ~= workspace do
            if par.Name == player.Name
            or par.Name == tostring(player.UserId) then
                return true
            end
            par = par.Parent
        end

        -- M4: Objek baru (tidak ada di snapshot sebelum script jalan)
        if not snapshot[obj] then return true end

        -- M5: Jarak < scanRadius dari karakter
        local char = player.Character
        if char then
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            local root = obj:FindFirstChildWhichIsA("BasePart")
            if hrp and root then
                if (hrp.Position - root.Position).Magnitude < cfg.scanRadius then
                    return true
                end
            end
        end

        return false
    end

    local function isAudio(obj)
        local n = obj.Name:lower()
        for _, k in ipairs(cfg.audioNames) do
            if n:find(k, 1, true) then return true end
        end
        if obj:GetAttribute("Type") == "AudioPeripheral" then return true end
        return false
    end

    return { isMine = isMine, isAudio = isAudio }
end
