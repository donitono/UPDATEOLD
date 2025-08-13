--[[
Weather Purchase Remote Logger
--------------------------------------------------
Tujuan:
  Menangkap format argumen remote (RF/PurchaseWeatherEvent) dari tombol Weather Machine.
Cara Pakai:
  1. Jalankan script ini SENDIRI lebih dulu (atau require) sebelum kamu menekan tombol cuaca.
  2. Buka Weather Machine di game lalu klik masing-masing opsi (Cloudy, Wind, Snow, Storm, Shark Hunt).
  3. Lihat output di console (F9). Akan muncul blok: ==[WeatherPurchase Capture]== ...
  4. Salin semua hasil dan kirim / gunakan untuk menulis fungsi auto beli.
  5. Kalau sudah cukup, panggil _G.WeatherLogger.Stop() atau re-execute tanpa script ini untuk unhook.

Fitur:
  - Pretty print argumen (mendalam untuk table bersarang).
  - Simpan semua capture pada _G.WeatherLogger.Captures (array).
  - Opsi berhenti otomatis setelah n capture.
  - Aman: tidak override hook jika sudah ada logger aktif (idempotent).
  - Fallback bila environment exploit tidak menyediakan getrawmetatable.
--------------------------------------------------
Konfigurasi Cepat:
  _G.WeatherLoggerConfig = {
      targetSubstring = "PurchaseWeatherEvent", -- ubah jika nama berbeda
      autoStopAfter = 0,   -- 0 = tidak otomatis berhenti. Misal set 5 untuk stop setelah 5 capture
      printArgs = true,    -- cetak detail argumen
      printReturn = true,  -- cetak nilai return (InvokeServer)
      includeStack = false -- set true jika mau trace (sedikit lebih berat)
  }
  (Set sebelum script ini dijalankan jika mau override)
--------------------------------------------------
]]

-- Hindari duplikasi
if _G.WeatherLogger and _G.WeatherLogger.Active then
    warn("[WeatherPurchaseLogger] Sudah aktif. Abaikan duplikat.")
    return
end

local defaultConfig = {
    targetSubstring = "PurchaseWeatherEvent",
    autoStopAfter = 0,
    printArgs = true,
    printReturn = true,
    includeStack = false,
}

local cfg = _G.WeatherLoggerConfig or {}
for k,v in pairs(defaultConfig) do
    if cfg[k] == nil then cfg[k] = v end
end
_G.WeatherLoggerConfig = cfg

local function deepToString(v, depth, visited)
    depth = depth or 0
    visited = visited or {}
    local t = typeof(v)
    if t ~= "table" then
        if t == "string" then
            return string.format("%q", v)
        else
            return tostring(v)
        end
    end
    if visited[v] then
        return "<recursion>"
    end
    visited[v] = true
    local indent = string.rep("  ", depth)
    local out = {"{"}
    for k,val in pairs(v) do
        table.insert(out, string.format("\n%s  [%s] = %s", indent, type(k)=="string" and k or tostring(k), deepToString(val, depth+1, visited)))
    end
    table.insert(out, "\n"..indent.."}")
    return table.concat(out, "")
end

