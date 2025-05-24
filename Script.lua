local playerfarm
for i,v in ipairs(workspace.Farm:GetChildren()) do
    local owner = v:FindFirstChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner").Value
    if owner == game:GetService("Players").LocalPlayer.Name then
        playerfarm = v:FindFirstChild("Important"):FindFirstChild("Plant_Locations")
    end
end
local port = {playerfarm:GetChildren()[1], playerfarm:GetChildren()[2]}
local plantremote = game.ReplicatedStorage.GameEvents.Plant_RE
local sellremote = game.ReplicatedStorage.GameEvents.Sell_Inventory
local selling = false

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Grow A Garden By PhaBieZ ",
    SubTitle = "Youtube: PhaBieZ",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "briefcase" }),
    Buy = Window:AddTab({ Title = "Auto Buy", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Grow A Garden By PhaBieZ",
        Content = "Script Loaded success",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

--local Section = Tabs.Main:AddSection("Section")
local Autocollect = Tabs.AutoFarm:AddToggle("Autocollect", {Title = "เก็บผลไม้อัติโนมัติ", Default = false })
	
	-- เริ่มสคริปตรงนี้
local uiToggleSection = Tabs.Buy:AddSection("Buy")

local Seed = Tabs.Buy:AddDropdown("Seed", {
    Title = "Seed",
    Values = {  
                "Carrot", 
                "Strawberry", 
                "Blueberry", 
                "Orange Tulip", 
                "Tomato",
                "Corn",
                "Daffodil",
                "Watermelon",
                "Pumpkin",
                "Apple",
                "Bamboo",
                "Coconut",
                "Cactus",
                "Dragon Fruit",
                "Mango",
                "Grape",
                "Mushroom",
                "Pepper",
                "Cacao",
                "Beanstalk"
                },
    Multi = false,
    Default = 1,
})
local AutobuySeed = Tabs.Buy:AddToggle("AutobuySeed", {Title = "Auto Buy Seed", Default = false })

local Gear = Tabs.Buy:AddDropdown("Gear", {
    Title = "Gear",
    Values = {
                "Watering Can", 
                "Trowel", 
                "Basic Sprinkler", 
                "Advanced Sprinkler", 
                "Godly Sprinkler", 
                "Master Sprinkler"
        
            },
    Multi = false,
    Default = 1,
})
local AutobuyGear = Tabs.Buy:AddToggle("AutobuyGear", {Title = "Auto Buy Gear", Default = false })


-- Gear Shop Toggle
local GearToggle = Tabs.Buy:AddToggle("GearShopToggle", {
    Title = "เปิด/ปิด Gear Shop",
    Default = false
})
GearToggle:OnChanged(function(value)
    local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Gear_Shop")
    if gui then
        gui.Enabled = value
    end
end)

-- Seed Shop Toggle
local SeedToggle = Tabs.Buy:AddToggle("SeedShopToggle", {
    Title = "เปิด/ปิด Seed Shop",
    Default = false
})
SeedToggle:OnChanged(function(value)
    local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Seed_Shop")
    if gui then
        gui.Enabled = value
    end
end)

-- Event Shop Toggle
local EventToggle = Tabs.Buy:AddToggle("EventShopToggle", {
    Title = "เปิด/ปิด Event Shop",
    Default = false
})
EventToggle:OnChanged(function(value)
    local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("EventShop_UI")
    if gui then
        gui.Enabled = value
    end
end)

	
    --local sectiontoggle = Section:AddToggle("MyToggle", {Title = "Toggle", Default = false })
    --localsectiontoggle:OnChanged(function()
        --localsectiontoggleif Options.MyToggle.Value then
            --print(true)
       -- else
           -- print(false)
      --  end
  --  end)
   -- Options.MyToggle:SetValue(false)
end
Window:SelectTab(1) -- select default tab

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("foldername")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)


-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
SaveManager:SetFolder("ScriptHub/specific-game")

SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Ui Script",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

local pointport = 1

local function collect()
    for i,v in ipairs(port[1].Parent.Parent:FindFirstChild("Plants_Physical"):GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if v.Enabled then
                fireproximityprompt(v)
            end
        end
    end
end
function TP(Position)
    local distance = (Position.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    speed = 200
    game:GetService("TweenService"):Create(
    game.Players.LocalPlayer.Character.HumanoidRootPart, 
    TweenInfo.new(distance/speed, Enum.EasingStyle.Linear),
    {CFrame = Position}
    ):Play()
    if pointport == 6 then
        pointport = 1
    else
        pointport = pointport + 1
    end
    wait(distance/speed + .3)
end

_G.a = true
while _G.a do wait()
    if Options.AutobuySeed.Value then
        game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(Options.Seed.Value)
    end
    
    if Options.AutobuyGear.Value then
    game:GetService("ReplicatedStorage").GameEvents.BuyGearStock:FireServer(Options.Gear.Value)
    end

    if Options.Autocollect.Value then
        if not selling then
            if pointport == 1 then
                TP(CFrame.new(port[1].Position + Vector3.new(0,3,20)))
            elseif pointport == 2 then
                TP(CFrame.new(port[1].Position))
            elseif pointport == 3 then
                TP(CFrame.new(port[1].Position + Vector3.new(0,3,-20)))
            elseif pointport == 4 then
                TP(CFrame.new(port[2].Position + Vector3.new(0,3,20)))
            elseif pointport == 5 then
                TP(CFrame.new(port[2].Position))
            elseif pointport == 6 then
                TP(CFrame.new(port[2].Position + Vector3.new(0,3,-20)))
            end
            collect()
        end
    end
    
    
end
