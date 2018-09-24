//
//  DocumentInspectorViewController.swift
//  EmojiDrawerDoc
//
//  Created by Paula Boules on 9/24/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class DocumentInspectorViewController: UIViewController {
    
    var document : EmojiDrawerDocument? {
        didSet{
            self.updateDocument()
        }
    }
    
    var shortDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updateDocument(){
        if self.sizeLabel != nil, self.creationLabel != nil, let url = document?.fileURL,
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let date = attributes[.creationDate] as? Date {
                creationLabel.text = shortDateFormatter.string(from: date)
            }
            
            if let documentThumbnail = document?.thmbnail, thumbnailAspectRatio != nil {
               
                thumbnail.image = documentThumbnail
                 thumbnail.removeConstraint(thumbnailAspectRatio)
                thumbnailAspectRatio =  NSLayoutConstraint(
                    item: thumbnail,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: thumbnail,
                    attribute: .height,
                    multiplier: (thumbnail.image?.size.width)! / (thumbnail.image?.size.height)!,
                    constant: 0
                )
                thumbnail.addConstraint(thumbnailAspectRatio)
                
                if presentationController is UIPopoverPresentationController {
                    thumbnail!.isHidden = true
                    returnButton.isHidden = true
                    view.backgroundColor = .clear
                }
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let fittedSize = topLevelStackView?.sizeThatFits(UILayoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: fittedSize.width + 30 , height: fittedSize.height + 30)        }
    }

    @IBOutlet weak var topLevelStackView: UIStackView!
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var creationLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    
    @IBAction func done() {
        
        presentingViewController?.dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDocument()
    }
    
}
