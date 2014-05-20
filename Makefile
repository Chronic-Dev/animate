SDKVERSION=7.1
GO_EASY_ON_ME=1

include theos/makefiles/common.mk


TOOL_NAME = animate
animate_FILES = animate.mm
animate_FRAMEWORKS = Foundation CoreFoundation CoreGraphics IOKit
animate_PRIVATE_FRAMEWORKS = CoreSurface ImageIO IOMobileFramebuffer
animate_CFLAGS = -I. -Iinclude/
animate_LDFLAGS = -undefined dynamic_lookup
animate_INSTALL_PATH = /etc/rc.d/

SUBPROJECTS = settings

include $(FW_MAKEDIR)/aggregate.mk
include $(THEOS_MAKE_PATH)/tool.mk

after-install::
        install.exec "killall -9 SpringBoard"
