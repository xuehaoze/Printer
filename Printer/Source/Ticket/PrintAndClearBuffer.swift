//
//  Cut.swift
//  Pods-Example
//
//  Created by Acrossor - Thomas Xue on 2020-06-26.
//

import Foundation

/// Special printing procedure for continue printing.
/// Normal printing procedure would be: clear buffer command + actual content + print and feed command
/// This producedure is: print and feed command + clear buffer command
struct PrintAndClearBuffer: BlockDataProvider {
    func data(using encoding: String.Encoding) -> Data {
        return Data.print(Block.defaultFeedPoints) + Data.reset
    }
}
