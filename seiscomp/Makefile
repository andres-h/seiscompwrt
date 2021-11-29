# (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

include $(TOPDIR)/rules.mk

PKG_NAME:=seiscomp
PKG_VERSION:=2021.333
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/SeisComP/seiscomp.git
PKG_SOURCE_URL_SEEDLINK:=https://github.com/SeisComP/seedlink.git
PKG_SOURCE_VERSION:=5847c14174ac3556162ac334251f596bcd31b404
PKG_SOURCE_VERSION_SEEDLINK:=bc2e5a91cdae88c79a6aa5fac46a532b62a6534d
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_LICENSE:=AGPL-3.0
PKG_LICENSE_FILES:=COPYING
PKG_MAINTAINER:=Andres Heinloo <andres@gfz-potsdam.de>

CMAKE_INSTALL:=1
CMAKE_BINARY_SUBDIR:=build
PKG_USE_NINJA:=0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/seiscomp
  SECTION:=applications
  CATEGORY:=Seiscomp
  TITLE:=Seiscomp acquisition module
  URL:=https://www.seiscomp3.org
  DEPENDS:=+libstdcpp +libpthread +librt +libxml2 +libopenssl +python3-light +bash +findutils-find +lua +libuci-lua +luci-lib-nixio
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

CMAKE_OPTIONS += -DFLEX_INCLUDE_DIR=$(STAGING_DIR)/../host/include -DSC_DOC_GENERATE=OFF -DSC_GLOBAL_UNITTESTS=OFF

define Build/Patch
	cd $(PKG_BUILD_DIR)/src/base && git clone $(PKG_SOURCE_URL_SEEDLINK) && cd seedlink && git checkout $(PKG_SOURCE_VERSION_SEEDLINK)
	$(CP) $(STAGING_DIR)/../host/include/FlexLexer.h $(PKG_BUILD_DIR)/src/base/seedlink/libs/slutils/
	$(call Build/Patch/Default)
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
