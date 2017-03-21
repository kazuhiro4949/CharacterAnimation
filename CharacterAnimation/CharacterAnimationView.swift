//
//  CharacterAnimationView.swift
//  CharacterAnimation
//
//  Created by kahayash on 2017/03/22.
//  Copyright © 2017年 kazuhiro hayashi. All rights reserved.
//

import UIKit

class CharacterAnimationView: UIView {

    var font: UIFont = UIFont.systemFont(ofSize: 17)
    var text: String?
    var textColor: UIColor = UIColor.black
    
    private var letterLayer = [CAShapeLayer]()
    private var suggestedSize = CGSize.zero
    
    func create() {
        guard let text = text else {
            return
        }
        
        layer.sublayers?.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        
        var letterPaths = [UIBezierPath]()
        var letterPositions = [CGPoint]()
        do {
            let ctFont = CTFontCreateWithName(font.fontName as CFString?, font.pointSize, nil)
            let attr: [String: AnyObject] = [kCTFontAttributeName as String: ctFont]
            let attrString = NSAttributedString(string: text, attributes: attr)
            
            let frameSetter = CTFramesetterCreateWithAttributedString(attrString)
            suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, attrString.string.characters.count), nil, CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude), nil)
            let textPath = CGPath(rect: CGRect(origin: CGPoint.zero, size: suggestedSize), transform: nil)
            let textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), textPath, nil)
            
            let lines = CTFrameGetLines(textFrame)
            var origins = Array<CGPoint>(repeating: .zero, count: CFArrayGetCount(lines as CFArray))
            CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), &origins)
            
            for lineIndex in 0..<CFArrayGetCount(lines) {
                let unmergedLine = CFArrayGetValueAtIndex(lines as CFArray, lineIndex)
                let line = unsafeBitCast(unmergedLine, to: CTLine.self)
                let lineOrigin = origins[lineIndex]
                
                let runs = CTLineGetGlyphRuns(line)
                for runIndex in 0..<CFArrayGetCount(runs) {
                    let runPointer = CFArrayGetValueAtIndex(runs, runIndex)
                    let run = unsafeBitCast(runPointer, to: CTRun.self)
                    let attributes = CTRunGetAttributes(run)
                    
                    let fontPointer = CFDictionaryGetValue(attributes, Unmanaged.passRetained(kCTFontAttributeName).toOpaque())
                    let font = unsafeBitCast(fontPointer, to: CTFont.self)
                    
                    let glyphCount = CTRunGetGlyphCount(run)
                    
                    for glyphIndex in 0..<glyphCount {
                        let glyphRange = CFRangeMake(glyphIndex, 1)
                        var glyph = CGGlyph()
                        var position = CGPoint.zero
                        CTRunGetGlyphs(run, glyphRange, &glyph)
                        CTRunGetPositions(run, glyphRange, &position)
                        position.y = lineOrigin.y
                        
                        var aRect = CGRect.zero
                        CTFontGetBoundingRectsForGlyphs(font, .default, &glyph, &aRect, 1)
                        
                        let offset = CTLineGetOffsetForStringIndex(line, glyphIndex, nil)
                        
                        aRect.origin.x += offset
                        aRect.origin.y += origins[lineIndex].y
                        if let path = CTFontCreatePathForGlyph(font, glyph, nil) {
                            letterPaths.append(UIBezierPath(cgPath: path))
                            letterPositions.append(position)
                        }
                    }
                }
            }
        }
        
        let containerLayer = CALayer()
        containerLayer.isGeometryFlipped = true
        containerLayer.frame = self.layer.bounds
        layer.addSublayer(containerLayer)
        letterPaths.enumerated().forEach { (index, path) in
            let glyphLayer: CAShapeLayer = {
                let pos = letterPositions[index]
                $0.path = path.cgPath
                $0.fillColor = textColor.cgColor
                $0.frame.origin = CGPoint(x: pos.x, y: pos.y - suggestedSize.height)
                return $0
            }(CAShapeLayer())

            containerLayer.addSublayer(glyphLayer)
            
            letterLayer.append(glyphLayer)
        }
    }
    
    func fadeout(shafflelayers: [CAShapeLayer]) {
        shafflelayers.enumerated().forEach { (index, layer) in
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
    
    func falldown(shaffleLayers: [CAShapeLayer]) {
        shaffleLayers.enumerated().forEach { (index, layer) in
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var shaffleLayers = letterLayer
        for index in 0..<shaffleLayers.count {
            let newIndex = Int(arc4random_uniform(UInt32(shaffleLayers.count - 1)))
            if index != newIndex {
                swap(&shaffleLayers[index], &shaffleLayers[newIndex])
            }
        }
        
        fadeout(shafflelayers: shaffleLayers)
    }
    
    override var intrinsicContentSize: CGSize {
        return suggestedSize
    }


}
