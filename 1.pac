function FindProxyForURL(url, host){
var Proxy="PROXY 127.0.0.1:6080";
var ProxyD="PROXY 127.0.0.1:7890";
var patterns = new Array("steamcommunity.com",
"*.pixiv.net",
"pixiv.net",
"*.secure.pixiv.net",
"pximg.net",
"*.pximg.net",
"wikipedia.org",
"*.wikipedia.org",
"steamcommunity.com",
"*.steamcommunity.com",
"*.steampowered.com",
"steampowered.com",
"cn.pornhub.com",
"e-hentai.org",
"*.e-hentai.org",
"twitch.tv",
"www.twitch.tv",
"*.twitch.tv",
"*.chat.twitch.tv",
"usher.ttvnw.net",
"discordapp.com",
"*.discordapp.com",
"*.discordapp.net",
"*.discord.gg",
"*.steampowered.com",
"*.s3.amazonaws.com",
"*.akamaihd.net",
"*.cdn.ubi.com",
"*.chat.twitch.tv",
"*.uploads-regional.twitch.tv",
"*.help.twitch.tv",
"*.dev.twitch.tv");
for (i in patterns) {
if(shExpMatch(host.toLowerCase(),"*" + patterns[i].toLowerCase() + "*")){return Proxy;};
};
return ProxyD;
}
