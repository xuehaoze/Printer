//
//  Block.swift
//  Ticket
//
//  Created by gix on 2019/6/30.
//  Copyright © 2019 gix. All rights reserved.
//

import Foundation

public protocol Printable {
    func data(using encoding: String.Encoding) -> Data
}

public protocol BlockDataProvider: Printable { }

public protocol Attribute {
    var attribute: [UInt8] { get }
}

public struct Block: Printable {

    public static var defaultFeedPoints: UInt8 = 70
    
    private let feedPoints: UInt8
    private let dataProvider: BlockDataProvider
    
    /// Acrossor - Thomas: immediatePrint is a boolean value that indicate wether the content of this block should be printed immediately
    /// Default value is true, block will be print in a single line
    let immediatePrint:Bool
    
    public init(_ dataProvider: BlockDataProvider, feedPoints: UInt8 = Block.defaultFeedPoints, immediatePrint:Bool=true) {
        self.feedPoints = feedPoints
        self.dataProvider = dataProvider
        self.immediatePrint = immediatePrint
    }
    
    /// Acrossor - Thomas: If immediatePrint = false, means continue printing is required, so eliminate the trailing print command
    public func data(using encoding: String.Encoding) -> Data {
        var returnData = dataProvider.data(using: encoding)
        if immediatePrint {
            returnData += Data.printAndFeed(points: feedPoints)
        }
        return  returnData
    }
}

/// Acrossor - Thomas: Preset type for block blank function
public enum BlockBlankType {
    case full, half
}

public extension Block {
    /// Acrossor - Thomas: cut command to cut the paper
    static let cut = Block(Cut())
    
    /// Acrossor - Thomas: Print and clear existing buffer with default feed. Must be called after each continue printing
    static let printAndClearBuffer = Block(PrintAndClearBuffer(), immediatePrint: false)
    
    /// Acrossor - Thomas: Draw a full-width dividing line using character.
    static func fullWidthDivider(dividingChar:Character="-") -> Block {
        return Block(Text.fullWidthDivider(dividingChar: dividingChar))
    }
    
    /// Acrossor - Thomas: Indent starting point by x tabs
    static func tabIndent(step:Int=1) -> Block {
        return Block(TabIndent(step: step), immediatePrint: false)
    }
    
    /// Acrossor - Thomas: user can feed any points by giving blank type and repeat times
    static func blank(type: BlockBlankType = .full, repeated:UInt8 = 1) -> Block {
        var feedPoints:UInt8 = 0
        switch type {
        case .full:
            feedPoints = Block.defaultFeedPoints
        case .half:
            feedPoints = Block.defaultFeedPoints/2
        }
        
        if repeated > 1 {
            feedPoints *= repeated
        }
        return Block(Blank(), feedPoints: feedPoints)
    }
    
    
    // qr
    static func qr(_ content: String) -> Block {
        return Block(QRCode(content))
    }
    
    /// title: the same with: Text(content: content, predefined: .alignment(.center), .scale(.l1))
    static func title(_ content: String) -> Block {
        return Block(Text.title(content))
    }
    
    /// plain text: the same with: Text(content: content, predefined: .alignment(.left), .scale(.l0))
    static func plainText(_ content: String) -> Block {
        return Block(Text.init(content))
    }
    
    static func text(_ text: Text, immediatePrint:Bool=true) -> Block {
        return Block(text, immediatePrint: immediatePrint)
    }
    
    // key    value
    static func kv(k: String, v: String) -> Block {
        return Block(Text.kv(k: k, v: v))
    }
    
    /// Acrossor - Thomas: exsiting bug. Image width has to be multiple of 8
    static func image(_ im: Image, attributes: TicketImage.PredefinedAttribute...) -> Block {
        return Block(TicketImage(im, attributes: attributes))
    }
    
}
