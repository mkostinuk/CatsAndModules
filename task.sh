WORKSPACE=CatsAndModules_MaksymKostyniuk.xcworkspace
SCHEME="PrettyCatApp"
CONFIG="Release"
DEST="generic/platform=iOS"
VERSION="v1.0.0"
ARCHIVE_PATH="./ARCHIVES/${VERSION}.xcarchive"
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXPORT_PATH="${CURRENT_DIR}/Exported"
EXPORT_OPTIONS_PLIST="${CURRENT_DIR}/exportOptions.plist"
TEAM_ID="D85QWSUNYA"
BUNDLE_ID="ua.edu.ukma.apple-env.kostyniuk.PrettyCats"
PROFILE_NAME="Apple-ENV Kostyniuk"
CERT_NAME="iPhone Developer: Maksym Kostyniuk (7Y95S3KP83)"
PLIST_BUDDY="/usr/libexec/PlistBuddy"

ANIMAL="$1"

if [ "$ANIMAL" != "CATS" ] && [ "$ANIMAL" != "DOGS" ]; then
  exit 1
fi
INFO_PLIST="${CURRENT_DIR}/PrettyCatApp/Info.plist"

xcodebuild clean \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIG}" \
  -destination "${DEST}"

"${PLIST_BUDDY}" -c "Set :AnimalType ${ANIMAL}" "${INFO_PLIST}" 2>/dev/null \
  || "${PLIST_BUDDY}" -c "Add :AnimalType string ${ANIMAL}" "${INFO_PLIST}"
  
xcodebuild archive \
  -archivePath "${ARCHIVE_PATH}" \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIG}" \
  -destination "${DEST}"

rm -f "${EXPORT_OPTIONS_PLIST}"

"${PLIST_BUDDY}" -c "Add :destination string export" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :method string development" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :uploadSymbols bool true" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :signingStyle string manual" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :stripSwiftSymbols bool true" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :teamID string ${TEAM_ID}" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :uploadBitcode bool true" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :signingCertificate string ${CERT_NAME}" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :provisioningProfiles dict" "${EXPORT_OPTIONS_PLIST}"
"${PLIST_BUDDY}" -c "Add :provisioningProfiles:${BUNDLE_ID} string ${PROFILE_NAME}" "${EXPORT_OPTIONS_PLIST}"

xcodebuild -exportArchive \
    -archivePath "${ARCHIVE_PATH}" \
    -exportPath "${EXPORT_PATH}" \
    -exportOptionsPlist "${EXPORT_OPTIONS_PLIST}"

if [ -f "${EXPORT_PATH}/PrettyCatApp.ipa" ]; then
  rm -rf "${EXPORT_PATH}_${ANIMAL}"
  mv "${EXPORT_PATH}" "${EXPORT_PATH}_${ANIMAL}"
else
  exit 1
fi