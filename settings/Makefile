ARCHS = armv7 arm64

GO_EASY_ON_ME=1

include theos/makefiles/common.mk

BUNDLE_NAME = BootLogo
BootLogo_FILES = BootLogo.mm animationPreviewViewController.m
BootLogo_INSTALL_PATH = /Library/PreferenceBundles
BootLogo_FRAMEWORKS = UIKit Foundation CoreGraphics
BootLogo_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BootLogo.plist$(ECHO_END)
