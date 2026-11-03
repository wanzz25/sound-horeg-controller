-- ============================================
-- Sound Horeg Controller v2.0
-- Paste file ini ke Delta Executor
-- Github: https://github.com/YOUR_USERNAME/sound-horeg-controller
-- ============================================

-- ⚠️  Ganti dengan username & nama repo GitHub kamu
local BASE = "https://raw.githubusercontent.com/YOUR_USERNAME/sound-horeg-controller/main/"

local function load(f)
    return loadstring(game:HttpGet(BASE .. f, true))()
end

-- Services
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local me      = Players.LocalPlayer

-- Snapshot model yang sudah ada sebelum script jalan
local snapshot = {}
for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Model") then snapshot[v] = true end
end

-- Load semua modul dari GitHub
local cfg  = load("config.lua")
local gui  = load("gui.lua")(me.PlayerGui, me.Name)
           load("drag.lua")(gui.Win, gui.TBar)
local scan = load("scanner.lua")(cfg, me, snapshot)
local act  = load("actions.lua")(cfg, me)

-- State
local myModels = {}

local function rWait(a, b)
    task.wait(a + math.random() * ((b or a) - a))
end

-- Scan alat milik sendiri
local function doScan()
    myModels = {}
    gui.Log("── Scan ──", Color3.fromRGB(50, 50, 70))

    local all = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and scan.isAudio(v) then
            table.insert(all, v)
        end
    end

    for _, v in ipairs(all) do
        if scan.isMine(v) then
            table.insert(myModels, v)
            gui.Log("✓ " .. v.Name, Color3.fromRGB(100, 220, 120))
        end
    end

    -- Fallback: jika tidak ada yang cocok, ambil semua
    if #myModels == 0 and #all > 0 then
        gui.Log("! Fallback semua audio", Color3.fromRGB(255, 200, 50))
        myModels = all
        for _, v in ipairs(myModels) do
            gui.Log("~ " .. v.Name, Color3.fromRGB(200, 200, 100))
        end
    end

    gui.Counter.Text = "Alat: " .. #myModels .. "  |  " .. me.Name
    gui.Log("Total: " .. #myModels, Color3.fromRGB(120, 180, 120))
end

-- ── Tombol Scan ──
gui.BScan.MouseButton1Click:Connect(function()
    gui.BScan.Text = "Scanning..."
    doScan()
    gui.BScan.Text = "🔍  Scan Alat Saya"
end)

-- ── Tombol Power ──
gui.BPow.MouseButton1Click:Connect(function()
    if #myModels == 0 then doScan() end
    gui.Log("── Power ON ──", Color3.fromRGB(50, 50, 70))
    gui.BPow.Text = "Loading..."
    for _, m in ipairs(myModels) do
        gui.Log("⚡ " .. m.Name, Color3.fromRGB(220, 180, 80))
        act.power(m)
        rWait(0.3, 0.6)
    end
    gui.BPow.Text = "⚡  Power ON"
    gui.Log("✓ Done", Color3.fromRGB(100, 220, 100))
end)

-- ── Tombol Knob ──
gui.BKnob.MouseButton1Click:Connect(function()
    if #myModels == 0 then doScan() end
    gui.Log("── Knob Full ──", Color3.fromRGB(50, 50, 70))
    gui.BKnob.Text = "Loading..."
    for _, m in ipairs(myModels) do
        gui.Log("🔊 " .. m.Name, Color3.fromRGB(80, 200, 180))
        act.knob(m)
        rWait(0.25, 0.5)
    end
    gui.BKnob.Text = "🔊  Knob Full"
    gui.Log("✓ Done", Color3.fromRGB(100, 220, 100))
end)

-- ── Tombol All ──
gui.BAll.MouseButton1Click:Connect(function()
    if #myModels == 0 then doScan() end
    gui.Log("── All ──", Color3.fromRGB(50, 50, 70))
    gui.BAll.Text = "Running..."
    for _, m in ipairs(myModels) do
        gui.Log("▶ " .. m.Name, Color3.fromRGB(220, 150, 80))
        act.power(m)
        rWait(0.3, 0.5)
        act.knob(m)
        rWait(0.2, 0.4)
    end
    gui.BAll.Text = "▶  Jalankan Semua"
    gui.Log("✓ Done!", Color3.fromRGB(100, 220, 100))
end)

-- Auto-detect alat baru yang di-spawn
workspace.DescendantAdded:Connect(function(v)
    rWait(0.8, 1.2)
    if v:IsA("Model") and scan.isAudio(v) and scan.isMine(v) then
        for _, m in ipairs(myModels) do
            if m == v then return end
        end
        table.insert(myModels, v)
        gui.Counter.Text = "Alat: " .. #myModels .. "  |  " .. me.Name
        gui.Log("+ " .. v.Name, Color3.fromRGB(180, 220, 100))
    end
end)

-- RightAlt = sembunyikan/tampilkan GUI
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        gui.Win.Visible = not gui.Win.Visible
    end
end)

-- Start
task.wait(2)
gui.Log("v" .. cfg.version .. " ready | RightAlt=hide", Color3.fromRGB(100, 100, 140))
doScan()
