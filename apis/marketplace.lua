local folder = "ab"
local marketplace_subfolder = "marketplaces"
local program_subfolder = "programs"

local function isEmpty(s)
    return s == nil or s == ''
end

-->> downloads program from id
function downloadProgram(id)
    local programs = getAvailableProgramIDs()
    for p in programs do
        if p.id == id then
            if not isEmpty(p.paste) then
                shell.run("pastebin", "get", p.paste, folder .. "/" .. program_subfolder .. "/" .. p.id)
                return true
            elseif not isEmpty(p.url) then
                local response = http.get(url)
                if response then
                    local sResponse = response.readAll()
                    response.close()
                    local file = assert(fs.open(folder .. "/" .. program_subfolder .. "/" .. p.id, "w"))
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

local function getMarketplaceJson(url)
    local response = assert(http.get(url))
    local sResponse = response.readAll()
    response.close()
    local json_obj = json.decode(sResponse)
    return json_obj
end

local function getMarketplaceJsonFromFile(filename)
    local file = assert(fs.open(filename, "r"))
    local url = file.readAll()
    file.close()
    local j = getMarketplaceJson(url)
    return j
end

function getAvailableProgramIDs()
    local r = {}
    local i = 1
    local marketplaceList = fs.list(folder .. "/" .. marketplace_subfolder)
    for _, file in ipairs(marketplaceList) do
        local j = getMarketplaceJsonFromFile(folder .. "/" .. marketplace_subfolder .. "/" .. file)
        for _, p in ipairs(j.programs) do
            r[i] = p.id
            i = i + 1
        end
    end
    return r
end

function getProgramIDs()
    return fs.list(folder .. "/" .. program_subfolder)
end

function removeProgram(id)
    fs.delete(folder .. "/" .. program_subfolder .. "/" .. id)
end

function updateProgram(id)
    removeProgram(folder, id)
    local r = downloadProgram(folder, id)
    return r
end

function updateAllPrograms()
    for i in getProgramIDs(folder) do
        local r = updateProgram(folder, i)
        if not r then
            return false
        end
    end
    return true
end