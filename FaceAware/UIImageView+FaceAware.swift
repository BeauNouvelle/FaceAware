//
//  UIImageView+FaceAware.swift
//  FaceAware
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Beau Nouvelle
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import ObjectiveC

private var closureKey: UInt = 0
private var debugKey: UInt = 1

@IBDesignable
extension UIImageView: Attachable {

    @IBInspectable
    /// Adds a red bordered rectangle around any faces detected.
    public var debugFaceAware: Bool {
        set {
            set(newValue, forKey: &debugKey)
        } get {
            guard let debug = getAttach(forKey: &debugKey) as? Bool else {
                return false
            }
            return debug
        }
    }

    @IBInspectable
    /// Set this to true if you want to center the image on any detected faces.
    public var focusOnFaces: Bool {
        set {
            let image = self.image
            set(image: image, focusOnFaces: newValue)
        } get {
            return sublayer() != nil ? true : false
        }
    }

    public func set(image: UIImage?, focusOnFaces: Bool) {
        guard focusOnFaces == true else {
            self.removeImageLayer(image: image)
            return
        }
        setImageAndFocusOnFaces(image: image)
    }

    /// You can provide a closure here to receive a callback for when all face
    /// detection and image adjustments have been finished.
    public var didFocusOnFaces: (() -> Void)? {
        set {
            set(newValue, forKey: &closureKey)
        } get {
            return getAttach(forKey: &closureKey) as? (() -> Void)
        }
    }

    private func setImageAndFocusOnFaces(image: UIImage?) {
        DispatchQueue.global(qos: .default).async {
            guard let image = image else {
                return
            }

            guard let ciImage = CIImage(image: image) else {
                return
            }

            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
            let features = detector!.features(in: ciImage)

            if !features.isEmpty {
                if self.debugFaceAware {
                    print("found \(features.count) faces")
                }
                let imgSize = CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
                self.applyFaceDetection(for: features, size: imgSize, image: image)
            } else {
                if self.debugFaceAware {
                    print("No faces found")
                }
                self.removeImageLayer(image: image)
            }
        }
    }

    private func applyFaceDetection(for features: [CIFeature], size: CGSize, image: UIImage) {
        var rect = features[0].bounds
        rect.origin.y = size.height - rect.minY - rect.height
        var rightBorder = Double(rect.minX + rect.width)
        var bottomBorder = Double(rect.minY + rect.height)

        for feature in features.dropFirst() {
            var oneRect = feature.bounds
            oneRect.origin.y = size.height - oneRect.minY - oneRect.height
            rect.origin.x = min(oneRect.minX, rect.minX)
            rect.origin.y = min(oneRect.minY, rect.minY)

            rightBorder = max(Double(oneRect.minX + oneRect.width), Double(rightBorder))
            bottomBorder = max(Double(oneRect.minY + oneRect.height), Double(bottomBorder))
        }

        rect.size.width = CGFloat(rightBorder) - rect.minX
        rect.size.height = CGFloat(bottomBorder) - rect.minY

        var offset = CGPoint.zero
        var finalSize = size

        DispatchQueue.main.async {
            if size.width / size.height > self.bounds.width / self.bounds.height {
                var centerX = rect.minX + rect.width / 2.0

                finalSize.height = self.bounds.height
                finalSize.width = size.width / size.height * finalSize.height
                centerX = finalSize.width / size.width * centerX

                offset.x = centerX - self.bounds.width * 0.5
                if offset.x < 0 {
                    offset.x = 0
                } else if offset.x + self.bounds.width > finalSize.width {
                    offset.x = finalSize.width - self.bounds.width
                }
                offset.x = -offset.x
            } else {
                var centerY = rect.minY + rect.height / 2.0

                finalSize.width = self.bounds.width
                finalSize.height = size.height / size.width * finalSize.width
                centerY = finalSize.width / size.width * centerY

                offset.y = centerY - self.bounds.height * CGFloat(1-0.618)
                if offset.y < 0 {
                    offset.y = 0
                } else if offset.y + self.bounds.height > finalSize.height {
                    finalSize.height = self.bounds.height
                    offset.y = finalSize.height
                }
                offset.y = -offset.y
            }
        }
        
        let newImage: UIImage
        if self.debugFaceAware {
            newImage = drawDebugRectangles(from: image, size: size, features: features)
        } else {
            newImage = image
        }

        DispatchQueue.main.sync {
            self.image = newImage

            let layer = self.imageLayer()
            layer.contents = newImage.cgImage
            layer.frame = CGRect(origin: offset, size: finalSize)
            self.didFocusOnFaces?()
        }
    }

    private func drawDebugRectangles(from image: UIImage, size: CGSize, features: [CIFeature]) -> UIImage {
        // Draw rectangles around detected faces
        let rawImage = UIImage(cgImage: image.cgImage!)
        UIGraphicsBeginImageContext(size)
        rawImage.draw(at: .zero)

        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(3)

        features.forEach({
            var faceViewBounds = $0.bounds
            faceViewBounds.origin.y = size.height - faceViewBounds.minY - faceViewBounds.height

            context?.addRect(faceViewBounds)
            context?.drawPath(using: .stroke)
        })

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    private func imageLayer() -> CALayer {
        if let layer = sublayer() {
            return layer
        }

        let subLayer = CALayer()
        subLayer.name = "AspectFillFaceAware"
        subLayer.actions = ["contents": NSNull(), "bounds": NSNull(), "position": NSNull()]
        layer.addSublayer(subLayer)
        return subLayer
    }

    private func removeImageLayer(image: UIImage?) {
        DispatchQueue.main.async {
            // avoid redundant layer when focus on faces for the image of cell specified in UITableView
            self.imageLayer().removeFromSuperlayer()
            self.image = image
        }
    }

    private func sublayer() -> CALayer? {
        return layer.sublayers?.first { $0.name == "AspectFillFaceAware" }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if focusOnFaces {
            setImageAndFocusOnFaces(image: self.image)
        }
    }

}
