//
//  ViewController.swift
//  onboarding_task
//
//  Created by Krishna Soni on 19/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imgClView: ImageCollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func valueDidChange(_ textField: UITextField) {
        imgClView.didSearch?(textField.text)
    }
    
}


