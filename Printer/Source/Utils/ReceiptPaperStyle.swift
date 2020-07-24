//
//  ReceiptPaperStyle.swift
//  Printer
//
//  Created by Acrossor - Thomas Xue on 2020-07-23.
//

import Foundation

/// Acrossor - Thomas: Define the page width in mm, density and character count
/// Default horizontal motion is 1/180 inch or 25.4/180 = 0.14 mm. Defined in GS P command.
/// Page width is calculated as 80mm/0.14 = 594;
/// and Printable width is calculated as 594 - 18(left + right margin) = 576
public enum ReceiptPaperStyle {
    case width80
    case width58
    
    /// Default font density is 12
    var defaultFontDensity:Int {
        return 12
    }
    
    /// Printable width is calculated as 594 - 18(left + right margin) = 576
    var getPrintableDensity:Int {
        switch self {
        case .width58:
            return 384
        case .width80:
            return 576
        }
    }
    
    /// calculation: printable density / font density
    var getWidthInChar:Int {
        switch self {
        case .width58:
            return 32
        case .width80:
            return 48
        }
    }
}
