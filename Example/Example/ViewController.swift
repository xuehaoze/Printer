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
        let url = "myfod.ca"
        var ticket = Ticket(
//            .blank,
//            .title("Restaurant"),
//            .blank,
//
//            .plainText("Palo Alto Californlia 94301"),
//            .plainText("378-0987893742"),
//            .blank,
            .image(image, attributes: .alignment(.center)),
            .text(.init(content: "123", predefined: .alignment(.center), .bold), immediatePrint: false),
            .tabIndent(),
            .text(.init(content: "abc", predefined: .alignment(.left), .unbold), immediatePrint: false),
            .printAndClearBuffer,
            .fullWidthDivider(),
            .text(.init(content: "123456789*123456789*123456789*123456789*12345678", predefined: .alignment(.left), .unbold), immediatePrint: true),
            .qr(url),
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
            .blank(),
            .plainText("full blank testing (above)"),
            .blank(type: .half),
            .plainText("half blank testing (above)"),
            .blank(type: .full, repeated: 3),
            .plainText("3 blanks testing (above)")
        )
        
//        ticket.add(blocks: lineStyleFormat())
//        ticket.add(blocks: lineStyleFormat())
        ticket.add(block: .cut)
        ticket.feedLinesOnHead = 0
        ticket.feedLinesOnTail = 0
        
        if bluetoothPrinterManager.canPrint {
            bluetoothPrinterManager.print(ticket)
        }
        
//        dummyPrinter.print(ticket)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BluetoothPrinterSelectTableViewController {
            vc.sectionTitle = "Choose Bluetooth Printer"
            vc.printerManager = bluetoothPrinterManager
        }
    }
}
