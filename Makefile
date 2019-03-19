ifeq ($(shell [ -f ./framework/makefiles/common.mk ] && echo 1 || echo 0),0)
all clean package install::
	git submodule update --init
	./framework/git-submodule-recur.sh init
	$(MAKE) $(MAKEFLAGS) MAKELEVEL=0 $@
else

LIBRARY_NAME = libapplist
libapplist_OBJC_FILES = ALApplicationList.x ALApplicationTableDataSource.m ALValueCell.m
libapplist_CFLAGS = -I./
libapplist_FRAMEWORKS = UIKit CoreGraphics QuartzCore
libapplist_LIBRARIES = MobileGestalt

BUNDLE_NAME = AppList
AppList_OBJC_FILES = ALApplicationPreferenceViewController.m
AppList_FRAMEWORKS = UIKit CoreGraphics
AppList_PRIVATE_FRAMEWORKS = Preferences
AppList_LDFLAGS = -L$(FW_OBJ_DIR)
AppList_LIBRARIES = applist
AppList_INSTALL_PATH = /System/Library/PreferenceBundles

# LEGACY_XCODE_PATH ?= /Applications/Xcode_Legacy.app/Contents/Developer
# CLASSIC_XCODE_PATH ?= /Volumes/Xcode/Xcode.app/Contents/Developer
#
# ifneq ($(wildcard $(LEGACY_XCODE_PATH)/*),)
# THEOS_PLATFORM_SDK_ROOT_armv6 = $(LEGACY_XCODE_PATH)
# THEOS_PLATFORM_SDK_ROOT_armv7 = $(CLASSIC_XCODE_PATH)
# SDKVERSION_armv6 = 5.1
# INCLUDE_SDKVERSION_armv6 = latest
# TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
# TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv6 = 3.0
# TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7 = 3.0
# TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7s = 6.0
# TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0
# IPHONE_ARCHS = armv6 armv7 arm64
# libapplist_IPHONE_ARCHS = armv6 armv7 armv7s arm64
# else
# TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
# IPHONE_ARCHS = armv7 arm64
# libapplist_IPHONE_ARCHS = armv7 armv7s arm64
# ifeq ($(FINALPACKAGE),1)
# $(error Building final package requires a legacy Xcode install!)
# endif
# endif

ifeq ($(THEOS_CURRENT_ARCH),armv6)
GO_EASY_ON_ME=1
endif

ADDITIONAL_CFLAGS = -Ipublic -Ioverlayheaders -I.

include framework/makefiles/common.mk
include framework/makefiles/library.mk
include framework/makefiles/bundle.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/AppList
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/AppList $(FW_RSYNC_EXCLUDES)$(ECHO_END)

endif
