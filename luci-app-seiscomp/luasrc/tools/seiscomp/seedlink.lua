-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local SCDIR = "/opt/seiscomp/"
local XMLDIR = SCDIR .. "etc/descriptions/"
local TPLDIR = SCDIR .. "share/templates/seedlink/"

local cbi = require "luci.cbi"
local fs = require "nixio.fs"
local lxp = require "lxp"

local function sourcetypes()
	local t = {}
	local iter = fs.dir(XMLDIR)

	if not iter then
		return t
	end

	for fname in iter do
		local name = fname:match("^seedlink_([^/.]*)%.xml$")

		if name ~= nil then
			local el = {"seiscomp", "binding", "description"}
			local n = 1
			local i = 0

			local callbacks = {
				StartElement = function(parser, name)
					if name == el[n] then
						n = n + 1
					else
						i = i + 1
					end
				end,

				EndElement = function(parser, name)
					if i > 0 then
						i = i - 1
					else
						n = n - 1
					end
				end,

				CharacterData = function(parser, str)
					if n == 4 and i == 0 then
						table.insert(t, {
							name = name,
							description = str:match("^%s*(.-)%s*$"):gsub("%s+", " "):sub(1, 50)
						})
						parser:stop()
					end
				end
			}

			local f = assert(io.open(XMLDIR .. fname, "r"))
			local parser = lxp.new(callbacks)
			parser:parse(f:read("*all"))
			parser:parse()
			parser:close()
			f:close()
		end
	end

	table.sort(t, function(a, b) return a.description < b.description end)

	return t
end

local function params(fname, mtype)
	local t = {}
	local el = {"seiscomp", mtype, "configuration", "parameter", "description"}
	local n = 1
	local i = 0
	local g = 0
	local pfx = {[0] = ""}
	local p = nil

	local callbacks = {
		StartElement = function(parser, name, attr)
			if i == 0 then
				if name == el[n] then
					n = n + 1

					if n == 5 then
						p = {}
						table.insert(t, p)

						for k, v in pairs(attr) do
							if type(k) == "string" then
								if k == "name" then
									v = pfx[g] .. v
								end

								p[k] = v
							end
						end
					end

				elseif n == 4 and name == "group" then
					g = g + 1
					pfx[g] = pfx[g-1] .. attr.name .. "."

				else
					i = i + 1

				end

			else
				i = i + 1

			end
		end,

		EndElement = function(parser, name)
			if i > 0 then
				i = i - 1

			elseif name == "group" then
				g = g - 1

			else
				n = n - 1

			end
		end,

		CharacterData = function(parser, str)
			if n == 6 and i == 0 then
				p.description = str:match("^%s*(.-)%s*$"):gsub("%s+", " ")
			end
		end
	}

	local f = assert(io.open(XMLDIR .. fname, "r"))
	local parser = lxp.new(callbacks)
	parser:parse(f:read("*all"))
	parser:parse()
	parser:close()
	f:close()

	return t
end

local function procs(srctype)
	local t = {}
	local iter = fs.dir(TPLDIR .. srctype)

	if not iter then
		return t
	end

	for f in iter do
		local name = f:match("^streams_([^/.]*)%.tpl$")

		if name ~= nil then
			table.insert(t, {
				name = name,
				description = name
			})
		end
	end

	table.sort(t, function(a, b) return a.description < b.description end)

	return t
end

local function fillsection(s, mtype, module, submodule)
	local t

	if submodule then
		t = params(module .. "_" .. submodule .. ".xml", mtype)
	else
		t = params(module .. ".xml", mtype)
	end

	for _, v in ipairs(t) do
		local desc = v.description:gsub("[<>]", {["<"] = "&lt;", [">"] = "&gt;"})
		local uciname = v.name:gsub("%.", "__")

		if v.type == "list:string" then
			s:option(cbi.DynamicList, uciname, v.name, desc)

		elseif v.type == "boolean" then
			local o = s:option(cbi.Flag, uciname, v.name, desc)
			o.enabled = "true"
			o.disabled = "false"
			o.default = v.default

		elseif v.name == "proc" and module == "seedlink" and submodule then
			local o = s:option(cbi.ListValue, uciname, v.name, desc)
			o.default = v.default

			for _, v in ipairs(procs(submodule)) do
				o:value(v.name, v.description)
			end

		elseif v.name == "network" and module == "seedlink" and not submodule then
			-- added manually

		else
			local o = s:option(cbi.Value, uciname, v.name, desc)
			o.default = v.default

			if v.type == "int" then
				-- o.datatype = "integer"

			elseif v.type == "float" then
				-- o.datatype = "float"

			end
		end
	end
end

return {
	sourcetypes = sourcetypes,
	fillsection = fillsection
}

