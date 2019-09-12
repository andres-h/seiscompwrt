-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local m = Map("seiscomp", "GPIO")

local s = m:section(TypedSection, "gpio", "Pins")
s.addremove = true
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = dsp.build_url("admin", "services", "gpio", "pin", "%s")

function s:create(section)
	local pin = section:match("^([0-9][0-9]?)$")
	if pin then
		section = "gpio" .. section

	else
		pin = section:match("^gpio([0-9][0-9]?)$")
		if not pin then
			s.invalid_cts = true
			return
		end
	end

	TypedSection.create(self, section)
	m.uci:save("seiscomp")
	luci.http.redirect(dsp.build_url("admin", "services", "gpio", "pin", section))
end

s:option(DummyValue, "description", "Description")
s:option(DummyValue, "type", "Type")

return m

