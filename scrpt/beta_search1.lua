local curl = require "lcurl.safe"
local json = require "cjson.safe"
script_info = {
	["title"] = "[伪]度盘搜",
	["description"] = "Beta Version",
	["version"] = "0.0.1",
}

function onSearch(key, page)
	local data = ""
	--pd.messagebox("123","DownloadUrl")
	if page==2 then 
	return ""
	end
		
	
	local c = curl.easy{
		url = "https://admir.xyz/search.php?key=" .. pd.urlEncode(key).. "&page=" .. page,
		followlocation = 1,
		timeout = 15,
		proxy = pd.getProxy(),
		writefunction = function(buffer)
			data = data .. buffer
			return #buffer
		end,
	}
	
	local _, e = c:perform()
	--c:perform()
	if e then
        return false
    end
	c:close()
	--pd.messagebox(data,"test")
	return parse(data)
end

function onItemClick(item)
	return ACT_SHARELINK, item.url 
end


function parse(data)
	local result = {}
	--pd.messagebox(data,"S1")
	local test = string.sub(data,1,string.len(data)-4)
	pd.logInfo(test)
	local j = json.decode(test)
	
	if j == nil then
        return false
    end
	

	for i, w in ipairs(j.data) do
		local tooltip = w.title
        table.insert(result, {["url"] = "https://pan.baidu.com/s/"..w.surl, ["title"] = w.title, ["time"] = time, ["showhtml"] = "true", ["tooltip"] = tooltip, ["check_url"] = "true"})
    end
	return result

end