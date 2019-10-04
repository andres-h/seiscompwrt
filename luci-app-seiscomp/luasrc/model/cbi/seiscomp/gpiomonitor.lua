-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local m = Map("scgpio", "GPIO")
local s = m:section(NamedSection, "monitor", "monitor", "Monitor")

local o = s:option(Flag, "enabled", "enabled")
o.default = o.disabled
o.rmempty = false

s:option(Value, "smtp_server", "smtp_server", "SMTP server.")
s:option(Value, "smtp_user", "smtp_user", "SMTP user.")
s:option(Value, "smtp_password", "smtp_password", "SMTP password.")
s:option(Value, "smtp_sender", "smtp_sender", "SMTP sender address.")

return m

