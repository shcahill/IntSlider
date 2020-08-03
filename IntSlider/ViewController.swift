//
//  ViewController.swift
//  IntSlider
//
//  Created by kosuke matsumura on 2020/08/03.
//  Copyright © 2020 kosuke matsumura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var slider: IntSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.updateMaxValue(5)
    }
}

