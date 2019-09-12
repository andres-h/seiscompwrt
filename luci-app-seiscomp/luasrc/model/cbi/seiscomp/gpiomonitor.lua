-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local m = Map("seiscomp", "GPIO")
local s = m:section(NamedSection, "gpiomonitor", "gpiomonitor", "Monitor")

local o = s:option(Flag, "enabled", "enabled")
o.default = o.disabled
o.rmempty = false

o = s:option(Value, "smtp", "smtp", "SMTP server.")

return m

