# Aspect Fill - Face Aware

Sometimes the aspect ratios of images we need to work with don't quite fit within the confines of our UIImageViews. They may be pulled from the web or user generated.

In most cases we can use AspectFill to fit the image to the bounds of a UIImageView without stretching or leaving whitespace, however when it comes to photos of people, it's quite often to have the faces cropped out if they're not perfectly centered.

This is where AspectFillFaceAware comes in.
It will analyse a UIImageViews image property, and re-center the image to include all detected faces.

<img src="https://raw.githubusercontent.com/BeauNouvelle/AspectFillFaceAware/master/largeExample.png" width=30%>

Also works great with avatars!

<img src="https://raw.githubusercontent.com/BeauNouvelle/AspectFillFaceAware/master/avatarExample.png" width=30%>

Based on these two older projects:

* [BetterFace-Swift](https://github.com/croath/UIImageView-BetterFace-Swift)
* [FaceAwareFill](https://github.com/Julioacarrettoni/UIImageView_FaceAwareFill)

Both of which don't seem to be maintained anymore.

##Requirements##
* Swift 3.0
* iOS 8.0+

##Installation##
Simply drag `UIImageView+FaceAware.swift` into your project.

##Useage##
Call the `focusOnFaces()` function *after* setting your image.

```
someImageView.focusOnFaces()
```

##Future Plans##
* Add an option to only focus on largest/closest face in photo.






