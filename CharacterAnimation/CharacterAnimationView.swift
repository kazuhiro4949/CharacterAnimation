//
//  CharacterAnimationView.swift
//  CharacterAnimation
//
//  Created by kahayash on 2017/03/22.
//  Copyright © 2017年 kazuhiro hayashi. All rights reserved.
//

import UIKit

protocol CharacterAnimator: class {
    var font: UIFont { get set }
    var textColor: UIColor  { get set }
    var layers: [CAShapeLayer] { get }
    
    func shaffle() -> [CAShapeLayer]
}

extension CharacterAnimator {
    func shaffle() -> [CAShapeLayer] {
        var shaffleLayers = layers
        for index in 0..<shaffleLayers.count {
            let newIndex = Int(arc4random_uniform(UInt32(shaffleLayers.count - 1)))
            if index != newIndex {
                swap(&shaffleLayers[index], &shaffleLayers[newIndex])
            }
        }
        return shaffleLayers
    }
}

class CharacterAnimationView: UIView, CharacterAnimator {

    var font: UIFont = UIFont.systemFont(ofSize: 17)
    var text: String?
    var textColor: UIColor = UIColor.black
    private(set) var layers = [CAShapeLayer]()
    
    private var suggestedSize = CGSize.zero
    
    func create() {
        guard let text = text else {
            return
        }

        layers.forEach {
            $0.removeAllAnimations()
            //$0.removeFromSuperlayer()
        }
        
        layer.sublayers?.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        
        layer.removeAllAnimations()
        
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
            
            layers.append(glyphLayer)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = suggestedSize
    }
    
    override var intrinsicContentSize: CGSize {
        return suggestedSize
    }
}
