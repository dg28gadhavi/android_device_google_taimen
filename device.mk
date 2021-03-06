#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 560dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

PRODUCT_HARDWARE := nb1

# DEVICE_PACKAGE_OVERLAYS for the device should be before
# including common overlays since the one listed first
# takes precedence.
ifdef DEVICE_PACKAGE_OVERLAYS
$(warning Overlays defined in '$(DEVICE_PACKAGE_OVERLAYS)' will override '$(PRODUCT_HARDWARE)' overlays)
endif
DEVICE_PACKAGE_OVERLAYS += device/nokia/nb1/overlay

# Audio
PRODUCT_COPY_FILES += \
    device/nokia/nb1/default_volume_tables.xml:system/etc/default_volume_tables.xml \
    device/nokia/nb1/audio_policy_volumes.xml:$system/etc/audio_policy_volumes.xml

PRODUCT_COPY_FILES += \
    device/nokia/nb1/init-nb1.rc:$system/etc/init/init-$(PRODUCT_HARDWARE).rc \
    device/nokia/nb1/init.nb1.usb.rc:$system/etc/init/hw/init.$(PRODUCT_HARDWARE).usb.rc

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=560 \

# Logging
PRODUCT_COPY_FILES += \
    device/nokia/nb1/init.logging.rc:$system/etc/init/init.$(PRODUCT_HARDWARE).logging.rc


PRODUCT_COPY_FILES += \
    device/nokia/nb1/nfc/libnfc-nxp.nb1.conf:$system/etc/libnfc-nxp.conf

PRODUCT_COPY_FILES += \
    device/nokia/nb1/thermal-engine.conf:$system/etc/thermal-engine.conf \
    device/nokia/nb1/thermal-engine-vr.conf:$system/etc/thermal-engine-vr.conf

# Audio
PRODUCT_COPY_FILES += \
    device/nokia/nb1/mixer_paths_tavil.xml:$system/etc/mixer_paths_tavil_taimen.xml \
    device/nokia/nb1/audio_platform_info_tavil.xml:$system/etc/audio_platform_info_tavil_taimen.xml

# Bug 62375603
PRODUCT_PROPERTY_OVERRIDES += audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += audio_hal.period_multiplier=2
PRODUCT_PROPERTY_OVERRIDES += af.fast_track_multiplier=1

# Whether by default, the eSIM system UI, including that in SUW and Settings, will be shown.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += esim.enable_esim_system_ui_by_default=false

# Pro audio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$system/etc/permissions/android.hardware.audio.pro.xml

# Enable AAudio MMAP/NOIRQ data path.
# 1 is AAUDIO_POLICY_NEVER  means only use Legacy path.
# 2 is AAUDIO_POLICY_AUTO   means try MMAP then fallback to Legacy path.
# 3 is AAUDIO_POLICY_ALWAYS means only use MMAP path.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
# 1 is AAUDIO_POLICY_NEVER  means only use SHARED mode
# 2 is AAUDIO_POLICY_AUTO   means try EXCLUSIVE then fallback to SHARED mode.
# 3 is AAUDIO_POLICY_ALWAYS means only use EXCLUSIVE mode.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2

# Increase the apparent size of a hardware burst from 1 msec to 2 msec.
# A "burst" is the number of frames processed at one time.
# That is an increase from 48 to 96 frames at 48000 Hz.
# The DSP will still be bursting at 48 frames but AAudio will think the burst is 96 frames.
# A low number, like 48, might increase power consumption or stress the system.
PRODUCT_PROPERTY_OVERRIDES += aaudio.hw_burst_min_usec=2000

# Wifi configuration file
PRODUCT_COPY_FILES += \
    device/nokia/nb1/WCNSS_qcom_cfg.ini:system/etc/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini

# Keymaster configuration
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:system/etc/permissions/android.software.device_id_attestation.xml

# Enable modem logging
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.modem.diag.qdb=0\
    persist.sys.modem.diag.mdlog=true \
    persist.sys.modem.diag.mdlog_br_num=5 \
    ro.radio.log_loc="/data/vendor/modem_dump" \
    ro.radio.log_prefix="modem_log_"
endif

#IMU calibration
PRODUCT_PROPERTY_OVERRIDES += \
  persist.config.calibration_fac=/persist/sensors/calibration/calibration.xml

# Vibrator HAL
PRODUCT_PROPERTY_OVERRIDES += \
  ro.vibrator.hal.click.duration=10 \
  ro.vibrator.hal.tick.duration=4 \
  ro.vibrator.hal.heavyclick.duration=12

# Enable Perfetto traced
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.traced.enable=1

# Early phase offset for SurfaceFlinger (b/75985430)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.early_phase_offset_ns=5000000

