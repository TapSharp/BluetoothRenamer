TWEAK_NAME  = BluetoothRenamer
BUNDLE_NAME = BluetoothRenamerPrefs

BluetoothRenamer_FILES = $(wildcard UIAlert*.m) PrefsRoot.xm SpringBoard.xm
BluetoothRenamer_FRAMEWORKS = UIKit Foundation Social Accounts CoreBluetooth
BluetoothRenamer_PRIVATE_FRAMEWORKS = Preferences BluetoothManager DeviceToDeviceManager

BluetoothRenamerPrefs_FILES = TapSharpPreferences.m Preferences.m
BluetoothRenamerPrefs_INSTALL_PATH = /Library/PreferenceBundles
BluetoothRenamerPrefs_FRAMEWORKS = UIKit CoreBluetooth CoreGraphics Social
BluetoothRenamerPrefs_PRIVATE_FRAMEWORKS = Preferences BluetoothManager

export ARCHS = armv7 arm64
export TARGET = iphone:latest:latest

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp Preferences.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BluetoothRenamer.plist$(ECHO_END)