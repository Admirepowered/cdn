local curl = require "lcurl.safe"
local json = require "cjson.safe"


script_info = {
	["title"] = "Pandownload Extra通道",
	["version"] = "0.0.3",
	["description"] = "盘内下载Powered-by:Admire",
	["color"] = "#6688CC",
}
     
function onInitTask(task, user, file)
    if task:getType() ~= TASK_TYPE_BAIDU then
		return false
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
	table.insert(header, "Cookie: BDUSS="..BDUSS.."SignText")
	local url = "http://127.0.0.1:8989/api/gd?path="..pd.urlEncode(file.path)
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

	local downloadURL = data


	
	task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2")
    task:setOptions("header", "Range:bytes=0-0")
	if file.size >=8192 then 
		task:setOptions("header", "Range:bytes=4096-8191")
	end
	task:setIcon("icon/svip.png", "Powered By-Admire")
    task:setOptions("piece-length", "1M")
	--task:setOptions("max-connection-per-server", "64")
	--task:setOptions("split", "64")
    task:setOptions("allow-piece-length-change", "true")
    task:setOptions("enable-http-pipelining", "true")
    return true
end