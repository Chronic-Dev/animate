SDKVERSION=4.2
include theos/makefiles/common.mk

TOOL_NAME = animate
animate_FILES = animate.mm
animate_FRAMEWORKS = Foundation CoreFoundation CoreGraphics IOKit
animate_PRIVATE_FRAMEWORKS = CoreSurface ImageIO IOMobileFramebuffer
animate_CFLAGS = -I. -Iinclude/
animate_LDFLAGS = -undefined dynamic_lookup
animate_INSTALL_PATH = /usr/bin/

include $(THEOS_MAKE_PATH)/tool.mk
