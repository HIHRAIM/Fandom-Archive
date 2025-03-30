local p = {}
local h = mw.InfoboxBuilderHF
local getArgs = require('Dev:Arguments').getArgs
local tdolldata = mw.loadData( 'Module:TDollData/data' )
local tdollname_from_number = mw.loadData( 'Module:TDollData/fromNumber' )
local pagename = mw.title.getCurrentTitle().text

--------
function p.get_tdolldata(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[1])
	local pok = tdolldata[pagename]
	
    return pok[parameter]
end

--------
function p.get_tdollname(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[2])
	local name = tdollname_from_number[args[1]]
	
    return name[parameter]
end

--------
function p.region(frame)
	local args = getArgs(frame)
	local title = numberregion[args[1]]
	local pok = tdolldata[pagename][1]
	
    return title[pok]
end

--------
function p.get_move(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[1])
	local move = movedata[pagename]
	
    return move[parameter]
end

--------
function p.get_episode(frame)
	local args = getArgs(frame)
	local parameter = args[1]
	local ep = epdata[pagename]
	
    return ep[parameter]
end

--------
return p

-- [[Категория:Модули]]
