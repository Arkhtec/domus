//
//  ViewController.swift
//  Domus
//
//  Created by Anderson Oliveira on 28/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var raio: CGFloat!
    var diametro : CGFloat!
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    @IBOutlet var b3: UIButton!
    @IBOutlet var b4: UIButton!
    @IBOutlet var b5: UIButton!
    @IBOutlet var b6: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.raio = self.view.frame.width / 2.0
        self.diametro = 2 * self.raio
        print(self.diametro)
        
        self.image.frame.size = CGSize(width: self.diametro * 2, height: self.diametro * 2)
        self.image.center = CGPoint(x: self.view.frame.width, y: self.view.center.y)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.drawRotateSquares()
        
        let x1 = self.raio + (self.raio * 0.029)
        let x2 = x1 + (self.raio * 0.29)
        let x3 = x2 + (self.raio * 0.48)

        self.b1.frame.size = CGSize(width: 60, height: 60)
        self.b1.center = CGPoint(x: x1, y: self.yNew(x1, cimaBaixo: false))
        self.b1.layer.cornerRadius = self.b1.frame.width / 2
        
        self.b2.frame.size = CGSize(width: 60, height: 60)
        self.b2.center = CGPoint(x: x1, y: self.yNew(x1, cimaBaixo: true))
        self.b2.layer.cornerRadius = self.b2.frame.width / 2
        
        self.b3.frame.size = CGSize(width: 60, height: 60)
        self.b3.center = CGPoint(x: x2, y: self.yNew(x2, cimaBaixo: false))
        self.b3.layer.cornerRadius = self.b3.frame.width / 2
        
        self.b4.frame.size = CGSize(width: 60, height: 60)
        self.b4.center = CGPoint(x: x2, y: self.yNew(x2, cimaBaixo: true))
        self.b4.layer.cornerRadius = self.b4.frame.width / 2
        
        self.b5.frame.size = CGSize(width: 60, height: 60)
        self.b5.center = CGPoint(x: x3, y: self.yNew(x3, cimaBaixo: false))
        self.b5.layer.cornerRadius = self.b5.frame.width / 2
        
        self.b6.frame.size = CGSize(width: 60, height: 60)
        self.b6.center = CGPoint(x: x3, y: self.yNew(x3, cimaBaixo: true))
        self.b6.layer.cornerRadius = self.b6.frame.width / 2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 375,y: 333.5), radius: CGFloat(187.5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        print(circlePath.bounds)
        
        print(self.yNew(273.44, cimaBaixo: true))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
//        self.view.layer.addSublayer(shapeLayer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTop(_ sender: UIButton) {
        
        print("top")
    }
    
    @IBAction func buttonBot(_ sender: UIButton) {
    
        print("bot")
    }
    
    func yNew(_ x: CGFloat, cimaBaixo: Bool) -> CGFloat {
        
        var y : CGFloat!
        
        let raio2 = pow(self.raio, 2)
        let xg = (x - self.image.center.x)
        let xg2 = pow(xg, 2)
        let raiz = sqrt(raio2 - xg2)
        let r = cimaBaixo ? raiz : -raiz
        
        y = r + self.image.center.y
        
        return y
    }
    
    func drawRotateSquares() {
    
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.diametro * 4, height: self.diametro * 4), false, 1)
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: self.diametro * 2, y: self.diametro * 2)
        
        let rotations = 50
        let amount = M_PI_2 / Double(rotations)
        
        for _ in 0..<rotations {
            
            context!.rotate(by: CGFloat(amount))
            context?.addRect(CGRect(x: -(self.diametro), y: -(self.diametro), width: self.diametro * 2, height: self.diametro * 2))
        }
        
        print(self.diametro)
        
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.strokePath()
        
        let  img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image.image = img
        
    }
}

