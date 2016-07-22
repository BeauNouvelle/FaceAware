//
//  UIImageView+FacesFill.swift
//  FacesFill
//
//  Created by Beau Nouvelle on 22/7/16.
//  Copyright © 2016 Pear Pi. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    
    public func focusOnFaces() {
        DispatchQueue.global(attributes: .qosDefault).async {
            
            if self.image == nil {
                return
            }
            
            var cImage = self.image!.ciImage
            if cImage == nil {
                cImage = CIImage(cgImage: self.image!.cgImage!)
            }
            
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])
            let features = detector!.features(in: cImage!)
            
            if features.count > 0 {
                print("found \(features.count) faces")
                let imgSize = CGSize(width: Double(self.image!.cgImage!.width), height: (Double(self.image!.cgImage!.height)))
                self.applyFaceDetection(for: features, size: imgSize)
            } else {
                print("No faces found")
                DispatchQueue.main.async {
                    self.imageLayer().removeFromSuperlayer()
                }
            }
        }
        
    }
    
    private func applyFaceDetection(for features: [AnyObject], size: CGSize) {
        
        var rect = CGRect.zero
        var rightBorder = 0.0
        var bottomBorder = 0.0
        
        for feature in features {
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
        
        DispatchQueue.main.sync {
            let layer = self.imageLayer()
            layer.frame = CGRect(x: offset.x, y: offset.y, width: finalSize.width, height: finalSize.height)
            layer.contents = self.image!.cgImage
        }
    }
    
    private func imageLayer() -> CALayer {
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                if layer.name == "AspectFillFaceAware" {
                    return layer
                }
            }
        }
        let subLayer = CALayer()
        subLayer.name = "AspectFillFaceAware"
        subLayer.actions = ["contents":NSNull(), "bounds":NSNull(), "position":NSNull()]
        layer.addSublayer(subLayer)
        return subLayer
    }
    
}
