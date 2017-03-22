//
//  ViewController.swift
//  CharacterAnimation
//
//  Created by kahayash on 2017/03/22.
//  Copyright © 2017年 kazuhiro hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sampleView: CharacterAnimationView?
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fade(_ sender: UIButton) {
        guard let sampleView = sampleView else { return }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            fadein(with: sampleView.shaffle())
        } else {
            fadeout(with: sampleView.shaffle())
        }
    }

    @IBAction func fall(_ sender: UIButton) {
        guard let sampleView = sampleView else { return }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            fallin(with: sampleView.shaffle())
        } else {
            fallout(with: sampleView.shaffle())
        }
    }
    
    @IBAction func slide(_ sender: UIButton) {
        guard let sampleView = sampleView else { return }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            slidein(with: sampleView.shaffle())
        } else {
            slideout(with: sampleView.shaffle())
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetView()
    }
    
    func resetView() {
        self.sampleView?.removeFromSuperview()
        let sampleView = makeSampleView()
        sampleView.center.x = view.center.x
        sampleView.frame.origin.y = 150
        sampleView.create()
        self.view.addSubview(sampleView)
        self.sampleView = sampleView
    }
    
    func makeSampleView() -> CharacterAnimationView {
        let v = CharacterAnimationView()
        v.text = "You gods, will give us. Some faults to make us men."
        v.font = UIFont(name: "HoeflerText-Regular", size: 22)!
        v.translatesAutoresizingMaskIntoConstraints = true
        v.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        v.frame.size.width = 320
        return v
    }
}

