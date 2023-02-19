include $(TOPDIR)/rules.mk

PKG_NAME:=cube
#PKG_VERSION:=2017.306
PKG_RELEASE:=2023.050

PKG_SOURCE:=cube-plugin-2016-343.01-src.tar.gz
PKG_SOURCE_URL:=https://geofon.gfz-potsdam.de/software/cube/
PKG_HASH:=91fbce39ebca8005216c6efd65784eb041b7a8738aee8817f9a8d638cf6d130a
PKG_MAINTAINER:=Andres Heinloo <andres@gfz-potsdam.de>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/seiscomp-cube
  SECTION:=applications
  CATEGORY:=Seiscomp
  TITLE:=Cube plugin for Seiscomp
  URL:=https://www.seiscomp3.org
  DEPENDS:=+libstdcpp +boost
endef

define Package/seiscomp-cube/description
  SeisComP is a seismological software for data acquisition, processing,
  distribution and interactive analysis. This package contains the plugin
  for the DATA-CUBE digitizer.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(STAGING_DIR)/../host/include/FlexLexer.h $(PKG_BUILD_DIR)/3rd-party/slutils/
endef

define Build/Install
endef

define Package/seiscomp-cube/install
	$(INSTALL_DIR) $(1)/opt/seiscomp/share/plugins/seedlink
	$(CP) $(PKG_BUILD_DIR)/cube_plugin $(1)/opt/seiscomp/share/plugins/seedlink/
	$(INSTALL_DIR) $(1)/opt/seiscomp/share/templates/seedlink/cube
	$(CP) ./files/*.py ./files/*.tpl $(1)/opt/seiscomp/share/templates/seedlink/cube/
	$(INSTALL_DIR) $(1)/opt/seiscomp/etc/descriptions
	$(CP) ./files/*.xml $(1)/opt/seiscomp/etc/descriptions/
endef

$(eval $(call BuildPackage,seiscomp-cube))
