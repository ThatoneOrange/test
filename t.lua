local autofarm = {}
function autofarm.serverhop()
    local queueonteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queueonteleport then
    queueonteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ThatoneOrange/test/main/t.lua'))()")
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
local MarketplaceService = game:GetService('MarketplaceService')
local Robbery = Storage:WaitForChild('BankRobbery')
local Cooldown = Storage:WaitForChild('BankCooldown')
local ATM = Storage:WaitForChild('ATM')
local Player = game:GetService('Players').LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local humanoidrootpart = Char:WaitForChild('HumanoidRootPart')
local Humanoid = Char:WaitForChild('Humanoid')
local CashInBag = Char:WaitForChild('BankTotal')
local stored = Player:WaitForChild('stored')
local Money = stored:WaitForChild('Money')
local Bank = stored:WaitForChild('Bank')
if Robbery.Value == true or Cooldown.Value > 0 then autofarm.serverhop() return end
if #game:GetService('Players'):GetPlayers() < 10 then
    autofarm.serverhop()
    return
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
    until Robbery.Value == true


    local LootToGrab = 5
    if MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 815682937) == true then LootToGrab = 10 end
    print(LootToGrab)


    while true do

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
        
        repeat
            wait()
            fireproximityprompt(pile.ProximityPrompt, 1)
        until CashInBag.Value >= LootToGrab
        if CashInBag.Value >= LootToGrab then break end
    end
    print('done!')
    Player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["Loot Buyer"].HumanoidRootPart.CFrame
    game:GetService("Workspace")["Loot Buyer"].Handler.RequiresLineOfSight = false

    game:GetService("Workspace")["Loot Buyer"].Handler.PromptShown:Connect(function()
        print('function executed!')
        repeat
            wait()
            fireproximityprompt(game:GetService("Workspace")["Loot Buyer"].Handler, 1)
            print(Money.Value)
        until CashInBag.Value <= 0
    end)




    autofarm.serverhop()
end
