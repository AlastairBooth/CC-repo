local folder = "ab"
local marketplace_subfolder = "marketplaces"
local program_subfolder = "programs"

local function isEmpty(s)
    return s == nil or s == ''
end

-->> downloads program from id
local function downloadProgram(id)
    for f in fs.list(folder .. "/" .. marketplace_subfolder) do
        local marketplaceUrl = f.readAll()
        local response = http.get(marketplaceUrl)
        local j = nil
        if response then
			local sResponse = response.readAll()
			response.close()
            j = json.decode(sResponse)
        else
            print("ERROR - no response from marketplace URL: " .. marketplaceUrl)
            return false
        end
        for p in j.programs do
            if p.id == id then
                if not isEmpty(p.paste) then
                    shell.run("pastebin", "get", p.paste, folder .. "/" .. program_subfolder .. "/" .. p.id)
                    return true
                else if not isEmpty(p.url) then
                    local response = http.get(url)
                    if response then
                        local sResponse = response.readAll()
                        response.close()
                        local file = fs.open(folder .. "/" .. program_subfolder .. "/" .. p.id, "w")
                        file.write(url)
			            file.flush()
                        file.close()
                        return true
                    else
                        print("ERROR - no response from URL: " .. p.url)
                        return false
                    end
                else
                    print("ERROR - no download location found for: " .. p.name)
                    return false
                end
            end
        end
    end
end

local function getAvailableProgramIDs()
    local r = {}
    local i = 1
    for f in fs.list(folder .. "/" .. marketplace_subfolder) do
        local j = json.decodeFromFile(f)
        for p in j.programs do
            r[i] = p.id
            i = i + 1
        end
    end
    return r
end

local function getProgramIDs()
    return fs.list(folder .. "/" .. program_subfolder)
end

local function removeProgram(id)
    fs.delete(folder .. "/" .. program_subfolder .. "/" .. id)
end

local function updateProgram(id)
    removeProgram(folder, id)
    local r = downloadProgram(folder, id)
    return r
end

local function updateAllPrograms()
    for i in getProgramIDs(folder) do
        local r = updateProgram(folder, i)
        if not r then
            return false
        end
    end
    return true
end