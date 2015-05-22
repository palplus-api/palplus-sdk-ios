#!/bin/sh

[ "$#" -lt 1 ] && echo "please enter version like 1.2.3" && exit 0

VERSION=$1
echo releaseing $VERSION
echo

sed -i '' "s/[0-9]*\.[0-9]*\.[0-9]*/$VERSION/g" Pod/Classes/PALConstants.h 
sed -i '' "s/\(s.version *= *\)\"[0-9]*\.[0-9]*\.[0-9]*\"/\1\"$VERSION\"/" palplus-sdk-ios.podspec
sed -i '' "s/\(:tag *=> *\)\"[0-9]*\.[0-9]*\.[0-9]*\"/\1\"$VERSION\"/" Example/Podfile

echo "PALConstants.h"
echo 
cat Pod/Classes/PALConstants.h

echo "palplus-sdk-ios.podspec"
echo 
cat palplus-sdk-ios.podspec
echo

echo "Example/Podfile"
echo 
cat Example/Podfile
echo


echo "-------- run below command if ok-----"
echo "git commit -a -m \"release $VERSION\""
echo "git push"
echo "git tag $VERSION"
echo "git push --tags"


