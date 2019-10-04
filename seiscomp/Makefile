# (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

include $(TOPDIR)/rules.mk

PKG_NAME:=seiscomp
PKG_VERSION:=2019.252
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/andres-h/seiscomp3.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=4486235150c6b2521264e5c7a9858171d08b272b
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_LICENSE:=GPL-2.0+, SeisComP Public License
PKG_LICENSE_FILES:=COPYING
PKG_MAINTAINER:=Andres Heinloo <andres@gfz-potsdam.de>

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/seiscomp
  SECTION:=applications
  CATEGORY:=Seiscomp
  TITLE:=Seiscomp acquisition module
  URL:=https://www.seiscomp3.org
  DEPENDS:=+libstdcpp +libpthread +librt +libxml2 +python-light +python-logging +python-openssl +bash +findutils-find +lua +libuci-lua +luci-lib-nixio
endef

define Package/seiscomp/description
  Seiscomp is a seismological software for data acquisition, processing,
  distribution and interactive analysis. This package contains the acquisition
  module only.
endef

define Package/seiscomp/conffiles
/etc/config/scgpio
/etc/config/scsms
/etc/config/seiscomp
endef

CMAKE_OPTIONS += -DFLEX_INCLUDE_DIR=$(STAGING_DIR)/../host/include -DSC_DOC_GENERATE=OFF

define Build/Prepare
	$(call Build/Prepare/Default)
	for d in $(PKG_BUILD_DIR)/src/*; do echo "$$$$d" | egrep -q "/(system|seedlink|CMakeLists\.txt)$$$$" || $(RM) -r "$$$$d"; done
	$(CP) $(STAGING_DIR)/../host/include/FlexLexer.h $(PKG_BUILD_DIR)/src/seedlink/libs/slutils/
endef

define Package/seiscomp/install
	$(INSTALL_DIR) $(1)/opt/seiscomp $(1)/etc/init.d $(1)/etc/config
	$(CP) $(PKG_INSTALL_DIR)/usr/* $(1)/opt/seiscomp/
	$(INSTALL_BIN) ./files/scgpiod $(1)/opt/seiscomp/sbin/
	$(INSTALL_BIN) ./files/scwrtd $(1)/opt/seiscomp/sbin/
	$(INSTALL_BIN) ./files/scgpiod.init $(1)/etc/init.d/scgpiod
	$(INSTALL_BIN) ./files/scwrtd.init $(1)/etc/init.d/scwrtd
	$(INSTALL_CONF) ./files/scgpio.config $(1)/etc/config/scgpio
	$(INSTALL_CONF) ./files/scsms.config $(1)/etc/config/scsms
	$(INSTALL_CONF) ./files/seiscomp.config $(1)/etc/config/seiscomp
endef

$(eval $(call BuildPackage,seiscomp))
