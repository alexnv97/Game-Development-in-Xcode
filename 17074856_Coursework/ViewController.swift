//
//  ViewController.swift
//  17074856_Coursework
//
//  Created by Alex Nieto Vila on 08/11/2018.
//  Copyright © 2018 Alex Nieto Vila. All rights reserved.
//

import UIKit

protocol subViewDelegate {
    func changeBoundaries()
}
class ViewController: UIViewController, subViewDelegate {
    
    
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    var collisionBehaviour: UICollisionBehavior!
    
    @IBOutlet weak var main: DraggedImageView!
    @IBOutlet weak var fog: UIImageView!
    @IBOutlet weak var field: UIImageView!
    @IBOutlet weak var field2: UIImageView!
    @IBOutlet weak var up2: UIImageView!
    @IBOutlet weak var up: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var background2: UIImageView!
    
    func moveWeather(){
        UIView.animate(withDuration: 30, delay: 0, options: [ .repeat, .curveLinear], animations: {
            self.fog.center.x -= self.fog.bounds.width
        }, completion: nil)
    }
    
    func moveBackground(){
        UIView.animate(withDuration: 50, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.background2.center.x -= (self.background2.bounds.width * 2)
        }, completion: nil)
        
        UIView.animate(withDuration: 25, delay: 0, options: [ .curveLinear], animations: {
            self.background.center.x -= self.background.bounds.width
        }, completion: { _ in
            
            self.background.frame.origin.x = 1771
            
            UIView.animate(withDuration: 25, delay: 0, options: .curveLinear, animations:{
                self.background.center.x -= self.background.bounds.width
            }, completion: nil)
        })
    }
    
    func moveForeground(){
        UIView.animate(withDuration: 30, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.field2.center.x -= (self.field2.bounds.width * 2)
            self.up2.center.x -= (self.up2.bounds.width * 2)
        }, completion: nil)
        
        UIView.animate(withDuration: 15, delay: 0, options: [ .curveLinear], animations: {
            self.field.center.x -= self.field.bounds.width
            self.up.center.x -= self.up.bounds.width
        }, completion: { _ in
            
            self.up.frame.origin.x = 1771
            self.field.frame.origin.x = 1771
            
            UIView.animate(withDuration: 15, delay: 0, options: .curveLinear, animations:{
                self.field.center.x -= self.field.bounds.width
                self.up.center.x -= self.up.bounds.width
            }, completion: nil)
        })
    }
    
    func createEnemies(batArray: [UIImage]){
        
        let batView = UIImageView(image: nil)
        
        batView.image = UIImage.animatedImage(with: batArray, duration: 1)
        
        let random = CGFloat.random(in: 0 ... self.view.frame.height)
        batView.frame = CGRect(x: UIScreen.main.bounds.width, y:random, width: 60, height: 50)
        self.view.addSubview(batView)
        
        let timer = DispatchTime.now() + 5
        
        dynamicItemBehaviour.addItem(batView)
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: -110, y: 0), for: batView)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
        
        
        //collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
 
        
        collisionBehaviour.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect:main.frame))
        
        
        collisionBehaviour.addItem(batView)
        //collisionBehaviour.collisionMode = .boundaries
        dynamicAnimator.addBehavior(collisionBehaviour)
        
        DispatchQueue.main.asyncAfter(deadline: timer){
            self.createEnemies(batArray: batArray)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        main.myDelegate = self
        
        moveBackground()
        moveForeground()
        moveWeather()
        
        let when = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("TIME'S UP")
            self.main.isHidden = true
            self.background.isHidden = true
            self.background2.isHidden = true
            self.field.isHidden = true
            self.field2.isHidden = true
            self.up.isHidden = true
            self.up2.isHidden = true
        }
       
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehaviour = UIDynamicItemBehavior(items: [])
        collisionBehaviour = UICollisionBehavior(items: [])
        
        var imageArray: [UIImage]!
        var batArray: [UIImage]!
        batArray = [UIImage(named: "b1.png")!,
                    UIImage(named: "b2.png")!,
                    UIImage(named: "b3.png")!,
                    UIImage(named: "b2.png")!]
 
        imageArray = [UIImage(named: "f1.png")!,
                      UIImage(named: "f2.png")!,
                      UIImage(named: "f3.png")!,
                      UIImage(named: "f4.png")!,
                      UIImage(named: "f5.png")!,
                      UIImage(named: "f6.png")!,
                      UIImage(named: "f7.png")!,
                      UIImage(named: "f8.png")!,
                      UIImage(named: "f9.png")!,
                      UIImage(named: "f10.png")!,
                      UIImage(named: "f9.png")!,
                      UIImage(named: "f8.png")!,
                      UIImage(named: "f7.png")!,
                      UIImage(named: "f6.png")!,
                      UIImage(named: "f5.png")!,
                      UIImage(named: "f4.png")!,
                      UIImage(named: "f3.png")!,
                      UIImage(named: "f2.png")!]
        
       
        
        main.image = UIImage.animatedImage(with: imageArray, duration: 1)
        
        createEnemies(batArray: batArray)
    }
    
    func changeBoundaries() {
        collisionBehaviour.removeAllBoundaries()
        collisionBehaviour.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect: main.frame))
    }


}

