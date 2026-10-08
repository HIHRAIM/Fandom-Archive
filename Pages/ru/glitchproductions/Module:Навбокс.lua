local p = {}

local function clean(value)
	if value == nil then
		return nil
	end
	value = mw.text.trim(tostring(value))
	if value == '' then
		return nil
	end
	return value
end

local function section(store, index)
	index = tonumber(index)
	store[index] = store[index] or {subs = {}, order = {}}
	return store[index], index
end

local function collect(args)
	local store, order = {}, {}
	for key, value in pairs(args) do
		if type(key) == 'string' then
			local one = key:match('^Раздел%s+(%d+)$')
			if one then
				section(store, one).label = clean(value)
			end
			local subIndex, subPart = key:match('^Подраздел%s+(%d+)%.(%d+)$')
			if subIndex then
				local item = section(store, subIndex)
				subPart = tonumber(subPart)
				item.subs[subPart] = item.subs[subPart] or {}
				item.subs[subPart].label = clean(value)
			end
			local rowIndex, rowPart = key:match('^Строка%s+(%d+)%.(%d+)$')
			if rowIndex then
				local item = section(store, rowIndex)
				rowPart = tonumber(rowPart)
				item.subs[rowPart] = item.subs[rowPart] or {}
				item.subs[rowPart].items = clean(value)
			end
			local plain = key:match('^Строка%s+(%d+)$')
			if plain then
				section(store, plain).items = clean(value)
			end
		end
	end
	for index in pairs(store) do
		table.insert(order, index)
	end
	table.sort(order)
	for _, index in ipairs(order) do
		local item = store[index]
		for sub in pairs(item.subs) do
			table.insert(item.order, sub)
		end
		table.sort(item.order)
	end
	return store, order
end

local function arguments(frame)
	local args = {}
	for key, value in pairs(frame.args) do
		args[key] = value
	end
	local parent = frame:getParent()
	if parent then
		for key, value in pairs(parent.args) do
			args[key] = value
		end
	end
	return args
end

local function templateLink(frame, args)
	local source = clean(args['Шаблон'])
	if source then
		return source
	end
	local parent = frame:getParent()
	local name = parent and parent:getTitle() or nil
	if not name then
		return nil
	end
	local title = mw.title.new(name)
	if title and title.namespace == 10 then
		return title.fullText
	end
	return nil
end

local function legacy(args)
	local header = clean(args['header'])
	local body = clean(args['body'])
	if not header and not body then
		return nil
	end
	local root = mw.html.create('table'):addClass('pedia-nbox mw-collapsible mw-collapsed')
	local head = root:tag('tr'):tag('th'):addClass('pedia-nbox__head'):attr('colspan', 3)
	local shown = clean(args['h']) or header or 'Навигация'
	local target = header and mw.title.new(header) or nil
	if target and target.exists then
		head:tag('span'):addClass('pedia-nbox__title')
			:wikitext('[[' .. header .. '|' .. shown .. ']]')
	else
		head:tag('span'):addClass('pedia-nbox__title'):wikitext(shown)
	end
	local cell = root:tag('tr'):tag('td'):addClass('pedia-nbox__items'):attr('colspan', 3)
	local align = clean(args['align2'])
	if align then
		cell:css('text-align', align)
	else
		cell:css('text-align', 'center')
	end
	cell:wikitext(body or '')
	return tostring(root)
end

function p.navbox(frame)
	local args = arguments(frame)
	local old = legacy(args)
	if old then
		return old
	end
	local store, order = collect(args)
	local root = mw.html.create('table'):addClass('pedia-nbox mw-collapsible')
	if clean(args['Свёрнут']) or clean(args['Свернут']) then
		root:addClass('mw-collapsed')
	end

	local head = root:tag('tr'):tag('th'):addClass('pedia-nbox__head'):attr('colspan', 3)
	local source = templateLink(frame, args)
	if source then
		head:tag('span'):addClass('pedia-nbox__src')
			:wikitext('[[' .. source .. '|<span class="ph-bold ph-brackets-curly"></span>]]')
	end
	head:tag('span'):addClass('pedia-nbox__title'):wikitext(clean(args['Заголовок']) or 'Пример')

	for _, index in ipairs(order) do
		local item = store[index]
		local rows = #item.order + (item.items and 1 or 0)
		if rows > 0 then
			local pending = item.label and rows or 0
			local function label(row)
				if pending > 0 then
					row:tag('td'):addClass('pedia-nbox__label'):attr('rowspan', pending)
						:wikitext(item.label)
					pending = 0
				end
			end
			if item.items then
				local row = root:tag('tr')
				label(row)
				row:tag('td'):addClass('pedia-nbox__items')
					:attr('colspan', item.label and 2 or 3):wikitext(item.items)
			end
			for _, sub in ipairs(item.order) do
				local entry = item.subs[sub]
				local row = root:tag('tr')
				label(row)
				if entry.label then
					row:tag('td'):addClass('pedia-nbox__sub'):wikitext(entry.label)
					row:tag('td'):addClass('pedia-nbox__items'):wikitext(entry.items or '')
				else
					row:tag('td'):addClass('pedia-nbox__items')
						:attr('colspan', item.label and 2 or 3):wikitext(entry.items or '')
				end
			end
		end
	end

	return tostring(root)
end

return p