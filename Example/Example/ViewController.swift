//
//  ViewController.swift
//  Example
//
//  Created by GongXiang on 12/8/16.
//  Updated by Pradeep Sakharelia on 15/05/19
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit
import Printer

class ViewController: UIViewController {

    private let bluetoothPrinterManager = BluetoothPrinterManager()
    private let dummyPrinter = DummyPrinter()
 
    @IBAction func touchPrint(sender: UIButton) {

        guard let image = UIImage(named: "receipt_logo") else {
            return
        }

        var ticket = Ticket(
//            .blank,
//            .title("Restaurant"),
//            .blank,
//
//            .plainText("Palo Alto Californlia 94301"),
//            .plainText("378-0987893742"),
//            .blank,
//            .image(image, attributes: .alignment(.center)),
            .text(.init(content: "123", predefined: .alignment(.center), .bold), immediatePrint: false),
            .tabIndent(),
            .text(.init(content: "abc", predefined: .alignment(.left), .unbold), immediatePrint: false),
            .printAndClearBuffer,
            .fullWidthDivider(),
            .text(.init(content: "123456789*123456789*123456789*123456789*12345678", predefined: .alignment(.left), .unbold), immediatePrint: true)
//            .blank,
//            .kv(k: "Merchant ID:", v: "iceu1390"),
//            .kv(k: "Terminal ID:", v: "29383"),
//            .blank,
//            .kv(k: "Transaction ID:", v: "0x000321"),
//            .plainText("PURCHASE"),
//            .blank,
//            .kv(k: "Sub Total", v: "USD$ 25.09"),
//            .kv(k: "Tip", v: "3.78"),
//            .dividing,
//            .kv(k: "Total", v: "USD$ 28.87"),
//            .blank(3),
//            Block(Text(content: "Thanks for supporting", predefined: .alignment(.center))),
            
        )
        
        ticket.add(blocks: lineStyleFormat())
        ticket.add(blocks: lineStyleFormat())
        ticket.add(block: .cut)
        ticket.feedLinesOnHead = 0
        ticket.feedLinesOnTail = 3
        
        if bluetoothPrinterManager.canPrint {
            bluetoothPrinterManager.print(ticket)
        }
        
//        dummyPrinter.print(ticket)
        
    }
    
    func lineStyleFormat() -> [Block] {
        let qty_start_str = String(repeating: " ", count: 2)
        let qty_length = 4
        let space_between_qty_name = " "
        let name_start_str = String(repeating: " ", count: 7)
        let name_length = 30
        // Can't decide until first line of dish name is confirmed. space =
        let space_between_name_total = String(repeating: " ", count: 2)
//        let total_start_pos = 39
        let total_length = 8
        let option_start_str = String(repeating: " ", count: 8)
        let option_length = 30
        
        let dishQty = "2x"
        let dishPrice = "$12.99"
//        let dishName = "123456789*123456789*123456789*123456789*123456789*"
        let dishName = "123456789*123"
        let options = ["option 1", "option 2", "option 123456789*123456789*123456789*123456789*"]
        
        let dishQtyStr = dishQty + String(repeating: " ", count: qty_length - dishQty.count)
        let totalStr = String(repeating: " ", count: total_length - dishPrice.count) + dishPrice
        let dishNameArray = dishName.components(withLength: name_length)
        var optionArray = [[String]]()
        
        for option in options {
            let tempArray = option.components(withLength: option_length)
            optionArray.append(tempArray)
        }
        
        // each line is a String. Special case for the fist line of dish name, and first line of each option name
        let dishNameLines:[String] = dishNameArray.enumerated().map { (index, value:String) in
            var dishLineStr = ""
            if index == 0 {
                let emptyPaddingAfterDishName = String(repeating: " ", count: name_length - value.count)
                dishLineStr = qty_start_str + dishQtyStr + space_between_qty_name + value + emptyPaddingAfterDishName + space_between_name_total + totalStr
            }
            else {
                dishLineStr = name_start_str + value
            }
            
            return dishLineStr
        }
        print(dishNameLines)
        
        let blocks:[Block] = dishNameLines.map { Block.plainText($0) }
        
        return blocks
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BluetoothPrinterSelectTableViewController {
            vc.sectionTitle = "Choose Bluetooth Printer"
            vc.printerManager = bluetoothPrinterManager
        }
    }
}

extension String {
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}
