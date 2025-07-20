# (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

include $(TOPDIR)/rules.mk

PKG_VERSION:=2025.200
PKG_RELEASE:=1

LUCI_TITLE:=LuCI support for Seiscomp
LUCI_DEPENDS:=+seiscomp +lua +libuci-lua +luci-lib-nixio +luasocket +luaexpat +luci-compat
LUCI_PKGARCH:=all
PKG_LICENSE:=GPLv2
PKG_MAINTAINER:=Andres Heinloo <andres@gfz-potsdam.de>

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
