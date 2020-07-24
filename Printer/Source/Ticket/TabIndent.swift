//
//  TabIndent.swift
//  Printer
//
//  Created by Acrossor - Thomas Xue on 2020-07-23.
//

import Foundation

/// Indent start point by one Tab
struct TabIndent: BlockDataProvider {
    let step:Int
    
    init(step:Int=1) {
        self.step = step
    }
    
    func data(using encoding: String.Encoding) -> Data {
        var data = Data(esc_pos: .indentWithTab())
        var count = step - 1
        
        while count > 0 {
            data += Data(esc_pos: .indentWithTab())
            count -= 1
        }
        return data
    }
}
