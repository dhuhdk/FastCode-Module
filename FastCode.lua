local ConnectionManager = loadstring(game:HttpGet:("https://raw.githubusercontent.com/dhuhdk/FastCode-Module/refs/heads/main/ConnectionManager.lua?token=GHSAT0AAAAAAEA5YTEPDE7W5EPZE5UQJ34S2R5NSZQ"))()

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
    assert(type(Name) == "string", "Arg must be an string value.")
    if FastCode.ConnectionManager[Name] then error("There was an avail storage name: " .. Name) end
    local NewStorage = ConnectionManager.new(Name)
    FastCode.ConnectionManager[Name] = NewStorage
    return NewStorage
end


local RawContextKeymap = {
    Player = {"Plr", "Player", "plr", "player", "p", "P"};
    Character = {"Char", "Character", "char", "character", "c", "C"};
    Humanoid = {"Hum", "Humanoid", "hum", "humanoid", "h", "H"};
    HumanoidRootPart = {"Root", "HumanoidRootPart", "root", "humanoidrootpart", "humanoidRootPart", "r", "R"};
    Backpack = {"Backpack", "backpack", "b", "B"};
    PlayerGui = {"PlrGui", "PlayerGui", "plrgui", "playergui", "plrGui", "playerGui", "pg", "PG", "Pg", "pG"};
    PlayerScripts = {"PlrScript", "PlayerScript", "plrscript", "playerscript", "plrScript", "playerScript", "PlrScripts", "PlayerScripts", "plrscripts", "playerscripts", "plrScripts", "playerScripts", "ps", "PS", "Ps", "pS"};
    Animator = {"Animator", "animator", "a", "A"};
}
local ContextKeymap = {}
for k, v in pairs(RawContextKeymap) do
    for i, K in ipairs(v) do
        ContextKeymap[K] = k
    end
end
local IsSystemUpdating = false
function FastCode:GetPlayerContext(PlayerName)
    if not getmetatable(self) then
        setmetatable(self, {
            __index = function(T, Key)
                local CanonicalKey = ContextKeymap[Key] or Key
                return rawget(T, CanonicalKey)
            end,
            __newindex = function(T, Key, Value)
                local CanonicalKey = ContextKeymap[Key] or Key
                if not IsSystemUpdating then 
                    rawset(T, CanonicalKey, rawget(T, CanonicalKey))
                else
                    rawset(T, CanonicalKey, Value)
                end
            end
        })
    end
    local Players = game.Players
    IsSystemUpdating = true
    if PlayerName then
        self.Player = IsPlayerAvailable(PlayerName)
    else
        self.Player = Players.LocalPlayer
        self.PlayerGui = self.Player:WaitForChild("PlayerGui")
        self.PlayerScripts = self.Player:WaitForChild("PlayerScripts")
    end
    IsSystemUpdating = false
    local function UpdateContext(Char)
        IsSystemUpdating = true
        self.Character = Char
        self.Humanoid = Char:WaitForChild("Humanoid")
        self.HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")
        self.Backpack = self.Player:WaitForChild("Backpack")
        self.Animator = self.Humanoid:WaitForChild("Animator")
        IsSystemUpdating = false
    end
    local Char = self.Player.Character
    if Char then
        UpdateContext(Char)
    else
        task.spawn(function()
            Char = self.Player.CharacterAdded:Wait()
            UpdateContext(Char)
        end)
    end
    if self.CharacterAddedConnection and self.CharacterAddedConnection.Connected then self.CharacterAddedConnection:Disconnect() end
    self.CharacterAddedConnection = self.Player.CharacterAdded:Connect(UpdateContext)
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
