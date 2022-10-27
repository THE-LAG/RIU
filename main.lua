repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD",1000000):WaitForChild("Screen",10).LoadingScreen.Visible == false
wait()

loadstring(game:HttpGetAsync("https://pastebin.com/raw/tVb04TfW"))()
math.randomseed(os.time())

--inizialaze some shitty variables and table and piss and vaccum
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local spawnedItem = game:GetService("Workspace").Map.Items.SpawnedItems
local itemToSearch = {}
local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

local settings = {
    r = 255, 
    g = 196, 
    b = 0,
    size = 2,
    border = 1
}

local function random(length)
    if length > 0 then
        return random(length - 1) .. charset:sub(math.random(1, #charset), 1)
    else
        return ""
    end
end

local espName = random(math.random(4,128))

local function addToSet(set, key)
    set[key] = true
end

local function removeFromSet(set, key)
    set[key] = nil
end

local function setContains(set, key)
    return set[key] ~= nil
end

local function string_starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

local function Touch(PART)
    firetouchinterest(Player.Character.HumanoidRootPart,PART,1)
    wait()
    firetouchinterest(Player.Character.HumanoidRootPart,PART,0)
end

local function Click(obj,type)
    local con = getconnections(obj[type])
    for _,v in ipairs(con) do
        v:Fire()
    end

    local con = getconnections(obj[type])
    for _,v in ipairs(con) do
        v:Fire()
    end
    wait()
end

local function drawEsp()
    if not (_G.LAG_Esp) then
        return
    end
    for k, child in pairs(spawnedItem:GetChildren()) do
        task.wait()
        if child:FindFirstChild(espName) then
            if setContains(itemToSearch,child.Name) == false then
                child:FindFirstChild(espName):Destroy()
            end
            continue
        end

        if setContains(itemToSearch,child.Name)then

            local gui = Instance.new("BillboardGui")
            local textlabel = Instance.new("TextLabel")
    
            gui.AlwaysOnTop = true
            gui.Name = espName
            gui.Size = UDim2.new(settings.size,0,settings.size,0)
            gui.Parent = child
            gui.MaxDistance = math.huge
    
            textlabel.BackgroundTransparency = 1
            textlabel.Text = child.Name
            textlabel.Size = UDim2.new(1,0,1,0)
            textlabel.TextColor3 = Color3.fromRGB(settings.r, settings.g, settings.b) 
            textlabel.TextStrokeTransparency = settings.border
            textlabel.Parent = gui
    
            if child.ClassName == "Model" then
                
                gui.Adornee = child.Handle
    
            else
                gui.Adornee = child
            end
        end
        
    end
end

Player.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/THE-LAG/RIU/main/main.lua'))()")

	end
end)

RunService.RenderStepped:Connect(function(step)
    task.wait()
	if not (_G.LAG_Esp) then
        for k, child in pairs(spawnedItem:GetChildren()) do
            if child:FindFirstChild(espName) then
                child:FindFirstChild(espName):Destroy()
            end
        end
    else
        drawEsp()
    end
end)


create("RIU", "P")



newTab("Main")

newToggle("Esp", function(bool) _G.LAG_Esp = bool; end)

newText("------ Server ------")

newButton("Server Hop", function()
    if httprequest then
		local servers = {}
		local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)})
		local body = HttpService:JSONDecode(req.Body)
		if body and body.data then
			for i, v in next, body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, 1, v.id)
				end 
			end
		end
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Player)
		else
			return print("Serverhop", "Couldn't find a server.")
		end
	end
end)



newTab("Item")

newToggle("Coin", function(bool)

    if bool then
        addToSet(itemToSearch, "Coin")
    else
        removeFromSet(itemToSearch, "Coin")
    end

end)

local avviableitem : Folder = game:GetService("ReplicatedStorage").Modules.Items

for _, v in pairs(avviableitem:GetChildren()) do
    newToggle(v.Name, function(bool)

        if bool then
            addToSet(itemToSearch, v.Name)
        else
            removeFromSet(itemToSearch, v.Name)
        end
    
    end)
end



newTab("Settings")

newText("------Text Color------")

newBox("R",function (value)
    settings.r = value
end)

newBox("G",function(value)
    settings.g = value
end)

newBox("B",function(value)
    settings.b = value
end)


newText("------Text Size------")

newBox("B",function(value)
    if tonumber(value) == nil then
        value = 1
    end
    settings.size = value
end)
