# FaceAware

<img src="https://raw.githubusercontent.com/BeauNouvelle/FaceAware/master/Images/avatarExample.png" width=50%>

Sometimes the aspect ratios of images we need to work with don't quite fit within the confines of our UIImageViews.

In most cases we can use AspectFill to fit the image to the bounds of a UIImageView without stretching or leaving whitespace, however when it comes to photos of people, it's quite often to have the faces cropped out if they're not perfectly centered.

This is where FaceAware comes in.
It will analyse an image either through `UIImageView`'s `image` property, or one you set using one of the built in functions and focus in on any faces it can find within.

The most common use for FaceAware is with avatars. 

With FaceAware your users will no longer have to crop and adjust their profile pictures.

<img src="https://raw.githubusercontent.com/BeauNouvelle/FaceAware/master/Images/largeExample.jpg" width=50%>

Based on these two older projects:

* [BetterFace-Swift](https://github.com/croath/UIImageView-BetterFace-Swift)
* [FaceAwareFill](https://github.com/Julioacarrettoni/UIImageView_FaceAwareFill)

Both of which don't seem to be maintained anymore.

##Requirements##
* Swift 3.0
* iOS 8.0+
* Xcode 8

##Installation##
####Manual####
Simply drag `UIImageView+FaceAware.swift` into your project. 

There's one for Swift 3.0 and 2.3 however the example project will only run in Xcode 8.

####Cocoapods####
- Add `pod 'FaceAware'` to your pod file.
- Add `import FaceAware` to the top of your files where you wish to use it.

##Useage##
There are a few ways to get your image views focussing in on faces within images.

####Interface Builder####
This is the easiest method and doesn't require writing any code.
The extension makes use of `@IBDesignable` and `@IBInspectable` so you can turn on focusOnFaces from within IB. However you won't actually see the extension working until you run your project.

<img src="https://raw.githubusercontent.com/BeauNouvelle/FaceAware/master/Images/inspectable.png" width=40%>

####Code####
You can set `focusOnFaces` to `true`.

```
someImageView.focusOnFaces = true
```
Be sure to set this *after* setting your image. If no image is present when this is called, there will be no faces to focus on.

------

Alternatively you can use:

```
someImageView.set(image: myImage, focusOnFaces: true)
```
Which elimates the worry of not having an image previously set.

##More help? Questions?##
Reach out to me on Twitter [@beaunouvelle](https://twitter.com/BeauNouvelle)

##Future Plans##
- [ ] Add an option to only focus on largest/closest face in photo.
- [ ] Debug mode. Draw rectangles around detected faces.

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
