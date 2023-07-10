//
//  UIImage+CorneredRect.swift
//  CurrencyConverter
//
//  Created by Rost on 17.06.2023.
//

import UIKit

extension UIImage {
    /// Makes an image with rounded corners
    /// - Parameters:
    ///   - size: desired image size
    ///   - color: image fill color
    ///   - cornerRadius: corner radius
    /// - Returns: an image with rounded corners and filled with passed color
    static func corneredRect(size: CGSize, color: UIColor, cornerRadius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        let circlePath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        circlePath.addClip()
        UIGraphicsGetCurrentContext()?.addPath(circlePath.cgPath)
        UIGraphicsGetCurrentContext()?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Makes an image filled with color and with rounded corners. image is stretchable and rendered with template mode for background usage.
    /// This image inside an `UIImageView`  is faster than `CALayer`'s roundedCorners
    /// - Parameters:
    ///   - radius: corner radius
    ///   - color: color used to fill image
    ///   - cornerRadius: corner radius itself
    /// - Returns: an image ready to use as rounded corners background
    static func corneredRectBackground(radius: CGFloat, color: UIColor = .white, cornerRadius: CGFloat = 0) -> UIImage? {
        let size = CGSize(width: radius * 2 + 2, height: radius * 2 + 2)
        return UIImage
            .corneredRect(size: size, color: color, cornerRadius: radius)?
            .stretchableImage(withLeftCapWidth: Int(radius), topCapHeight: Int(radius))
            .withRenderingMode(.alwaysTemplate)
    }
}
