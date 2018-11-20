//
//  ViewController.swift
//  17074856_Coursework
//
//  Created by Alex Nieto Vila on 08/11/2018.
//  Copyright © 2018 Alex Nieto Vila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        moveBackground()
        moveForeground()
        moveWeather()
       
    }


}

