# Aspect Fill - Face Aware

Sometimes the aspect ratios of images we need to work with don't quite fit within the confines of our UIImageViews.

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

##License##

The MIT License (MIT)

Copyright (c) 2016 Beau Nouvelle

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
