// Clockground - noun: a place where people can clock

import Cocoa
import QuartzCore
import XCPlayground

class ClockView: NSView {
    let backgroundLayer = CAShapeLayer()
    let faceLayer = CAShapeLayer()
    let handsLayer = CAShapeLayer()

    let clockSize = 256.0

    init() {
        super.init(frame: CGRectMake(0, 0, clockSize, clockSize))

        self.backgroundLayer.frame = self.bounds
        self.faceLayer.frame = self.bounds
        self.handsLayer.frame = self.bounds

        setUpBackgroundLayer()
        setUpFaceLayer()
        setUpHandsLayer()

        self.layer.addSublayer(self.backgroundLayer)
        self.layer.addSublayer(self.faceLayer)
        self.layer.addSublayer(self.handsLayer)
    }

    func setUpBackgroundLayer() {
//        let backgroundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 45)
        let backgroundPath = NSBezierPath(roundedRect: self.bounds, xRadius: 45, yRadius: 45)

        self.backgroundLayer.path = CGPathFromNSBezierPath(backgroundPath)
    }

    func setUpFaceLayer() {
        let faceInset = 15.0
        let faceRadius = clockSize-(2*faceInset)
        let numberRadius = 90.0
        let numberWidth = 22.0
        let numberHeight = 22.0

//        let facePath = UIBezierPath(ovalInRect: CGRectMake(faceInset, faceInset, faceRadius, faceRadius))
        let facePath = NSBezierPath(ovalInRect: CGRectMake(faceInset, faceInset, faceRadius, faceRadius))

        self.faceLayer.fillColor = NSColor.whiteColor().CGColor
        self.faceLayer.path = CGPathFromNSBezierPath(facePath)

        for hour in 1...12 {
            let hourtext = NSString(format: "%d", hour)

            let pct = Double(hour)/12
            let position = (pct*2*M_PI)-(M_PI_2)

            let xadj = cos(Double(position))
            let yadj = sin(Double(position))
//            XCPCaptureValue("cosvalue", xadj)
            let xpos = (clockSize/2) + (xadj*numberRadius) - (numberWidth/2)
            let ypos = (clockSize/2) + (yadj*numberRadius) - (numberWidth/2)

            let text = CATextLayer()
            text.frame = CGRectMake(xpos, ypos, numberWidth, numberHeight)
            text.string = hourtext
            text.fontSize = 20
            text.font = NSFont(name: "HelveticaNeue-Light", size: 10)
            text.alignmentMode = kCAAlignmentCenter
            text.foregroundColor = NSColor.blackColor().CGColor

            self.faceLayer.addSublayer(text)
        }
    }

