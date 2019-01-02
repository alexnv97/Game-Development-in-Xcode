//
//  ViewController.swift
//  17074856_Coursework
//
//  Created by Alex Nieto Vila on 08/11/2018.
//  Copyright © 2018 Alex Nieto Vila. All rights reserved.
//

import UIKit
import AVFoundation

protocol subViewDelegate {
    func changeBoundaries()
}
class ViewController: UIViewController, subViewDelegate {
    
    @IBOutlet weak var replayBut: UIButton!
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    @IBAction func replayButton(_ sender: UIButton) {
        replayBut.isHidden = true
        gameOverScreen.isHidden = true
        score = 0
        gameFinished = false
        self.main.isHidden = false
        self.background.isHidden = false
        self.background2.isHidden = false
        self.field.isHidden = false
        self.field2.isHidden = false
        self.up.isHidden = false
        self.up2.isHidden = false
        play()
        
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score:Int = 0
    var bats: [UIImageView] = []
    var coins: [UIImageView] = []
    var gameFinished: Bool = false
    
    var ambientMusic: AVAudioPlayer?
    var coinSound: AVAudioPlayer?
    
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    var collisionBehaviour: UICollisionBehavior!
    var coinsCollision: UICollisionBehavior!
    
    @IBOutlet weak var main: DraggedImageView!
    @IBOutlet weak var fog: UIImageView!
    @IBOutlet weak var field: UIImageView!
    @IBOutlet weak var field2: UIImageView!
    @IBOutlet weak var up2: UIImageView!
    @IBOutlet weak var up: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var background2: UIImageView!
    @IBOutlet weak var gameOverScreen: UIImageView!
    
    func moveWeather(){
        UIView.animate(withDuration: 30, delay: 0, options: [ .repeat, .curveLinear], animations: {
            self.fog.center.x -= self.fog.bounds.width
        }, completion: nil)
    }
    
    func moveBackground(){
        let animateB = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 60, delay: 0, options: .curveLinear, animations: {
            self.background2.center.x -= (self.background2.bounds.width * 2)
            }, completion: nil)
        
        let animateB2 = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 30, delay: 0, options: .curveLinear, animations: {
            self.background.center.x -= self.background.bounds.width
        }, completion: { _ in
            
            self.background.frame.origin.x = 1771
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 30, delay: 0, options: .curveLinear, animations:{
                self.background.center.x -= self.background.bounds.width
            }, completion: nil)
        })
        
        animateB.startAnimation()
        animateB2.startAnimation()
        
        let timer = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: timer){
            animateB2.stopAnimation(true)
            animateB.stopAnimation(true)
            self.background.frame.origin.x = 0
            self.background2.frame.origin.x = 1771
        }
        
        /*UIView.animate(withDuration: 50, delay: 0, options: [.curveLinear], animations: {
            self.background2.center.x -= (self.background2.bounds.width * 2)
        }, completion: nil)
        
        UIView.animate(withDuration: 25, delay: 0, options: [ .curveLinear], animations: {
            self.background.center.x -= self.background.bounds.width
        }, completion: { _ in
            
            self.background.frame.origin.x = 1771
            
            UIView.animate(withDuration: 25, delay: 0, options: .curveLinear, animations:{
                self.background.center.x -= self.background.bounds.width
            }, completion: nil)
        })*/
    }
    
    func moveForeground(){
        
        let animateF = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 50, delay: 0, options: [.curveLinear], animations: {
            self.field2.center.x -= (self.field2.bounds.width * 2)
            self.up2.center.x -= (self.up2.bounds.width * 2)
        }, completion: nil)
        
        /*UIView.animate(withDuration: 30, delay: 0, options: [.curveLinear], animations: {
            self.field2.center.x -= (self.field2.bounds.width * 2)
            self.up2.center.x -= (self.up2.bounds.width * 2)
        }, completion: nil)*/
        
        let animateF2 = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 25, delay: 0, options: [.curveLinear], animations: {
            self.field.center.x -= self.field.bounds.width
            self.up.center.x -= self.up.bounds.width
        }, completion: { _ in
            self.up.frame.origin.x = 1771
            self.field.frame.origin.x = 1771
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 25, delay: 0, options: .curveLinear, animations:{
                self.field.center.x -= self.field.bounds.width
                self.up.center.x -= self.up.bounds.width
            }, completion: nil)
        })
        
        animateF.startAnimation()
        animateF2.startAnimation()
        
        let timer = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: timer){
            animateF.stopAnimation(true)
            animateF2.stopAnimation(true)
            self.up.frame.origin.x = 0
            self.up2.frame.origin.x = 1771
            self.field.frame.origin.x = 0
            self.field2.frame.origin.x = 1771
        }
        
        /*
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
        })*/
    }
    
    func createBat(){
        let batView = UIImageView(image: nil)
        
        var batArray: [UIImage]!
        
        batArray = [UIImage(named: "b1.png")!,
                    UIImage(named: "b2.png")!,
                    UIImage(named: "b3.png")!,
                    UIImage(named: "b2.png")!]
        
        batView.image = UIImage.animatedImage(with: batArray, duration: 1)
    
        let random = CGFloat.random(in: 0 ... self.view.frame.height-50)
        batView.frame = CGRect(x: UIScreen.main.bounds.width, y:random, width: 60, height: 50)
        self.view.addSubview(batView)

        dynamicItemBehaviour.addItem(batView)
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: -110, y: 0), for: batView)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
        
        
        collisionBehaviour.addItem(batView)
        dynamicAnimator.addBehavior(collisionBehaviour)
        
        bats.append(batView)
        
    }
    
    func createEnemies(){
        var time = 0
        var appear = 0
        var i = 0
        while (i < 10){
            appear = Int(CGFloat.random(in: 1 ... 6))
            time = time + appear
            let timer = DispatchTime.now() + .seconds(time)
            DispatchQueue.main.asyncAfter(deadline: timer){
                if (!self.gameFinished){
                    self.createBat()
                }
            }
            i = i + 1
        }
    }
    
    func createCoin(){
        
        let coinView = UIImageView(image: nil)
        
        var coinArray: [UIImage]!
        
        
        coinArray = [UIImage(named: "coin.png")!,
                     UIImage(named: "coin2.png")!,
                     UIImage(named: "coin4.png")!,
                     UIImage(named: "coin5.png")!,
                     UIImage(named: "coin6.png")!,
                     UIImage(named: "coin8.png")!]
        
        coinView.image = UIImage.animatedImage(with: coinArray, duration: 1)
        
        let random = CGFloat.random(in: 0 ... self.view.frame.height-60)
        coinView.frame = CGRect(x: UIScreen.main.bounds.width, y:random, width: 30, height: 40)
        self.view.addSubview(coinView)
        
        let velocity = CGFloat.random(in: -70 ... -30)
        dynamicItemBehaviour.addItem(coinView)
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: velocity, y: 0), for: coinView)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
    
        
        
        coinsCollision.addItem(coinView)
        coinsCollision.collisionMode = .boundaries
        dynamicAnimator.addBehavior(coinsCollision)
        
        coins.append(coinView)
        
    }
    
    func createCoins(){
        var time = 0
        var appear = 0
        var i = 0
        while (i < 10){
            appear = Int(CGFloat.random(in: 1 ... 5))
            time = time + appear
            let timer = DispatchTime.now() + .seconds(time)
            DispatchQueue.main.asyncAfter(deadline: timer){
                if (!self.gameFinished){
                    self.createCoin()
                }
            }
            i = i + 1
        }
    }
    
    func deleteEnemies(){
        let tam = bats.count
        var i = 0
        while (i < tam){
            bats[i].frame = .zero
            bats[i].removeFromSuperview()
            i += 1
        }
        bats.removeAll()
    }
    
    func deleteCoins(){
        let tam = coins.count
        var i = 0
        while (i < tam){
            coins[i].frame = .zero
            coins[i].removeFromSuperview()
            i += 1
        }
        coins.removeAll()
    }
    func updateLabel(){
        scoreLabel.text = String(score)
    }
    
    func play(){
        
        let path = Bundle.main.path(forResource: "mainTheme.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            ambientMusic = try AVAudioPlayer(contentsOf: url)
            ambientMusic?.play()
        } catch {
            // couldn't load file :(
        }
        
        gameOverScreen.isHidden = true
        replayBut.isHidden = true
        main.myDelegate = self
        
        moveBackground()
        moveForeground()
        moveWeather()
        
        finalScoreLabel.isHidden = true
        scoreLabel.text = String(score)
        
        let when = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.ambientMusic?.stop()
            self.view.bringSubviewToFront(self.finalScoreLabel)
            self.finalScoreLabel.text = "Score: " + String(self.score)
            self.finalScoreLabel.isHidden = false
            self.deleteEnemies()
            self.deleteCoins()
            self.gameFinished = true
            self.main.isHidden = true
            self.replayBut.isHidden = false
            self.gameOverScreen.isHidden = false
            self.view.bringSubviewToFront(self.replayBut)
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
        coinsCollision = UICollisionBehavior(items: [])
        
        var imageArray: [UIImage]!
        
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
        
        createEnemies()
        
        collisionBehaviour.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect:main.frame))
        
        collisionBehaviour.action = {
            var i = 0
            while (i < self.bats.count){
                if (self.bats[i].frame.intersects(self.main.frame)){
                    self.main.image = UIImage(named: "deadFluvio.png")
                    
                    let timer = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: timer){
                        self.main.image = UIImage.animatedImage(with: imageArray, duration: 1)
                    }
                    self.collisionBehaviour.removeItem(self.bats[i])
                    self.bats[i].frame = .zero
                    self.bats[i].removeFromSuperview()
                    self.bats.remove(at: i)
                    if (self.score > 0){
                        self.score -= 10
                    }
                    self.updateLabel()
                }
                i += 1
            }
            
        }
        
        coinsCollision.addBoundary(withIdentifier: "coin" as NSCopying, for: UIBezierPath(rect:main.frame))
        
        coinsCollision.action = {
            var a = 0
            while (a < self.coins.count){
                if (self.coins[a].frame.intersects(self.main.frame)){
                    let path = Bundle.main.path(forResource: "coin.mp3", ofType:nil)!
                    let url = URL(fileURLWithPath: path)
                    do {
                        self.coinSound = try AVAudioPlayer(contentsOf: url)
                        self.coinSound?.play()
                    } catch {
                        // couldn't load file :(
                    }
                    self.coinsCollision.removeItem(self.coins[a])
                    self.coins[a].frame = .zero
                    self.coins[a].removeFromSuperview()
                    self.coins.remove(at: a)
                    self.score += 10
                    self.updateLabel()
                }
                a += 1
            }
        }
        
        //Expected behaviour when the main character collides with a coin
        createCoins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(gameOverScreen)
        
        play()
    }
    
    func changeBoundaries() {
        collisionBehaviour.removeAllBoundaries()
        coinsCollision.removeAllBoundaries()
        collisionBehaviour.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect: main.frame))
        coinsCollision.addBoundary(withIdentifier: "coin" as NSCopying, for: UIBezierPath (rect: main.frame))
    }

}