local function captureBlock(remote, method, args, retValue, elapsed)
    if cfg.printArgs then
        print(("==[WeatherPurchase Capture]== Remote=%s Method=%s ArgCount=%d Time=%.4fs"):format(remote.Name, method, #args, elapsed or 0))
        for i,a in ipairs(args) do
            print(("  Arg[%d] (%s): %s"):format(i, typeof(a), deepToString(a)))
        end
    else
        print(("==[WeatherPurchase Capture]== Remote=%s (%d args)"):format(remote.Name, #args))
    end
    if cfg.printReturn and retValue ~= nil then
        print("  Return:", deepToString(retValue))
    end
    if cfg.includeStack then
        print(debug.traceback("[StackTrace]", 2))
    end
    print("==[End Capture]==")
end

_G.WeatherLogger = {
    Active = true,
    Captures = {},
    Stop = function()
        if not _G.WeatherLogger.Active then return end
        local mt = getrawmetatable(game)
        if mt and _G.WeatherLogger._oldNamecall then
            setreadonly(mt,false)
            mt.__namecall = _G.WeatherLogger._oldNamecall
            setreadonly(mt,true)
            print("[WeatherPurchaseLogger] Unhooked __namecall")
        end
        _G.WeatherLogger.Active = false
    end
}

local function hookNamecall()
    if not getrawmetatable then
        warn("[WeatherPurchaseLogger] getrawmetatable tidak tersedia di environment ini.")
        return
    end
    local mt = getrawmetatable(game)
    if not mt then
        warn("[WeatherPurchaseLogger] Metatable game tidak ditemukan.")
        return
    end
    local oldNamecall = mt.__namecall
    _G.WeatherLogger._oldNamecall = oldNamecall

    setreadonly(mt,false)
    mt.__namecall = function(self, ...)
        local method = getnamecallmethod and getnamecallmethod() or "?"
        local start = tick()
        local args = {...}
        local isTarget = false
        if typeof(self)=="Instance" and (method == "InvokeServer" or method == "FireServer") then
            local n = self.Name
            if n:lower():find(cfg.targetSubstring:lower()) then
                isTarget = true
            end
        end
        local ret
        local ok,err = pcall(function()
            ret = oldNamecall(self, table.unpack(args))
        end)
        local elapsed = tick() - start
        if not ok then
            warn("[WeatherPurchaseLogger] Error forwarding call:", err)
        end
        if isTarget and _G.WeatherLogger.Active then
            table.insert(_G.WeatherLogger.Captures, {
                remote = self,
                method = method,
                args = args,
                returnValue = ret,
                time = elapsed,
                timestamp = os.time()
            })
            captureBlock(self, method, args, ret, elapsed)
            if cfg.autoStopAfter > 0 and #_G.WeatherLogger.Captures >= cfg.autoStopAfter then
                print("[WeatherPurchaseLogger] autoStopAfter tercapai ("..cfg.autoStopAfter..")")
                _G.WeatherLogger.Stop()
            end
        end
        return ret
    end
    setreadonly(mt,true)
    print("[WeatherPurchaseLogger] Hook aktif. Target substring=", cfg.targetSubstring)
end

hookNamecall()

print("[WeatherPurchaseLogger] Siap. Klik semua tombol Weather Machine untuk capture.")
print("[WeatherPurchaseLogger] Gunakan _G.WeatherLogger.Captures untuk melihat data yang terkumpul.")
print("[WeatherPurchaseLogger] Panggil _G.WeatherLogger.Stop() untuk berhenti.")

-- =============================================================
-- In-Game UI (Optional) - Mempermudah melihat & copy capture
-- =============================================================
do
    if _G.WeatherLogger and _G.WeatherLogger.Active and not _G.WeatherLoggerUI then
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local success,root = pcall(function()
            return CoreGui
        end)
        if not success or not root then
            warn("[WeatherPurchaseLogger][UI] CoreGui tidak bisa diakses.")
            return
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "WeatherPurchaseLoggerUI"
        gui.ResetOnSpawn = false
        gui.Parent = root

        local floatBtn = Instance.new("TextButton")
        floatBtn.Name = "Toggle"
        floatBtn.Size = UDim2.new(0,52,0,52)
        floatBtn.Position = UDim2.new(1,-70,0,120)
        floatBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
        floatBtn.TextColor3 = Color3.fromRGB(255,255,255)
        floatBtn.Font = Enum.Font.SourceSansBold
        floatBtn.TextSize = 20
        floatBtn.Text = "☁"
        floatBtn.Parent = gui
        Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0,26)

        -- Main window
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(0,520,0,340)
        main.Position = UDim2.new(0.5,-260,0.5,-170)
        main.BackgroundColor3 = Color3.fromRGB(30,30,40)
        main.Visible = false
        main.Active = true
        main.Draggable = true
        main.Parent = gui
        Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1,-10,0,32)
        header.Position = UDim2.new(0,5,0,5)
        header.BackgroundTransparency = 1
        header.TextColor3 = Color3.fromRGB(255,255,255)
        header.Font = Enum.Font.SourceSansBold
        header.TextSize = 16
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Text = "🌦 Weather Purchase Logger"
        header.Parent = main

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0,28,0,28)
        closeBtn.Position = UDim2.new(1,-33,0,7)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
        closeBtn.Text = "✖"
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.TextSize = 14
        closeBtn.TextColor3 = Color3.new(1,1,1)
        closeBtn.Parent = main
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

        local listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(0,210,1,-90)
        listFrame.Position = UDim2.new(0,10,0,45)
        listFrame.BackgroundColor3 = Color3.fromRGB(40,40,55)
        listFrame.Parent = main
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,6)

        local scroller = Instance.new("ScrollingFrame")
        scroller.Size = UDim2.new(1,-10,1,-10)
        scroller.Position = UDim2.new(0,5,0,5)
        scroller.BackgroundTransparency = 1
        scroller.ScrollBarThickness = 6
        scroller.CanvasSize = UDim2.new(0,0,0,0)
        scroller.Parent = listFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = scroller
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0,4)

        local detailFrame = Instance.new("Frame")
        detailFrame.Size = UDim2.new(1,-240,1,-90)
        detailFrame.Position = UDim2.new(0,230,0,45)
        detailFrame.BackgroundColor3 = Color3.fromRGB(40,40,55)
        detailFrame.Parent = main
        Instance.new("UICorner", detailFrame).CornerRadius = UDim.new(0,6)

        local detailText = Instance.new("TextBox")
        detailText.Size = UDim2.new(1,-10,1,-10)
        detailText.Position = UDim2.new(0,5,0,5)
        detailText.BackgroundTransparency = 1
        detailText.Font = Enum.Font.Code
        detailText.TextXAlignment = Enum.TextXAlignment.Left
        detailText.TextYAlignment = Enum.TextYAlignment.Top
        detailText.TextWrapped = false
        detailText.ClearTextOnFocus = false
        detailText.MultiLine = true
        detailText.TextSize = 13
        detailText.Text = "(Pilih capture di kiri)"
        detailText.TextColor3 = Color3.fromRGB(230,230,230)
        detailText.Parent = detailFrame

        local footer = Instance.new("Frame")
        footer.Size = UDim2.new(1,-20,0,70)
        footer.Position = UDim2.new(0,10,1,-75)
        footer.BackgroundTransparency = 1
        footer.Parent = main

        local function makeBtn(txt,color,xOrder,callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0,110,0,30)
            btn.BackgroundColor3 = color
            btn.Text = txt
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 12
            btn.Parent = footer
            btn.Position = UDim2.new(0,(xOrder-1)*115,0,5)
            btn.AutoButtonColor = true
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            return btn
        end

        local selectedIndex = nil

        local function captureToString(cap)
            if not cap then return "" end
            local buf = {}
            table.insert(buf, string.format("Remote: %s (%s)", cap.remote and cap.remote.Name or "?", cap.method or "?"))
            table.insert(buf, string.format("Time: %.4fs  Timestamp: %s", tonumber(cap.time or 0), os.date("%H:%M:%S", cap.timestamp or os.time())))
            table.insert(buf, string.format("Args (%d):", #cap.args))
            for i,a in ipairs(cap.args) do
                local ok,res = pcall(function() return deepToString(a) end)
                table.insert(buf, string.format("  [%d] %s => %s", i, typeof(a), ok and res or "<print error>"))
            end
            if cap.returnValue ~= nil then
                local ok,res = pcall(function() return deepToString(cap.returnValue) end)
                table.insert(buf, "Return:")
                table.insert(buf, "  "..(ok and res or "<print error>"))
            end
            return table.concat(buf, "\n")
        end

        local function rebuildList()
            scroller:ClearAllChildren()
            listLayout.Parent = scroller
            for i,cap in ipairs(_G.WeatherLogger.Captures) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,-4,0,28)
                btn.BackgroundColor3 = (i == selectedIndex) and Color3.fromRGB(90,140,220) or Color3.fromRGB(55,55,70)
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 12
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Text = string.format("#%d %s (%d arg) %.3fs", i, cap.remote and cap.remote.Name or "?", #cap.args, cap.time or 0)
                btn.Parent = scroller
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
                btn.MouseButton1Click:Connect(function()
                    selectedIndex = i
                    detailText.Text = captureToString(cap)
                    rebuildList()
                end)
            end
            scroller.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
        end

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroller.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
        end)

        makeBtn("Refresh", Color3.fromRGB(80,130,200), 1, function()
            rebuildList()
        end)
        makeBtn("Copy Sel", Color3.fromRGB(90,160,90), 2, function()
            if not selectedIndex then return end
            local txt = captureToString(_G.WeatherLogger.Captures[selectedIndex])
            if setclipboard then setclipboard(txt) print("[WeatherPurchaseLogger][UI] Capture #"..selectedIndex.." copied") else print(txt) end
        end)
        makeBtn("Copy All", Color3.fromRGB(120,100,200), 3, function()
            local parts = {}
            for _,cap in ipairs(_G.WeatherLogger.Captures) do
                table.insert(parts, captureToString(cap))
            end
            local all = table.concat(parts, "\n\n-----------------------------\n\n")
            if setclipboard then setclipboard(all) print("[WeatherPurchaseLogger][UI] All captures copied") else print(all) end
        end)
        makeBtn("Clear", Color3.fromRGB(190,120,70), 4, function()
            table.clear(_G.WeatherLogger.Captures)
            selectedIndex = nil
            detailText.Text = "(List kosong)"
            rebuildList()
        end)
        makeBtn("Stop", Color3.fromRGB(200,80,80), 5, function()
            _G.WeatherLogger.Stop()
            floatBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
            floatBtn.Text = "⛔"
        end)

        closeBtn.MouseButton1Click:Connect(function()
            main.Visible = false
        end)

        floatBtn.MouseButton1Click:Connect(function()
            main.Visible = not main.Visible
            if main.Visible then
                rebuildList()
            end
        end)

        _G.WeatherLoggerUI = gui
        print("[WeatherPurchaseLogger][UI] UI siap. Klik tombol ☁ untuk membuka.")
    end
end