    func setUpHandsLayer() {
        // look up time for hand values
        let format = NSDateFormatter()
        let now = NSDate()

        format.dateFormat = "hh"
        let hour = format.stringFromDate(now).toInt()!
        let hourRotation = 2.0*M_PI*(Double(hour)/12.0)

        format.dateFormat = "mm"
        let minute = format.stringFromDate(now).toInt()!
        let minuteRotation = 2.0*M_PI*(Double(minute)/60.0)

        format.dateFormat = "ss"
        let second = format.stringFromDate(now).toInt()!
        let secondRotation = 2.0*M_PI*(Double(second)/60.0)

        // style setup for the hands
        let darkCenter = CAShapeLayer()
        let darkSize = 13.0
        let redCenter = CAShapeLayer()
        redCenter.fillColor = NSColor.redColor().CGColor
        let redSize = 5.0

        // draw the black center circle
//        let darkPath = UIBezierPath(ovalInRect: CGRectMake((clockSize/2)-(darkSize/2), (clockSize/2)-(darkSize/2), darkSize, darkSize))
        let darkPath = NSBezierPath(ovalInRect: CGRectMake((clockSize/2)-(darkSize/2), (clockSize/2)-(darkSize/2), darkSize, darkSize))
        darkCenter.path = CGPathFromNSBezierPath(darkPath)

        self.handsLayer.addSublayer(darkCenter)

        // set up the minute hand
        let minuteWidth = 3.0
        let minuteHeight = 75.0
        let minuteStartPoint = CGPointMake((clockSize/2)-(minuteWidth/2), clockSize/2)

        // draw minute hand
        let minuteHand = CAShapeLayer()
        minuteHand.frame = CGRectMake(0, 0, clockSize, clockSize)
        minuteHand.fillColor = NSColor.blackColor().CGColor

        minuteHand.path = self.makeRectPath(minuteStartPoint, width: minuteWidth, height: minuteHeight)

        // anchor point is already 0.5,0.5 so we can just rotate
        minuteHand.transform = CATransform3DMakeRotation(minuteRotation, 0, 0, 1)

        self.handsLayer.addSublayer(minuteHand)

        // set up the hour hand
        let hourWidth = 4.0
        let hourHeight = 35.0
        let hourStartPoint = CGPointMake((clockSize/2)-(hourWidth/2), clockSize/2)

        // draw hour hand
        let hourHand = CAShapeLayer()
        hourHand.frame = CGRectMake(0, 0, clockSize, clockSize)
        hourHand.fillColor = NSColor.blackColor().CGColor

        hourHand.path = self.makeRectPath(hourStartPoint, width: hourWidth, height: hourHeight)

        // anchor point is already 0.5,0.5 so we can just rotate
        hourHand.transform = CATransform3DMakeRotation(hourRotation, 0, 0, 1)

        self.handsLayer.addSublayer(hourHand)

        // draw the red center bit over the black existing ones
//        let redPath = UIBezierPath(ovalInRect: CGRectMake((clockSize/2)-(redSize/2), (clockSize/2)-(redSize/2), redSize, redSize))
        let redPath = NSBezierPath(ovalInRect: CGRectMake((clockSize/2)-(redSize/2), (clockSize/2)-(redSize/2), redSize, redSize))
        redCenter.path = CGPathFromNSBezierPath(redPath)

        self.handsLayer.addSublayer(redCenter)

        // set up the seconds hand
        let secondWidth = 2.0
        let secondHeight = 65.0
        let secondStartPoint = CGPointMake((clockSize/2)-(secondWidth/2), clockSize/2)

        // draw the seconds hand
        let secondHand = CAShapeLayer()
        //        secondHand.backgroundColor = UIColor.greenColor().CGColor
        secondHand.frame = CGRectMake(0, 0, clockSize, clockSize)
        secondHand.fillColor = NSColor.redColor().CGColor

        secondHand.path = self.makeRectPath(secondStartPoint, width: secondWidth, height: secondHeight)

        // anchor point is already 0.5,0.5 so we can just rotate
        secondHand.transform = CATransform3DMakeRotation(secondRotation, 0, 0, 1)

        var rotationAnimation = CABasicAnimation(keyPath: "transform")
        rotationAnimation.duration = 10
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.fromValue = NSValue(CATransform3D: CATransform3DMakeRotation(0, 0, 0, 1))
        rotationAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 1))

        secondHand.addAnimation(rotationAnimation, forKey: "rotationTransform")

        self.handsLayer.addSublayer(secondHand)
    }

    // convenience, makes a rectangular path
    func makeRectPath(start: CGPoint, width: CGFloat, height: CGFloat) -> CGPath {

        let path = NSBezierPath()
        path.moveToPoint(start)
        path.lineToPoint(CGPointMake(start.x, start.y - height))
        path.lineToPoint(CGPointMake(start.x+width, start.y-height))
        path.lineToPoint(CGPointMake(start.x+width, start.y))
        path.closePath()

        return CGPathFromNSBezierPath(path)
    }
}

func CGPathFromNSBezierPath(nspath: NSBezierPath) -> CGPath! {
    if nspath.elementCount == 0 {
        return nil
    }

    let path = CGPathCreateMutable()
    var didClosePath = false

    if !didClosePath {
        CGPathCloseSubpath(path)
    }

    return CGPathCreateCopy(path)
}

let view = ClockView()

var testAnimation = CABasicAnimation(keyPath: "scale")
testAnimation.duration = 10
testAnimation.toValue = 10
testAnimation.removedOnCompletion = false
view.handsLayer.addAnimation(testAnimation, forKey: "scaleAnimation")


// great for async functions, like network activity
//XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

// not yet supported for iOS playgrounds
//XCPShowView("clock", view)
