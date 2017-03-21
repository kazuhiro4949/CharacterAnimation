//
//  ViewController.swift
//  CharacterAnimation
//
//  Created by kahayash on 2017/03/22.
//  Copyright © 2017年 kazuhiro hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let animView = CharacterAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animView.translatesAutoresizingMaskIntoConstraints = true
        animView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        animView.text = "You gods, will give us. Some faults to make us men."
        animView.font = UIFont.systemFont(ofSize: 17)
        animView.frame.origin = CGPoint(x: 50, y: 100)
        animView.frame.size.width = 400
        self.view.addSubview(animView)
        animView.create()
        animView.frame.size = animView.intrinsicContentSize
        animView.setNeedsLayout()
        animView.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

