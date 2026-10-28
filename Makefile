DEBUG = 0
FINALPACKAGE = 1
ARCHS = arm64 arm64e

THEOS_PACKAGE_SCHEME = roothide
TARGET = iphone:clang:16.5:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WxkbCandidate

WxkbCandidate_FILES = Hooks/Tweak.xm
WxkbCandidate_CFLAGS = -fobjc-arc
WxkbCandidate_FRAMEWORKS = UIKit Foundation
WxkbCandidate_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
