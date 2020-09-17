local curl = require "lcurl.safe"
local json = require "cjson.safe"


script_info = {
	["title"] = "PCS加速通道",
	["version"] = "0.0.3",
	["description"] = "默认并行1",
	["color"] = "FF1493",
}

function onInitTask(task, user, file)
    if task:getType() ~= TASK_TYPE_BAIDU then
        return false
    end
    if user == nil then
        task:setError(-1, "用户未登录")
		return true
	end
	--local appid = 778750
	local appid = 778750
	
	if user:isSVIP() then
		appid = 250528
	end
	
	--250528（官方）、265486、309847；266719、778750自行选择测试速度即可。我用的是778750。

	local BDUSS = user:getBDUSS()
	local BDS = user:getBDStoken()
	local Cookie = user:getCookie()
	--pd.messagebox(Cookie,"Cookie:")
	
	--local header =  "User-Agent: netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia Cookie: BDUSS="..BDUSS 
	
	local header = { "User-Agent: netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia" }
	--table.insert(header, "Cookie: "..Cookie)
	table.insert(header, "Cookie: BDUSS="..BDUSS)
	
	--table.insert(header, "Cookie: BDUSS=EF6LVA4UXE3QTNiMEl4OVJGSE9LT1lPVVlobmVjUmNJdGhyRTNlT0lNTmhxYUJiQVFBQUFBJCQAAAAAAAAAAAEAAAA9P5p5xL7M7Naquq4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGEceVthHHlbV")
	--local url = "https://pcs.baidu.com/rest/2.0/pcs/file?method=download&path="..pd.urlEncode(file.path).."&app_id="..appid

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
	
	--c:perform()
	--c:close()
	--pd.messagebox(data)
	local _, e = c:perform()
    c:close()
    if e then
        return false
    end
	
	--pd.messagebox(data)
	
	local j = json.decode(data)
	if j == nil then
        return false
    end

	--[[
	local temp = data
	local downloadURL = ""
	local message1 = {}
	local tt = 0
	for i in pairs(j.server) do
		tt=tt+1
	    --pd.messagebox(j.server[tt],"第几个")
		table.insert(message1, j.server[tt])
	end
	
	
	
	
	downloadURL = "http://"..j.server[1]..j.path.."&filename="..pd.urlEncode(file.path)
	pd.messagebox(downloadURL,"DownloadUrl")
	
	--]]
	
	local message = {}
    local downloadURL = ""
    for i, w in ipairs(j.urls) do
	    downloadURL = w.url
		local d_start = string.find(downloadURL, "//") + 2
        local d_end = string.find(downloadURL, "%.") - 1
		downloadURL = string.sub(downloadURL, d_start, d_end)
        table.insert(message, downloadURL)
    end
	local num = pd.choice(message, 1, "选择下载接口")
    downloadURL = j.urls[num].url
    
	
	--local d_start = string.find(temp, "server") + 2
	--for i,w in inpirs(j) do
	--pd.messagebox(j.server[1],"接口")
	--[[for i, w in ipairs(j.urls) do
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
    downloadURL = j.urls[num].url--]]
	
	
	
    --local url = "https://qdall01.baidupcs.com/file/7ef4e99afba586f6447b9ea04cb134e7?bkt=en-038bee77e919b76a0a3eb96cde45f2de1cdae92c97b9c31661cb76617f02539117bc85ce97171919&fid=4129132250-250528-727025917023526&time=1591776014&sign=FDTAXUGERLQlBHSKfa-DCb740ccc5511e5e8fedcff06b081203-0tjagrH8ZCgCwraRHNPuciLuTw8%3D&to=&size=2147483648&sta_dx=2147483648&sta_cs=27&sta_ft=z16&sta_ct=7&sta_mt=2&fm2=MH%2CYangquan%2CAnywhere%2C%2Csichuan%2Cpbs&ctime=1547717933&mtime=1591266396&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=2147483648&vuk=4129132250&iv=0&htype=&randtype=em&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-3cfaab9ea1943412ede2e71f3e02c4a59f3938cb0651de99afb2b3d40087623fd1b59a42f9d9e8f6&sl=81068110&expires=8h&rt=pr&r=214698192&mlogid=3749510366529073525&vbdid=378808971&fin=PH10.z16&rtype=1&dp-logid=3749510366529073525&dp-callid=0.1.1&tsl=10&csl=50&fsl=-1&csign=53GlbxChcoX%2FP2rrv8RaRnKL8GA%3D&so=1&ut=6&uter=-1&serv=0&uc=3499990295&ti=39965399e74cce8417f71fc541b4ab147663be4de6370633&hflag=-1&adg=c_cd99febbe7859aed3edfd7e428c27163&reqlabel=250528_l_35be71dd9b2c7ee13ceffcac95814230_-1_be25ec52bc86b64c1085c3f4fea44453&by=themis"
    --task:setUris(url)
	--task:setOptions("host", "d6.baidupcs.com")
	task:setUris(downloadURL)
	--task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia")
	--task:setOptions("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
    task:setOptions("header", "Cookie: "..user:getCookie())
	
	
	task:setOptions("piece-length", "5M")
	task:setOptions("max-connection-per-server", "16")
    task:setOptions("allow-piece-length-change", "true")
    task:setOptions("enable-https-pipelining", "true")
	task:setIcon("icon/accelerate.png", "禁止分享该脚本！")

	if user:isSVIP() then
		task:setIcon("icon/accelerate.png", "SVIP加速中")
	end
	
    return true
 


end
