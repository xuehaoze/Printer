//
//  Cut.swift
//  Pods-Example
//
//  Created by Thomas Xue on 2020-06-26.
//

import Foundation

struct Cut: BlockDataProvider {
    func data(using encoding: String.Encoding) -> Data {
        return Data(esc_pos: .cut())
    }
}
