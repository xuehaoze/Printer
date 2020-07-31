//
//  Ticket.swift
//  Ticket
//
//  Created by gix on 2019/6/30.
//  Copyright © 2019 gix. All rights reserved.
//

import Foundation

public struct Ticket {
    
    public var feedLinesOnTail: UInt8 = 3
    public var feedLinesOnHead: UInt8 = 0
    
    private var blocks = [Block]()
    
    public init(_ blocks: Block...) {
        self.blocks = blocks
    }
    
    public init(_ blocks:[Block]) {
        self.blocks = blocks
    }
    
    public mutating func add(block: Block) {
        blocks.append(block)
    }
    
    /// Acrossor - Thomas: batch edit for blocks in Ticket
    public mutating func add(blocks: [Block]) {
        self.blocks.append(contentsOf: blocks)
    }
    
    /// Acrossor - Thomas: Each Block in the ticket will be converted into a data. The data contains three parts:
    /// 1. initial (data.reset) command, to clear printer buffer and reset printer start point and settings for each line.
    /// 2. content, actual content of each block in data format.
    /// 3. trailing print command, data command that will trigger the print and clear the buffer (ESC J n, (27, 64, n))
    /// For continue printing(donot clear buffer and format until printAndClear command send), eliminate the heading reset command and trailing print command
    public func data(using encoding: String.Encoding) -> [Data] {
        // Acrossor - Thomas: check if the clock is in continue printing mode. if yes, eliminate head reset command and trailing print command
        var ds:[Data] = blocks.map {
            return $0.immediatePrint ? Data.reset + $0.data(using: encoding) : $0.data(using: encoding)
        }
        
        if feedLinesOnHead > 0 {
            ds.insert(Data(esc_pos: .printAndFeed(lines: feedLinesOnHead)), at: 0)
        }
        
        if feedLinesOnTail > 0 {
            ds.append(Data(esc_pos: .printAndFeed(lines: feedLinesOnTail)))
        }
        
        return ds
    }
}
