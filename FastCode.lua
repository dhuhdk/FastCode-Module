local ConnectionManager = loadstring(HttpGet:("https://raw.githubusercontent.com/dhuhdk/FastCode-Module/refs/heads/main/ConnectionManager.lua?token=GHSAT0AAAAAAEA5YTEPDE7W5EPZE5UQJ34S2R5NSZQ"))()

local FastCode = {}
FastCode.ConnectionManager = {}
FastCode.__index = FastCode

function FastCode.new()
    local self = setmetatable({}, FastCode)
    return self
end

local function IsPlayerAvailable(PlayerName)
    local Plrs = game.Players
    local Table = {}
    for I, P in pairs(Plrs:GetPlayers()) do
        local PName = P.Name
        if string.lower(PlayerName) == string.lower(string.sub(P.Name, 1, #PlayerName)) then table.insert(Table, P) end
    end
    if #Table == 1 then
        return Table[1]
    else error("Cannot find the player that start by " .. PlayerName .. ".") end
end

function FastCode.ConnectionManager.new(Name)
    assert(type(Name) ~= "string", "Arg must be an string value.")
    if FastCode.ConnectionManager[Name] then error("There was an avail storage name: " .. Name)
    local NewStorage = ConnectionManager.new(Name)
    FastCode.ConnectionManager[Name] = NewStorage
    return NewStorage
end

function FastCode:GetPlayerContext(PlayerName)
    local Plrs = game.Players
    local Plr, Char, Hum, Root, Backpack, PlrGui, PlrScript, Animator
    if PlayerName then
        Plr = IsPlayerAvailable(PlayerName)
    else
        Plr = Plrs.LocalPlayer
        PlrGui = Plr:WaitForChild("PlayerGui")
        PlrScript = Plr:WaitForChild("PlayerScripts")
    end

    Char = Plr.Character or Plr.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    Root = Char:WaitForChild("HumanoidRootPart")
    Backpack = Plr:WaitForChild("Backpack")
    Animator = Hum:WaitForChild("Animator")
    self.Plr = Plr; self.Char = Char; self.Hum = Hum; self.Root = Root; self.Backpack = Backpack; self.Animator = Animator
    Plr.CharacterAdded:Connect(function(Char)
        local NChar = Char
        local NHum = NChar:WaitForChild("Humanoid")
        local NRoot = NChar:WaitForChild("HumanoidRootPart")
        local NBackpack = Plr:WaitForChild("Backpack")
        local NAnimator = NHum:WaitForChild("Animator")
        self.Char = NChar; self.Hum = NHum; self.Root = NRoot; self.Backpack = NBackpack; self.Animator = NAnimator
    end)
    return self
end

function FastCode:GetService()
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local VIM = game:GetService("VirtualInputManager")
    local TS = game:GetService("TweenService")
    local TCS = game:GetService("TextChatService")
    local CAS = game:GetService("ContextActionService")
    self.RS = RS; self.UIS = UIS; self.VIM = VIM; self.TS = TS; self.TCS = TCS; self.CAS = CAS
    return self
end

function FastCode:InfiniteYield()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
end

function FastCode.Track(Animator, AnimationId)
    if typeof(Animator) ~= "Instance" or not Animator:IsA("Animator") then error("Arg1 need to be an animator instance.") end
    if type(AnimationId) ~= "string" then error("AnimationId must be a string value.") end
    local Animation = Instance.new("Animation")
    Animation.AnimationId = AnimationId
    local Track = Animator:LoadAnimation(Animation)
    return Track, Animation
end

return FastCode
