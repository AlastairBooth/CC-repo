-->> downloads a file from a raw url source to a file path
local function download(url, filePath)
    if url.len() < 9 then
        --pastebin
        local response = http.get("http://pastebin.com/raw.php?i=" .. url)
    else
        --raw url (i.e. github)
        local response = http.get(url)
    end

    if response then
        local file = fs.open(filePath, "w")
        file.write(response)
        file.close()
        return true
    else
        return false
    end
end

-->> gets the program json from a string id
local function getProgram(id)

end

-->> downloads program from id
local function downloadProgram(id)

end

-->> removes downloaded program from id
local function removeProgram(id)

end

-->> gets the latest marketplace json
local function updateMarketplace()

end

-->> gets the latest program from id
local function updateProgram(id)

end

-->> gets all the latest programs (does not update the marketplace)
local function updateAllPrograms()

end