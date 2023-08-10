#!/bin/sh
unset SDKROOT
script_dir="${0%/*}"
mkdir -p "${PROJECT_DIR}/FueledTemplate/Code/Generated/Sourcery"
"$script_dir"/sourcery/bin/sourcery --config "$script_dir"/Configs/sourcery_FueledTemplate.yml
mkdir -p "${PROJECT_DIR}/Libraries/FueledTemplateAPIKit/Sources/Generated/Sourcery"
"$script_dir"/sourcery/bin/sourcery --config "$script_dir"/Configs/sourcery_FueledTemplateAPIKit.yml
mkdir -p "${PROJECT_DIR}/Libraries/FueledTemplateHelpers/Sources/Generated/Sourcery"
"$script_dir"/sourcery/bin/sourcery --config "$script_dir"/Configs/sourcery_FueledTemplateHelpers.yml
