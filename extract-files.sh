#!/bin/bash
#
# Copyright (C) 2014-2016 The CyanogenMod Project
# Copyright (C) 2017-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=flte
VENDOR=samsung

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function blob_fixup() {
    case "${1}" in
        vendor/bin/thermal-engine)
            sed -i 's|/system/etc|/vendor/etc|g' "${2}"
            ;;
        vendor/lib/libmmcamera2_sensor_modules.so)
            sed -i 's|system/etc|vendor/etc|g;
                    s|/system/lib|/vendor/lib|g' "${2}"
            ;;
    esac
}

setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" true

extract "${MY_DIR}/proprietary-files.txt" "${SRC}"

export BOARD_COMMON=msm8974-common

"./../../${VENDOR}/${BOARD_COMMON}/extract-files.sh" "$@"
