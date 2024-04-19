##!/bin/sh

# this will create DocC archive
xcrun xcodebuild docbuild \
    -scheme GivenWithLove \
    -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath "$PWD/.derivedData"

# this will create Static Hosting files
xcrun docc process-archive transform-for-static-hosting \
    "$PWD/.derivedData/Build/Products/Debug-iphonesimulator/GivenWithLove.doccarchive" \
    --output-path ".docs" \
    --hosting-base-path "docc_publish_test" # add your repo name later

# This will change the path host.com/documentation/your-product-name to host.com/your-product-name 
echo '<script>window.location.href += "/documentation/givenwithlove"</script>' > .docs/index.html