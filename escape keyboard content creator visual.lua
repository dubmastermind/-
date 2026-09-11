-- ============================================================
--  CONTENT CREATOR BADGE — 1:1 EXACT VISUAL MATCH
--  Separates the emoji from the text so the gradient and
--  outline only apply to the words, matching the picture perfectly.
-- ============================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
while not lp do task.wait() lp = Players.LocalPlayer end
if not lp.Character then lp.CharacterAdded:Wait() end

-- ============================================================
--  NUCLEAR SWEEP
-- ============================================================
local function nuke()
    local parents = {}
    pcall(function() table.insert(parents, game:GetService("CoreGui")) end)
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then table.insert(parents, h) end
    end
    local pg = lp:FindFirstChild("PlayerGui")
    if pg then table.insert(parents, pg) end

    for _, p in ipairs(parents) do
        for _, child in ipairs(p:GetChildren()) do
            if child.Name == "ContentCreatorBadge" then
                pcall(function() child:Destroy() end)
            end
        end
    end

    local chr = lp.Character
    if chr then
        for _, v in ipairs(chr:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name:find("ContentCreator") then
                pcall(function() v:Destroy() end)
            end
        end
    end
end
nuke() 

-- ============================================================
--  CONFIG (Matched exactly to picture)
-- ============================================================
local cfg = {
    emoji      = "🎬",
    text       = "Content Creator",
    studsAbove = 2.0, 
    gradTop    = Color3.fromRGB(247, 126, 145),
    gradBottom = Color3.fromRGB(215, 65,  95),
    outline    = Color3.fromRGB(30, 10, 15), 
}

local function pickParent()
    local list = {}
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then table.insert(list, h) end
    end
    pcall(function() table.insert(list, game:GetService("CoreGui")) end)
    local pg = lp:FindFirstChild("PlayerGui")
    if pg then table.insert(list, pg) end

    for _, p in ipairs(list) do
        local t = Instance.new("Folder")
        local ok = pcall(function() t.Parent = p end)
        if ok and t.Parent == p then
            t:Destroy()
            return p
        end
        t:Destroy()
    end
    return lp:WaitForChild("PlayerGui")
end

-- ============================================================
--  CREATE BILLBOARDGUI & LAYOUT
-- ============================================================
local parent = pickParent()

local bg = Instance.new("BillboardGui")
bg.Name = "ContentCreatorBadge"
bg.ResetOnSpawn = false
bg.AlwaysOnTop = true
bg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
-- Made slightly wider to fit both elements side-by-side comfortably
bg.Size = UDim2.new(7.5, 0, 1.2, 0)
bg.StudsOffset = Vector3.new(0, cfg.studsAbove, 0)
bg.Parent = parent

-- Container to hold Emoji and Text next to each other
local container = Instance.new("Frame")
container.Name = "Container"
container.BackgroundTransparency = 1
container.Size = UDim2.new(1, 0, 1, 0)
container.Parent = bg

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0.02, 0) -- Tiny gap between emoji and text like the picture
layout.Parent = container

-- ============================================================
--  EMOJI LABEL (No outline, no gradient)
-- ============================================================
local emojiLabel = Instance.new("TextLabel")
emojiLabel.Name = "Emoji"
emojiLabel.BackgroundTransparency = 1
emojiLabel.Size = UDim2.new(0.12, 0, 0.85, 0)
emojiLabel.Text = cfg.emoji
emojiLabel.TextScaled = true
emojiLabel.BackgroundTransparency = 1
emojiLabel.Parent = container

-- ============================================================
--  TEXT LABEL (With outline and gradient)
-- ============================================================
local textLabel = Instance.new("TextLabel")
textLabel.Name = "Text"
textLabel.BackgroundTransparency = 1
textLabel.Size = UDim2.new(0.86, 0, 1, 0)
textLabel.Text = cfg.text
textLabel.TextScaled = true
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Center
textLabel.Font = Enum.Font.FredokaOne
textLabel.Parent = container

-- Thick outline applied ONLY to the text
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3.5 
stroke.Color = cfg.outline
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Parent = textLabel

-- Gradient applied ONLY to the text
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, cfg.gradTop),
    ColorSequenceKeypoint.new(1, cfg.gradBottom),
})
grad.Rotation = 90
grad.Parent = textLabel

-- ============================================================
--  ATTACHMENT & RESPAWN TRACKING
-- ============================================================
local function attachToCharacter(char)
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if head then
        bg.Adornee = head
    end
end

lp.CharacterAdded:Connect(attachToCharacter)
if lp.Character then attachToCharacter(lp.Character) end

print("[badge] loaded — 1:1 exact visual match applied")