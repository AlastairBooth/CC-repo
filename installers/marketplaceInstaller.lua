local json_url = ...
local folder = "ab"
local api_subdirectory = "apis"

if not fs.exists(folder) then
    fs.makeDir(folder)
end
if not fs.exists(folder .. "/" .. api_subdirectory) then
    fs.makeDir(folder .. "/" .. api_subdirectory)
end

local function downloadAPI(url, filePath)
    if string.len(url) < 9 then
        --pastebin
        shell.run("pastebin", "get", url, filePath)
        return true
    else
        --raw url (i.e. github)
        local response = http.get(url)

        if response then
            local sResponse = response.readAll()
			response.close()
            local file = fs.open(filePath, "w")
            file.write(sResponse)
            file.flush()
            file.close()
            return true
        else
            return false
        end
    end
end

local apiDownload = downloadAPI("4nRg9CHU", folder .. "/" .. api_subdirectory .. "/json")
if apiDownload then
    print("json API downloaded..")
else
    print("json API download FAILED")
    return
end
os.loadAPI(folder .. "/" .. api_subdirectory .. "/json")

local function downloadMarketplace(url, filePath)
    if string.len(url) < 9 then
        --pastebin
        shell.run("pastebin", "get", url, filePath)
        return true
    else
        --raw url (i.e. github)
        local response = http.get(url)

        if response then

			local sResponse = response.readAll()
			response.close()
            local json_obj = json.decode(sResponse)
            local marketplace_name = json_obj.name
            -- are you sure overwrite check
    
            local file = fs.open(filePath .. "/" .. marketplace_name, "w")
            file.write(url)
			file.flush()
            file.close()
            return true
        else
            return false
        end
    end
end

local apiDownload = downloadAPI("https://raw.githubusercontent.com/AlastairBooth/CC-repo/main/apis/marketplace.lua", folder .. "/" .. api_subdirectory .. "/marketplace")
if apiDownload then
    print("marketplace API downloaded..")
else
    print("marketplace API download FAILED")
    return
end

local marketPlaceDownload = downloadMarketplace(json_url, folder .. "/marketplaces")
if marketPlaceDownload then
    print("marketplace download..")
else
    print("marketplace download FAILED")
    return
end

print("SUCCESS")