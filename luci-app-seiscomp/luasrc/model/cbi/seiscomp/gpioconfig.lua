-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local gpio = arg[1] or ""

local m = Map("seiscomp", "GPIO")
m.redirect = dsp.build_url("admin", "services", "gpio", "pin")

local s = m:section(NamedSection, gpio, "gpio", gpio)

local o = s:option(Value, "description", "description", "Description.")
o.rmempty = false
o.datatype = "rangelength(1, 100)"

local o = s:option(ListValue, "type", "type", "Type.")
o:value("switch", "switch")
o:value("trigger", "trigger")
o:value("input", "input")

local o = s:option(Flag, "active_low", "active_low", "Invert value.")
o.default = o.disabled

local o = s:option(ListValue, "init_state", "init_state", "Initial state.")
o:depends("type", "switch")
o:value("0", "OFF")
o:value("1", "ON")

local o = s:option(Value, "duration", "duration", "Duration in seconds.")
o:depends("type", "trigger")
o.datatype = "float"
o.default = 1.0

local o = s:option(DynamicList, "action", "action", "Action when change detected.")
o:depends("type", "input")

return m

