//
//  UIImageView+FacesFill.swift
//  FacesFill
//
//  Created by Beau Nouvelle on 22/7/16.
//  Copyright © 2016 Pear Pi. All rights reserved.
//

import UIKit
import ObjectiveC

@IBDesignable
public extension UIImageView {
    
    private struct AssociatedCustomProperties {
        static var debugFaceAware: Bool = false
    }
    
    @IBInspectable
    public var debugFaceAware: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedCustomProperties.debugFaceAware, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            guard let debug = objc_getAssociatedObject(self, &AssociatedCustomProperties.debugFaceAware) as? Bool else {
                return false
            }
            
            return debug
        }
    }
    
    @IBInspectable
    public var focusOnFaces: Bool {
        set {
            let image = self.image
            self.image = nil
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
    
    private func setImageAndFocusOnFaces(image: UIImage?) {
        DispatchQueue.global(qos: .default).async {
            guard let image = image else {
                return
            }
            
            let cImage = image.ciImage ?? CIImage(cgImage: image.cgImage!)
            
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])
            let features = detector!.features(in: cImage)
            
            if features.count > 0 {
                print("found \(features.count) faces")
                let imgSize = CGSize(width: Double(image.cgImage!.width), height: (Double(image.cgImage!.height)))
                self.applyFaceDetection(for: features, size: imgSize, image: image)
            } else {
                print("No faces found")
                self.removeImageLayer(image: image)
            }
        }
    }
    
    private func applyFaceDetection(for features: [AnyObject], size: CGSize, image: UIImage) {
        var rect = features[0].bounds!
        rect.origin.y = size.height - rect.origin.y - rect.size.height
        var rightBorder = Double(rect.origin.x + rect.size.width)
        var bottomBorder = Double(rect.origin.y + rect.size.height)
        
        for feature in features[1..<features.count] {
            var oneRect = feature.bounds!
            oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height
            rect.origin.x = min(oneRect.origin.x, rect.origin.x)
            rect.origin.y = min(oneRect.origin.y, rect.origin.y)
            
            rightBorder = max(Double(oneRect.origin.x + oneRect.size.width), Double(rightBorder))
            bottomBorder = max(Double(oneRect.origin.y + oneRect.size.height), Double(bottomBorder))
        }
        
        rect.size.width = CGFloat(rightBorder) - rect.origin.x
        rect.size.height = CGFloat(bottomBorder) - rect.origin.y
        
        var center = CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y + rect.size.height / 2.0)
        var offset = CGPoint.zero
        var finalSize = size
        
        if size.width / size.height > bounds.size.width / bounds.size.height {
            finalSize.height = self.bounds.size.height
            finalSize.width = size.width/size.height * finalSize.height
            center.x = finalSize.width / size.width * center.x
            center.y = finalSize.width / size.width * center.y
            
            offset.x = center.x - self.bounds.size.width * 0.5
            if (offset.x < 0) {
                offset.x = 0
            } else if (offset.x + self.bounds.size.width > finalSize.width) {
                offset.x = finalSize.width - self.bounds.size.width
            }
            offset.x = -offset.x
        } else {
            finalSize.width = self.bounds.size.width
            finalSize.height = size.height / size.width * finalSize.width
            center.x = finalSize.width / size.width * center.x
            center.y = finalSize.width / size.width * center.y
            
            offset.y = center.y - self.bounds.size.height * CGFloat(1-0.618)
            if offset.y < 0 {
                offset.y = 0
            } else if offset.y + self.bounds.size.height > finalSize.height {
                finalSize.height = self.bounds.size.height
                offset.y = finalSize.height
            }
            offset.y = -offset.y
        }
        
        var newImage: UIImage
        if self.debugFaceAware {
            // Draw rectangles around detected faces
            let rawImage = UIImage(cgImage: image.cgImage!)
            UIGraphicsBeginImageContext(size)
            rawImage.draw(at: CGPoint.zero)
            
            let context = UIGraphicsGetCurrentContext()
            context!.setStrokeColor(UIColor.red.cgColor)
            context!.setLineWidth(3)
            
            for feature in features[0..<features.count] {
                var faceViewBounds = feature.bounds!
                faceViewBounds.origin.y = size.height - faceViewBounds.origin.y - faceViewBounds.size.height
                
                context!.addRect(faceViewBounds)
                context!.drawPath(using: .stroke)
            }
            
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        } else {
            newImage = image
        }

        DispatchQueue.main.sync {
            self.image = newImage
            
            let layer = self.imageLayer()
            layer.contents = newImage.cgImage
            layer.frame = CGRect(x: offset.x, y: offset.y, width: finalSize.width, height: finalSize.height)
        }
    }
    
    private func imageLayer() -> CALayer {
        if let layer = sublayer() {
            return layer
        }
        
        let subLayer = CALayer()
        subLayer.name = "AspectFillFaceAware"
        subLayer.actions = ["contents":NSNull(), "bounds":NSNull(), "position":NSNull()]
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
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                if layer.name == "AspectFillFaceAware" {
                    return layer
                }
            }
        }
        return nil
    }
    
}
