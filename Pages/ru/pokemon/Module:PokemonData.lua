local p = {}
local h = mw.InfoboxBuilderHF
local getArgs = require('Dev:Arguments').getArgs
local pokename_from_number = mw.loadData( 'Module:PokemonData/fromNumber' )
local pokename_from_number_pixelmon = mw.loadData( 'Module:PokemonData/fromNumber/pixelmon' )
local movedata = mw.loadData( 'Module:PokemonData/moves' )
local epdata = mw.loadData( 'Module:PokemonData/epdata' )
local pagename = mw.title.getCurrentTitle().text

function p.get_pokedata(frame)
	for number, names in pairs( pokename_from_number ) do
		if names[3] == pagename then
			return number
		end
	end
end

function p.get_pokename(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[2])
	local name = pokename_from_number[args[1]]
	if not name then return '' end
    return name[parameter]
end

function p.get_move(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[1])
	local move = movedata[pagename]
	
    return move[parameter]
end

function p.get_episode(frame)
	local args = getArgs(frame)
	local parameter = args[1]
	local ep = epdata[pagename]
	
    return ep[parameter]
end

function p.get_pokename_pixelmon(frame)
	local args = getArgs(frame)
	local parameter = tonumber(args[2])
	local name = pokename_from_number_pixelmon[args[1]]
	
    return name[parameter]
end

return p

-- [[Категория:Модули]]