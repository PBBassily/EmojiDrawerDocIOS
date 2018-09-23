//
//  Document.swift
//  EmojiDrawerDoc
//
//  Created by Paula Boules on 9/23/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class EmojiDrawerDocument: UIDocument {
    
    var emojiModel : EmojiModel?
    var thmbnail : UIImage?
    override func contents(forType typeName: String) throws -> Any {
        
        return emojiModel?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let jsonData = contents as? Data {
            emojiModel = EmojiModel(jsonData: jsonData)
        }
    }
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumnail = self.thmbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] =
                [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumnail]
        }
        return attributes
    }
}

