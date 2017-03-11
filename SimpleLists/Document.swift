//
//  Document.swift
//  SimpleLists
//
//  Created by Allen Ussher on 3/11/17.
//  Copyright © 2017 Ussher Press. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    fileprivate var names: [String] = []
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: names, options: .prettyPrinted)
        return data
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        if let names = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? [String] {
            self.names = names
        } else {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
    
    func touch() {
        self.updateChangeCount(.changeDone)
    }
}

//
// Public API
//

extension Document {
    var numNames: Int {
        return names.count
    }
    
    func name(atIndex index: Int) -> String? {
        if index >= 0 && index < names.count {
            return names[index]
        } else {
            return nil
        }
    }
    func add(name: String) {
        names.append(name)
        touch()
    }
    func add(name: String, at index: Int) {
        names.insert(name, at: index)
        touch()
    }
    
    func remove(at index: Int) {
        if index >= 0 && index < names.count {
            names.remove(at: index)
            touch()
        }
    }
}
