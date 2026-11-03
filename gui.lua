-- gui.lua | Sound Horeg Controller
local TweenSvc = game:GetService("TweenService")

return function(playerGui, playerName)
    pcall(function()
        if playerGui:FindFirstChild("__SH__") then
            playerGui.__SH__:Destroy()
        end
    end)

    -- ScreenGui
    local SG = Instance.new("ScreenGui")
    SG.Name            = "__SH__"
    SG.ResetOnSpawn    = false
    SG.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    SG.IgnoreGuiInset  = true
    SG.Parent          = playerGui

    -- Window
    local Win = Instance.new("Frame")
    Win.Size             = UDim2.new(0, 230, 0, 300)
    Win.Position         = UDim2.new(0, 20, 0.5, -150)
    Win.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Win.BorderSizePixel  = 0
    Win.Parent           = SG
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color     = Color3.fromRGB(60, 60, 90)
    Stroke.Thickness = 1
    Stroke.Parent    = Win

    -- TitleBar
    local TBar = Instance.new("Frame")
    TBar.Size             = UDim2.new(1, 0, 0, 36)
    TBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    TBar.BorderSizePixel  = 0
    TBar.Parent           = Win
    Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 10)
    local fix = Instance.new("Frame")
    fix.Size             = UDim2.new(1, 0, 0.5, 0)
    fix.Position         = UDim2.new(0, 0, 0.5, 0)
    fix.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    fix.BorderSizePixel  = 0
    fix.Parent           = TBar

    local Dot = Instance.new("Frame")
    Dot.Size             = UDim2.new(0, 7, 0, 7)
    Dot.Position         = UDim2.new(0, 12, 0.5, -3.5)
    Dot.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
    Dot.BorderSizePixel  = 0
    Dot.Parent           = TBar
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local Title = Instance.new("TextLabel")
    Title.Size               = UDim2.new(1, -80, 1, 0)
    Title.Position           = UDim2.new(0, 26, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text               = "SH Panel"
    Title.TextColor3         = Color3.fromRGB(200, 200, 230)
    Title.TextSize           = 12
    Title.Font               = Enum.Font.GothamBold
    Title.TextXAlignment     = Enum.TextXAlignment.Left
    Title.Parent             = TBar

    -- Close
    local BClose = Instance.new("TextButton")
    BClose.Size             = UDim2.new(0, 24, 0, 24)
    BClose.Position         = UDim2.new(1, -30, 0.5, -12)
    BClose.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    BClose.Text             = "×"
    BClose.TextColor3       = Color3.fromRGB(255, 255, 255)
    BClose.TextSize         = 14
    BClose.Font             = Enum.Font.GothamBold
    BClose.BorderSizePixel  = 0
    BClose.Parent           = TBar
    Instance.new("UICorner", BClose).CornerRadius = UDim.new(0, 5)
    BClose.MouseButton1Click:Connect(function() SG:Destroy() end)

    -- Minimize
    local minimized = false
    local BMin = Instance.new("TextButton")
    BMin.Size             = UDim2.new(0, 24, 0, 24)
    BMin.Position         = UDim2.new(1, -58, 0.5, -12)
    BMin.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    BMin.Text             = "–"
    BMin.TextColor3       = Color3.fromRGB(200, 200, 200)
    BMin.TextSize         = 14
    BMin.Font             = Enum.Font.GothamBold
    BMin.BorderSizePixel  = 0
    BMin.Parent           = TBar
    Instance.new("UICorner", BMin).CornerRadius = UDim.new(0, 5)

    local Body = Instance.new("Frame")
    Body.Size                = UDim2.new(1, 0, 1, -36)
    Body.Position            = UDim2.new(0, 0, 0, 36)
    Body.BackgroundTransparency = 1
    Body.Parent              = Win

    BMin.MouseButton1Click:Connect(function()
        minimized    = not minimized
        Body.Visible = not minimized
        Win.Size     = minimized and UDim2.new(0, 230, 0, 36)
                                  or UDim2.new(0, 230, 0, 300)
        BMin.Text    = minimized and "+" or "–"
    end)

    -- Log scroll
    local LogFrame = Instance.new("ScrollingFrame")
    LogFrame.Size                 = UDim2.new(1, -16, 0, 80)
    LogFrame.Position             = UDim2.new(0, 8, 0, 8)
    LogFrame.BackgroundColor3     = Color3.fromRGB(12, 12, 18)
    LogFrame.BorderSizePixel      = 0
    LogFrame.ScrollBarThickness   = 2
    LogFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 60, 150)
    LogFrame.CanvasSize           = UDim2.new(0, 0, 0, 0)
    LogFrame.Parent               = Body
    Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 6)
    local LogLayout = Instance.new("UIListLayout")
    LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogLayout.Padding   = UDim.new(0, 1)
    LogLayout.Parent    = LogFrame

    local logN = 0
    local function Log(txt, col)
        col  = col or Color3.fromRGB(160, 160, 180)
        logN = logN + 1
        local lbl = Instance.new("TextLabel")
        lbl.Size                 = UDim2.new(1, -4, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text                 = txt
        lbl.TextColor3           = col
        lbl.TextSize             = 10
        lbl.Font                 = Enum.Font.Code
        lbl.TextXAlignment       = Enum.TextXAlignment.Left
        lbl.TextTruncate         = Enum.TextTruncate.AtEnd
        lbl.LayoutOrder          = logN
        lbl.Parent               = LogFrame
        LogFrame.CanvasSize      = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 6)
        LogFrame.CanvasPosition  = Vector2.new(0, math.huge)
    end

    -- Counter
    local Counter = Instance.new("TextLabel")
    Counter.Size                 = UDim2.new(1, -16, 0, 18)
    Counter.Position             = UDim2.new(0, 8, 0, 92)
    Counter.BackgroundTransparency = 1
    Counter.Text                 = "Alat: 0  |  " .. playerName
    Counter.TextColor3           = Color3.fromRGB(120, 120, 160)
    Counter.TextSize             = 10
    Counter.Font                 = Enum.Font.Gotham
    Counter.TextXAlignment       = Enum.TextXAlignment.Left
    Counter.Parent               = Body

    -- Tombol helper
    local btnC = {
        scan  = {Color3.fromRGB(40,40,60),   Color3.fromRGB(60,60,90)},
        power = {Color3.fromRGB(60,30,120),  Color3.fromRGB(80,45,160)},
        knob  = {Color3.fromRGB(25,70,45),   Color3.fromRGB(35,100,60)},
        all   = {Color3.fromRGB(120,60,15),  Color3.fromRGB(160,80,20)},
    }
    local function MkBtn(label, yPos, cKey)
        local c   = btnC[cKey]
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, -16, 0, 36)
        btn.Position         = UDim2.new(0, 8, 0, yPos)
        btn.BackgroundColor3 = c[1]
        btn.Text             = label
        btn.TextColor3       = Color3.fromRGB(220, 220, 240)
        btn.TextSize         = 11
        btn.Font             = Enum.Font.GothamSemibold
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Parent           = Body
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        btn.MouseEnter:Connect(function()
            TweenSvc:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = c[2]}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenSvc:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = c[1]}):Play()
        end)
        return btn
    end

    return {
        SG      = SG,
        Win     = Win,
        TBar    = TBar,
        Log     = Log,
        Counter = Counter,
        BScan   = MkBtn("🔍  Scan Alat Saya",  115, "scan"),
        BPow    = MkBtn("⚡  Power ON",         157, "power"),
        BKnob   = MkBtn("🔊  Knob Full",        199, "knob"),
        BAll    = MkBtn("▶  Jalankan Semua",    241, "all"),
    }
end
