local folder, json_url = ...

if not fs.exists(folder) then
    fs.makeDir("mkdir", folder)
end

local function downloadAPI(url, filePath)
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

local apiDownload = downloadAPI("4nRg9CHU", folder .. "/apis/json")
if apiDownload then
    print("json API downloaded..")
else
    print("json API download FAILED")
    return
end
os.loadAPI(folder .."/apis/json")

local function downloadMarketplace(url, filePath)
    if url.len() < 9 then
        --pastebin
        local response = http.get("http://pastebin.com/raw.php?i=" .. url)
    else
        --raw url (i.e. github)
        local response = http.get(url)
    end

    if response then

        local json_obj = json.decode(response)
        local marketplace_name = json_obj.name
        -- are you sure overwrite check

        local file = fs.open(filePath .. "/" .. marketplace_name, "w")
        file.write(response)
        file.close()
        return true
    else
        return false
    end
end

local apiDownload = downloadAPI("https://raw.githubusercontent.com/AlastairBooth/CC-repo/main/apis/marketplace.lua", folder .. "/apis/marketplace")
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