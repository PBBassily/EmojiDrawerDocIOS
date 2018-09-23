//
//  DocumentBrowserViewController.swift
//  EmojiDrawerDoc
//
//  Created by Paula Boules on 9/23/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        allowsPickingMultipleItems = false
        allowsDocumentCreation = false
        
        templateDoc = try? FileManager.default.url(
            for: .applicationSupportDirectory ,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("Untitled.json")
        if templateDoc != nil {
            allowsDocumentCreation = FileManager.default.createFile(atPath: templateDoc!.path, contents: Data())
        }
               
        
        
        
    }
    
    
    var templateDoc : URL?
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        importHandler(templateDoc, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "EmojiDrawerMCV")
        if let emojiVC = documentViewController.contents as? EmojiViewController {
            emojiVC.document = EmojiDrawerDocument(fileURL: documentURL)
        }
        
        present(documentViewController, animated: true)
    }
}

