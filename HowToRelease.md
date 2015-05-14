* modify `palplus-sdk-ios.podspec`

```
s.version          = "0.7.0"
```

* modify `Example/Podfile`

```
 pod "palplus-sdk-ios", :git => "https://github.com/palplus-api/palplus-sdk-ios.git",  :tag => '0.7.0'
```

* git commit and push
* release as tag:

```
git tag "0.7.0"
git push --tags
``` 

