local curl = require "lcurl.safe"
local json = require "cjson.safe"


script_info = {
	["title"] = "SVIP自选通道",
	["version"] = "0.0.3",
	["description"] = "#SVIP使用 (分享+盘内下载)Powered-by:Admire",
	["color"] = "#6688CC",
}
     
function onInitTask(task, user, file)
    if task:getType() ~= TASK_TYPE_BAIDU then
        
		local BDUSS = user:getBDUSS()
		local BDS = user:getBDStoken()
		local Cookie = user:getCookie()
		local accelerate_url = "https://d.pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload"
		local url="https://d.pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload&app_id=250528&ver=4.0&vip=2".. string.gsub(string.gsub(file.dlink, "https://d.pcs.baidu.com/file/", "&path="), "?fid", "&fid")
		local header = { "User-Agent: netdisk;P2SP;2.2.60.26" }
		
		--local header = { "User-Agent: netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia" }
		--pd.messagebox(Cookie,"123")
		table.insert(header, "Cookie: BDUSS="..BDUSS)
		
		
		
		--table.insert(header, "Cookie: BDUSS=9UTDl2fjZPbGx3cVJESHd1LWU2RWpVNUZrUzZ3ajVSa09FZ244ZE9Uc0pnUVJmRVFBQUFBJCQAAAAAAQAAAAEAAAC1Vg0SZWlob3JvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAn03F4J9Nxedk")
		
		--[[local c = curl.easy {
			url = accelerate_url,
			post = 1,
			postfields = yxdata,
			httpheader = header,
			timeout = 15,
			ssl_verifyhost = 0,
			ssl_verifypeer = 0,
			proxy = pd.getProxy(),
			writefunction = function(buffer)
				data = data .. buffer
				return #buffer
			end,
		}]]--
		
		
		local data = ""
		local c = curl.easy{
			url = url,
			followlocation = 1,
			httpheader = header,
			timeout = 15,
			proxy = pd.getProxy(),
			writefunction = function(buffer)
				data = data .. buffer
				return #buffer
			end,
		}
		local _, e = c:perform()
		c:close()
		if e then
			return false
		end
		local j = json.decode(data)
		
		
		if j == nil then
			
			return false
		end
		local message = {}
		local downloadURL = ""
		for i, w in ipairs(j.urls) do
			downloadURL = w.url
			
			local d_start = string.find(downloadURL, "//") + 2
			local d_end = string.find(downloadURL, "%.") - 1
			downloadURL = string.sub(downloadURL, d_start, d_end)
			local length = string.len(downloadURL)
			if length <= 3
			then
				table.insert(message, downloadURL .. "(超推荐)")
			elseif a == 7
			then
				table.insert(message, downloadURL .. "(一般推荐)")
			elseif string.find(downloadURL, "cache") ~= nil
			then
				table.insert(message, downloadURL .. "(超推荐)")
			else
				table.insert(message, downloadURL .. "(普通)")
			end
		end
		local num = pd.choice(message, 1, "选择下载接口")
		downloadURL = j.urls[num].url
		
		
		task:setUris(downloadURL)
		task:setOptions("user-agent", "netdisk;P2SP;2.2.60.26")
		task:setIcon("icon/accelerate.png", "Powered By-Admire")
		if string.find(message[num], "推荐") == nil then
			task:setOptions("header", string.upper("r") .. "ange:bytes=4096-8191")
			task:setOptions("piece-length", "1M")
			task:setOptions("allow-piece-length-change", "true")
			task:setOptions("enable-http-pipelining", "true")
		end
		return true
		
		
	
		
    end
    if user == nil then
        task:setError(-1, "用户未登录")
		return true
	end	
	local appid = 250528
	local BDUSS = user:getBDUSS()
	local BDS = user:getBDStoken()
	local Cookie = user:getCookie()
	local header = { "User-Agent: netdisk;P2SP;2.2.60.26" }
	
	--local header = { "User-Agent: netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia" }
	
	table.insert(header, "Cookie: BDUSS="..BDUSS)
	local url = "https://pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload&ver=4.0&path="..pd.urlEncode(file.path).."&app_id="..appid
    local data = ""
	local c = curl.easy{
		url = url,
		followlocation = 1,
		httpheader = header,
		timeout = 15,
		proxy = pd.getProxy(),
		writefunction = function(buffer)
			data = data .. buffer
			return #buffer
		end,
	}
	
	
	local _, e = c:perform()
    c:close()
    if e then
        return false
    end
	

	
	local j = json.decode(data)
	if j == nil then
        return false
    end

	local message = {}
    local downloadURL = ""
    for i, w in ipairs(j.urls) do
        downloadURL = w.url
        local d_start = string.find(downloadURL, "//") + 2
        local d_end = string.find(downloadURL, "%.") - 1
        downloadURL = string.sub(downloadURL, d_start, d_end)
        local length = string.len(downloadURL)
        if length <= 3
        then
            table.insert(message, downloadURL .. "(超推荐)")
        elseif a == 7
        then
            table.insert(message, downloadURL .. "(一般推荐)")
        elseif string.find(downloadURL, "cache") ~= nil
        then
            table.insert(message, downloadURL .. "(超推荐)")
        else
            table.insert(message, downloadURL .. "(普通)")
        end
    end
    local num = pd.choice(message, 1, "选择下载接口")
    downloadURL = j.urls[num].url
	task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk;P2SP;2.2.60.26")
    task:setOptions("header", "Cookie: "..user:getCookie())
	task:setIcon("icon/svip.png", "Powered By-Admire")
    task:setOptions("piece-length", "5M")
	task:setOptions("max-connection-per-server", "16")
	task:setOptions("split", "16")
    task:setOptions("allow-piece-length-change", "true")
    task:setOptions("enable-http-pipelining", "true")
    return true
end
