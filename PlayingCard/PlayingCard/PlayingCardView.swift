//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Paramveer  on 2020-01-14.
//  Copyright © 2020 Paramveer . All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    @IBInspectable
    var rank:Int = 11 { didSet{  setNeedsDisplay() ; setNeedsLayout() }}
    @IBInspectable
    var suit:String = "♠︎" { didSet{  setNeedsDisplay() ; setNeedsLayout() }}
    @IBInspectable
    var isFaceUp:Bool = true { didSet{  setNeedsDisplay() ; setNeedsLayout() }}
    
    
    var faceCardScale = SizeRatio.faceCardImageToBoundsSize {didSet{ setNeedsDisplay()} }
    
   @objc func adjustFaceCardScale (byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
        switch recognizer.state{
        case .changed , .ended :
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [ .paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString:NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    lazy private var uppleLeftCornerLabel: UILabel = createCornerLabel()
    lazy private var lowerRightCornerLabel: UILabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configurCornerLabel(_ label :UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configurCornerLabel(uppleLeftCornerLabel)
        uppleLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffSet , dy: cornerOffSet)
        configurCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffSet, dy: -cornerOffSet)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        
        
    }
   
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
/*
        if let context = UIGraphicsGetCurrentContext(){
            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            context.setLineWidth(5.0)
            UIColor.green.setFill()
            UIColor.red.setStroke()
            context.fillPath()
        }
         
         
         //the path stays after draying in this case
         let path = UIBezierPath()
         path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
         path.lineWidth = 5.0
         UIColor.green.setFill()
         UIColor.red.setStroke()
         path.stroke()
         path.fill()
 */
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp{
            if let faceCardImage = UIImage(named: rankString + suit , in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback"){
                cardBackImage.draw(in: bounds)
            }
        }
        
      
        
    }
}

extension CGRect{
  
    var leftHalf: CGRect{
        return CGRect(x: minX , y:minY , width: width/2 , height: height)
    }
    var righHalf:CGRect{
        return CGRect(x: minX , y:minY , width: width/2 , height: height)
    }
    func sized(to size:CGSize) -> CGRect{
        return insetBy(dx: size.width, dy: size.height)
    }
    func zoom(by scale: CGFloat) -> CGRect{
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth), dy: (height - newHeight)/2 )
    }
    

}

extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint( x: x+dx, y: y+dy )
    }
}

extension PlayingCardView {
    private struct SizeRatio{
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffSet:CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize:CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString:String{
        switch rank {
            case 1: return "A"
            case 2...10 : return String(rank)
            case 11: return "J"
            case 12: return "Q"
            case 13: return"K"
            default: return "?"
        }
    }
}

