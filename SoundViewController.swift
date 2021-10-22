//
//  SoundViewController.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 27/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import UIKit
import MediaPlayer

class SoundViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    //the ringtone is a bell.mp3
    private let numberOfRingtones = 1
    var id: String!
    var soundItem: MPMediaItem?
    var soundLabel: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems  mediaItemCollection:MPMediaItemCollection) -> Void {
        if !mediaItemCollection.items.isEmpty {
            let item = mediaItemCollection.items[0]
            
            self.soundItem = item
            id = (self.soundItem?.value(forProperty: MPMediaItemPropertyPersistentID)) as! String
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

