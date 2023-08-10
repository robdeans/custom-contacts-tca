#!/bin/sh
unset SDKROOT
script_dir="${0%/*}"
mkdir -p "${PROJECT_DIR}/CustomContacts/Code/Generated/Sourcery"
"$script_dir"/sourcery/bin/sourcery --config "$script_dir"/Configs/sourcery_CustomContacts.yml
mkdir -p "${PROJECT_DIR}/Libraries/CustomContactsAPIKit/Sources/Generated/Sourcery"
"$script_dir"/sourcery/bin/sourcery --config "$script_dir"/Configs/sourcery_CustomContactsAPIKit.yml
mkdir -p "${PROJECT_DIR}/Libraries/CustomContactsHelpers/Sources/Generated/Sourcery"
"$script_dir"/sourcery/bin/sourcery --config "$script_dir"/Configs/sourcery_CustomContactsHelpers.yml
