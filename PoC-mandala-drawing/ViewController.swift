//
//  ViewController.swift
//  PoC-mandala-drawing
//
//  Created by Mauricio Lorenzetti on 27/11/17.
//  Copyright © 2017 Mauricio Lorenzetti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawMandala()
    }
    
    func drawMandala() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let context = ctx.cgContext
            let slices = randomEven(8..<16)
            let petalControlY = random(20..<60)
            let radius = CGFloat(100)
            
            context.translateBy(x: 256, y: 256)
            
            for s in 0..<slices {
                context.rotate(by: CGFloat(2*Double.pi/Double(slices)))
                
                context.move(to: .zero)
                context.addLine(to: CGPoint(x: radius*1.5, y: 0))
                var lineTip = context.currentPointOfPath
                context.move(to: .zero)
                context.addArc(center: CGPoint.zero, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*Double.pi/Double(slices)), clockwise: false)
                
                var currentPoint = context.currentPointOfPath
                context.addCurve(to: lineTip, control1: CGPoint(x: lineTip.x+10
                    , y: currentPoint.y+10), control2: CGPoint(x: currentPoint.x-10, y: lineTip.y-10))
                context.move(to: CGPoint(x: currentPoint.x, y: -1*currentPoint.y))
                context.addCurve(to: lineTip, control1: CGPoint(x: lineTip.x-10
                    , y: -1*currentPoint.y-10), control2: CGPoint(x: currentPoint.x+10, y: -1*lineTip.y+10))
                context.move(to: currentPoint)
                
                
                
                var temporaryPoint = context.currentPointOfPath
                context.move(to: .zero)
                context.addQuadCurve(to: CGPoint(x: radius, y: 0), control: CGPoint(x:50, y: -Int(petalControlY)))
                context.addQuadCurve(to: .zero, control: CGPoint(x: 50, y: Int(petalControlY)))
                context.move(to: temporaryPoint)
                
            }
            
            
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
        }
        
        imageView.image = img
        
    }
    
    func random(_ range:Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    func randomEven(_ range:Range<Int>) -> Int {
        var r:Int;
        repeat {
            r = random(range)
        } while (r % 2 != 0)
        return r
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        drawMandala()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

