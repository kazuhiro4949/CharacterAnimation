//
//  Functions.swift
//  CharacterAnimation
//
//  Created by kahayash on 2017/03/22.
//  Copyright © 2017年 kazuhiro hayashi. All rights reserved.
//

import UIKit

func fadeout(with layers: [CAShapeLayer]) {
    layers.enumerated().forEach { (index, layer) in
        let anim = CABasicAnimation()
        anim.keyPath = "opacity"
        anim.toValue = 0
        anim.duration = CFTimeInterval(0.5)
        anim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        layer.add(anim, forKey: "opacity")
    }
}

func fadein(with layers: [CAShapeLayer]) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    layers.forEach {
        $0.opacity = 0
    }
    CATransaction.commit()
    
    layers.enumerated().forEach { (index, layer) in
        let anim = CABasicAnimation()
        anim.keyPath = "opacity"
        anim.toValue = 1
        anim.duration = CFTimeInterval(0.5)
        anim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        layer.add(anim, forKey: "opacity")
    }
}

func slideout(with layers: [CAShapeLayer]) {
    layers.enumerated().forEach { (index, layer) in
        let anim = CABasicAnimation(keyPath: "position")
        var newPoint = layer.position
        newPoint.x += 20
        anim.toValue = NSValue(cgPoint: newPoint)
        
        let colorAnim = CABasicAnimation(keyPath: "opacity")
        colorAnim.toValue = NSNumber(value: 0)
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = CFTimeInterval(0.5)
        groupAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards
        groupAnim.animations = [anim, colorAnim]
        
        layer.add(groupAnim, forKey: "group")
    }
}

func slidein(with layers: [CAShapeLayer]) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    layers.forEach {
        $0.position.x -= 20
        $0.opacity = 0
    }
    CATransaction.commit()
    
    layers.enumerated().forEach { (index, layer) in
        let anim = CABasicAnimation(keyPath: "position")
        var newPoint = layer.position
        newPoint.x += 20
        anim.toValue = NSValue(cgPoint: newPoint)
        
        let colorAnim = CABasicAnimation(keyPath: "opacity")
        colorAnim.toValue = NSNumber(value: 1)
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = CFTimeInterval(0.5)
        groupAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards
        groupAnim.animations = [anim, colorAnim]
        
        layer.add(groupAnim, forKey: "group")
    }
}

func fallout(with layers: [CAShapeLayer]) {
    layers.enumerated().forEach { (index, layer) in
        let anim = CABasicAnimation(keyPath: "position")
        var newPoint = layer.position
        newPoint.y -= 50
        anim.toValue = NSValue(cgPoint: newPoint)
        
        let colorAnim = CABasicAnimation(keyPath: "opacity")
        colorAnim.toValue = NSNumber(value: 0)
        
        let arc: Double =  M_PI * (-500 + Double(arc4random_uniform(1000))) / 1000
        let translateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        translateAnim.toValue = NSNumber(value: arc)
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = CFTimeInterval(0.5)
        groupAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards
        groupAnim.animations = [anim, colorAnim, translateAnim]
        
        layer.add(groupAnim, forKey: "group")
    }
}

func fallin(with layers: [CAShapeLayer]) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    layers.forEach {
        $0.position.y += 50
        $0.opacity = 0
        let arc: Double =  M_PI * (-500 + Double(arc4random_uniform(1000))) / 1000
        $0.transform = CATransform3DRotate($0.transform, CGFloat(arc), 0, 0, 1)
    }
    CATransaction.commit()
    
    layers.enumerated().forEach { (index, layer) in
        let anim = CABasicAnimation(keyPath: "position")
        var newPoint = layer.position
        newPoint.y -= 50
        anim.toValue = NSValue(cgPoint: newPoint)
        
        let colorAnim = CABasicAnimation(keyPath: "opacity")
        colorAnim.toValue = NSNumber(value: 1)
        
        let translateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        translateAnim.toValue = NSNumber(value: 0)
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = CFTimeInterval(0.5)
        groupAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        groupAnim.animations = [anim, colorAnim, translateAnim]
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards
        layer.add(groupAnim, forKey: "group")
    }
}
