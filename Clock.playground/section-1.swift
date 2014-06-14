// Clockground - noun: a place where people can clock

import UIKit
import QuartzCore

class ClockView: UIView {
    let backgroundLayer = CAShapeLayer()
    let faceLayer = CAShapeLayer()

    init() {
        super.init(frame: CGRectMake(0, 0, 256, 256))

        self.backgroundLayer.frame = self.bounds
        self.faceLayer.frame = self.bounds

        setUpBackgroundLayer()
        setUpFaceLayer()
        setUpHandsLayer()

        self.layer.addSublayer(self.backgroundLayer)
        self.layer.addSublayer(self.faceLayer)
    }

    func setUpBackgroundLayer() {
        let backgroundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 45)

        self.backgroundLayer.path = backgroundPath.CGPath
    }

    func setUpFaceLayer() {
        let faceInset = 15.0
        let faceRadius = 256-(2*faceInset)
        let numberRadius = 90.0
        let numberWidth = 22.0
        let numberHeight = 22.0

        let facePath = UIBezierPath(ovalInRect: CGRectMake(faceInset, faceInset, faceRadius, faceRadius))

        self.faceLayer.fillColor = UIColor.whiteColor().CGColor
        self.faceLayer.path = facePath.CGPath

        for hour in 1...12 {
            var hourtext = NSString(format: "%d", hour)

            let pct = Double(hour)/12
            let position = (pct*2*M_PI)-(M_PI_2)

            let xadj = cos(Double(position))
            let yadj = sin(Double(position))
            let xpos = 128.0 + (xadj*numberRadius) - (numberWidth/2)
            let ypos = 128.0 + (yadj*numberRadius) - (numberWidth/2)

            let text = CATextLayer()
            text.frame = CGRectMake(xpos, ypos, numberWidth, numberHeight)
            text.string = hourtext
            text.fontSize = 20
            text.font = UIFont(name: "HelveticaNeue-Light", size: 10)
            text.alignmentMode = kCAAlignmentCenter
            text.foregroundColor = UIColor.blackColor().CGColor

            self.faceLayer.addSublayer(text)
        }
    }

    func setUpHandsLayer() {

    }
}

let view = ClockView()
