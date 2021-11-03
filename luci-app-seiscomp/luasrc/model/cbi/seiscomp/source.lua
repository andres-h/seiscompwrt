-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local sl = require "luci.tools.seiscomp.seedlink"
local m = Map("seiscomp", "SeedLink")

local s = m:section(TypedSection, "source", "Sources")
s.sectionhead = "Source"
s.add_title = "Add new source"
s.addremove = true
s.sortable = true
s.template = "cbi/tblsection"
s.template_addremove = "seiscomp/source_add"
s.extedit = dsp.build_url("admin", "services", "seedlink", "source", "%s")
s.sourcetypes = sl.sourcetypes()

local stm = {}

for _, v in ipairs(s.sourcetypes) do
	if v.name ~= nil then
		stm[v.name] = v.description
	end
end

function s:sectiontitle(section)
	local st, sn = section:match("^(.*)_([^_]*)$")

	if st and stm[st] then
		return stm[st] .. " #" .. sn

	else
		return section

	end
end

function s:create(section)
	local snmax = 0

	for _, v in ipairs(s:cfgsections()) do
		local st, sn = v:match("^(.*)_([^_]*)$")
		sn = tonumber(sn)

		if st == section and sn > snmax then
			snmax = sn
		end
	end

	section = section .. "_" .. snmax + 1
	TypedSection.create(self, section)
	m.uci:save("seiscomp")
	luci.http.redirect(dsp.build_url("admin", "services", "seedlink", "source", section))
end

local attached = s:option(DummyValue, "attached", "Attached to")
function attached:cfgvalue(s)
	local comport = self.map:get(s, "comport")

	if comport then
		return comport
	end

	local device = self.map:get(s, "device")

	if device then
		return device
	end

	local address = self.map:get(s, "address")

	if address then
		local port = self.map:get(s, "port")

		if port then
			address = address .. ":" .. port
		end

		return address
	end

	return ""
end

local enabled = s:option(DummyValue, "enabled", "Enabled")
function enabled:cfgvalue(s)
	if self.map:get(s, "enabled") == "0" then
		return "No"
	else
		return "Yes"
	end
end

return m

