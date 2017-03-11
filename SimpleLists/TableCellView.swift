//
//  TableCellView.swift
//  SimpleLists
//
//  Created by Allen Ussher on 3/11/17.
//  Copyright © 2017 Ussher Press. All rights reserved.
//

import Cocoa

class TableCellView: NSView {
    @IBOutlet weak var textField: NSTextField!
    
    func setup(text: String) {
        textField.stringValue = text
    }
}
