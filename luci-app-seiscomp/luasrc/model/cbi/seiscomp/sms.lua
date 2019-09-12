-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local m = Map("seiscomp", "SMS")
local s = m:section(NamedSection, "sms", "sms")

local o = s:option(Flag, "enabled", "enabled")
o.default = o.disabled
o.rmempty = false

local o = s:option(Value, "prefix", "prefix", "Prefix of SMS message.")
o.datatype = "minlength(5)"
o.rmempty = false

s:option(DynamicList, "numbers", "numbers", "Allowed numbers (click the '+' to add).")

return m

