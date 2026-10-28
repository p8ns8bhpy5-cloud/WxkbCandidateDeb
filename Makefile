ARCHS = arm64
TARGET := iphone:clang:16.5:17.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WxkbCandidate

WxkbCandidate_FILES = Hooks/Tweak.xm
WxkbCandidate_CFLAGS = -fobjc-arc
WxkbCandidate_FRAMEWORKS = UIKit Foundation

include $(THEOS)/makefiles/tweak.mk
