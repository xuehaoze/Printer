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
            returnData += Data.print(feedPoints)
        }
        return  returnData
    }
}

public extension Block {
    // blank line
    static var blank = Block(Blank())
    
    /// Acrossor - Thomas: cut command to cut the paper
    static let cut = Block(Cut())
    
    /// Acrossor - Thomas: Print and clear existing buffer with default feed. Must be called after each continue printing
    static let printAndClearBuffer = Block(PrintAndClearBuffer(), immediatePrint: false)
    
    static func blank(_ line: UInt8) -> Block {
        return Block(Blank(), feedPoints: Block.defaultFeedPoints * line)
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
    
    // dividing
    static var dividing = Block(Dividing.default)
    
    // image
    static func image(_ im: Image, attributes: TicketImage.PredefinedAttribute...) -> Block {
        return Block(TicketImage(im, attributes: attributes))
    }
    
}
