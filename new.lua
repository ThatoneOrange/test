local autofarm = {}
function autofarm.serverhop()
    local queueonteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queueonteleport then
    queueonteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ThatoneOrange/test/main/new.lua'))()")
end
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if httprequest then
    local servers = {}
    local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)})
    local body = game:GetService("HttpService"):JSONDecode(req.Body)
    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing >= 10 and v.id ~= game.JobId then
                table.insert(servers, 1, v.id)
            end 
        end
    end
    if #servers > 0 then
        print("tried serverhopping")
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game:GetService("Players").LocalPlayer)
    else
        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing >= 10 and v.id ~= game.JobId then
                    table.insert(servers, 1, v.id)
                end 
            end
        end
        if #servers > 0 then
            print("tried serverhopping")
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game:GetService("Players").LocalPlayer)
        end
    end
end
end
local BankInteractions = game:GetService("Workspace"):WaitForChild('BankInteractions')
local Plant = workspace:WaitForChild('Plant')
local C4prompt = Plant:WaitForChild('ProximityPrompt')
local Storage = game:GetService('ReplicatedStorage')
local Robbery = Storage:WaitForChild('BankRobbery')
local Cooldown = Storage:WaitForChild('BankCooldown')
local ATM = Storage:WaitForChild('ATM')
local Player = game:GetService('Players').LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local humanoidrootpart = Char:WaitForChild('HumanoidRootPart')
local Humanoid = Char:WaitForChild('Humanoid')
local stored = Player:WaitForChild('stored')
local Money = stored:WaitForChild('Money')
local Bank = stored:WaitForChild('Bank')
local Camera = workspace.CurrentCamera
if Robbery.Value == true or Cooldown.Value > 0 then autofarm.serverhop() return end
if #game:GetService('Players'):GetPlayers() < 10 then
    autofarm.serverhop()
    return
end
if Camera then
    local TextNew = Drawing.new('Text')
    TextNew.Visible = true
    TextNew.Transparency = 1
    TextNew.Text = "teamo_dev auto-bank streetlife (cash: "..Money.Value..', bank: '..Bank.Value..')'
    TextNew.Center = true
    TextNew.Outline = true
    TextNew.OutlineColor = Color3.fromRGB(0, 0, 0)
    TextNew.Size = 20
    TextNew.Font = 2
    TextNew.Color = Color3.fromRGB(255, 255, 255)
    TextNew.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end
Humanoid:UnequipTools()
if not Player.Backpack:FindFirstChild('C4') then
    if Money.Value >= 2000 then
        local args = {
            [1] = "C4",
            [2] = 2000
        }
        Storage.Buy:FireServer(unpack(args))
    else
        if Bank.Value >= 2000 then
            ATM:FireServer('Withdraw', 2000)
            local args = {
                [1] = "C4",
                [2] = 2000
            } 
            Storage.Buy:FireServer(unpack(args))
        else
            Player:Kick('You need atleast 2k to start farming lol')
            return
        end
    end
end

repeat
    wait()
until Player.Backpack:FindFirstChild('C4')
local C4 = Player.Backpack.C4
if C4 then
    humanoidrootpart.CFrame = Plant.CFrame
    Humanoid:EquipTool(C4)
    C4prompt.HoldDuration = -1
    fireproximityprompt(C4prompt, 1)
    Storage.C4:FireServer(game.Players.LocalPlayer.Character.C4, 'COMPLETED', workspace.Plant)
    repeat
        wait()
        print('waiting for vault..')
    until Robbery.Value == true

local bag = 0

while true do
    wait()
    local pile = nil
    for i,v in pairs(BankInteractions:GetChildren()) do
        if v:IsA('MeshPart') or v:IsA('UnionOperation') then
            for a,b in pairs(v:GetDescendants()) do
                if b:IsA('MeshPart') and b.Transparency < 1 then
                    pile = v
                end
            end
        end
    end
    if not pile then return end
    humanoidrootpart.CFrame = pile.CFrame
    pile.ProximityPrompt.HoldDuration = -1
    pile.ProximityPrompt.RequiresLineOfSight = false
    wait(.25)
    fireproximityprompt(pile.ProximityPrompt, 1)
    wait(.25)
    bag += 1
    if bag >= 5 then
        break
    end
end
    print('done')
    task.wait()
    Player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["Loot Buyer"].HumanoidRootPart.CFrame
    game:GetService("Workspace")["Loot Buyer"].Handler.RequiresLineOfSight = false
    task.wait(.25)
    fireproximityprompt(game:GetService("Workspace")["Loot Buyer"].Handler, 1)
    task.wait(.25)
    autofarm.serverhop()
end
