local p = {}
local h = mw.InfoboxBuilderHF
local getArgs = require('Dev:Arguments').getArgs
local pokedata = mw.loadData( 'Module:PokemonData/data' )
local pokename_from_number = mw.loadData( 'Module:PokemonData/fromNumber' )
local numberregion = mw.loadData( 'Module:PokemonData/region' )
local movedata = mw.loadData( 'Module:PokemonData/moves' )
local epdata = mw.loadData( 'Module:PokemonData/epdata' )
local pagename = mw.title.getCurrentTitle().text

--------
function p.get_pokedata(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[1])
	local pok = pokedata[pagename]
	
    return pok[parameter]
end

--------
function p.get_pokename(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[2])
	local name = pokename_from_number[args[1]]
	
    return name[parameter]
end

--------
function p.region(frame)
	local args = getArgs(frame)
	local title = numberregion[args[1]]
	local pok = pokedata[pagename][1]
	
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
