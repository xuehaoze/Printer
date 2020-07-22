//  ImageBlock.swift
//  Printer
//
//  Created by Pradeep Sakharelia on 18/05/2019.
//  Copyright © 2019 Quick Key Business Solutions. All rights reserved.
//

import Foundation

public struct TicketImage: BlockDataProvider {
    
    private let image: Image
    private let attributes: [Attribute]?
    
    public init(_ image: Image, attributes: [Attribute]? = nil) {
        // Acrossor - Thomas: exsiting bug. Image width has to be multiple of 8
        var tempImage = image
        if tempImage.ticketImage.width % 8 != 0 {
            tempImage = UIImage(cgImage: CGImage.resizePrinterTicketImageWidth(originalImage: image.ticketImage))
        }
        self.image = tempImage
        self.attributes = attributes
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        var result = Data()
        
        if let attrs = attributes {
            result.append(Data(attrs.flatMap { $0.attribute }))
        }
        
        if let data = image.ticketData {
            result.append(data)
        }
        
        return result
    }
    
    
    
}

public extension TicketImage {
    
    enum PredefinedAttribute: Attribute {
        
        case alignment(NSTextAlignment)
        
        public var attribute: [UInt8] {
            switch self {
            case let .alignment(v):
                return ESC_POSCommand.justification(v == .left ? 0 : v == .center ? 1 : 2).rawValue
            }
        }
    }
    
}

// Acrossor - Thomas: Since printing image has a bug, we have to ensure ticketImage width be a multiple of 8
extension CGImage {
    /// Resize cgimage to confirm Printer printing requirments (ie. image.width % 8 = 0)
    static func resizePrinterTicketImageWidth(originalImage:CGImage)->CGImage {
        guard originalImage.width % 8 != 0 else {
            // image width can be divided by 8, no need to redraw
            return originalImage
        }
        var newWidth = originalImage.width
        newWidth -= newWidth % 8
        let newSize = CGSize(width: newWidth, height: originalImage.height)
        
        let image = UIImage(cgImage: originalImage)
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        
        return newImage.cgImage!
    }
}
