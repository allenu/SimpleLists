//
//  ViewController.swift
//  SimpleLists
//
//  Created by Allen Ussher on 3/11/17.
//  Copyright © 2017 Ussher Press. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    var oldSelectedRow: Int = -1
    
    // This will return nil if we're not in a parent window!
    var document: Document? {
        return self.view.window?.windowController?.document as? Document
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = NSNib(nibNamed: String(describing: TableCellView.self), bundle: Bundle.main)
        tableView.register(nib!, forIdentifier: String(describing: TableCellView.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func didEnterName(sender: NSTextField) {
        guard let document = document else { return }

        let name = sender.stringValue
        if name.lengthOfBytes(using: .utf8) > 0 {
            let index = document.numNames
            self.add(name: name, at: index)
            undoManager?.setActionName("Add \"\(name)\"")
            sender.stringValue = ""
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 51 || theEvent.keyCode == 117 { // Backspace or delete
            interpretKeyEvents([theEvent])
        } else {
            super.keyDown(with: theEvent)
        }
    }
    
    override func deleteBackward(_ sender: Any?) {
        guard let document = document else { return }

        let index = oldSelectedRow
        if index != -1, let name = document.name(atIndex: index) {
            remove(at: index)
            undoManager?.setActionName("Remove \"\(name)\"")
        }
    }
    
    
    func add(name: String, at index: Int) {
        guard let document = document else { return }
        
        document.add(name: name, at: index)
        
        undoManager?.registerUndo(withTarget: self, handler: { targetSelf in
            targetSelf.remove(at: index)
            self.reloadData()
        })
        reloadData()
    }
    
    func remove(at index: Int) {
        guard let document = document else { return }

        if let name = document.name(atIndex: index) {
            document.remove(at: index)
            
            undoManager?.registerUndo(withTarget: self, handler: { targetSelf in
                targetSelf.add(name: name, at: index)
            })
            
            reloadData()
        }
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return document?.numNames ?? 0
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let name = document?.name(atIndex: row) {
            let cellView = tableView.make(withIdentifier: String(describing: TableCellView.self), owner: self) as! TableCellView
            cellView.setup(text: name)
            
            return cellView
        } else {
            return nil
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        var indexSetToReload = IndexSet()
        if oldSelectedRow != -1 {
            indexSetToReload.insert(oldSelectedRow)
        }
        oldSelectedRow = tableView.selectedRow
    }
}
