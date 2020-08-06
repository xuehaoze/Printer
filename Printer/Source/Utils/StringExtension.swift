//
//  StringExtension.swift
//  Printer
//
//  Created by Thomas Xue on 2020-08-05.
//

import Foundation


//MARK: - String extension
public extension String {
    /**
     Acrossor - Thomas:
     Split string into an array of substrings with each length of substrs equals to the given char length.
     char length is defined by ESC Pos, which alphabet char takes 1, and chinese letters takes 2.
     NOTE: for char between "\u{2E80}" and "\u{FE4F}", they are chinese chars, which take 2 char space.
     
     @param withEscCharCount Char count for every component.
     */
    func components(withEscCharCount length: Int) -> [String] {
        var components = [String]()
        var currentComponent = ""
        var remainingSpace = length
        
        // We will go through every character in the string
        for c in self {
            // Determin char width: chinese character takes 2 space. others takes 1 space
            let charWidth = ((c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}") ? 2 : 1
            
            if remainingSpace < charWidth {
                components.append(currentComponent)
                currentComponent = String(c)
                remainingSpace = length - charWidth
            }
            else {
                currentComponent.append(c)
                remainingSpace -= charWidth
            }
        }
        
        if !currentComponent.isEmpty {
            components.append(currentComponent)
        }
        
        return components
    }
    
    /**
    Acrossor - Thomas:
    Count the esc pos char width of the string.
    NOTE: for char between "\u{2E80}" and "\u{FE4F}", they are chinese chars, which take 2 char space. others take 1 char space
    */
    func escPosWidthCount()->Int {
        var strCharWidth = 0
        for c in self {
            let charWidth = ((c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}") ? 2 : 1
            strCharWidth += charWidth
        }
        return strCharWidth
    }
}
