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
    

    @IBAction func nextButton(_ sender: UIButton) {
        level += 1
        gameFinished = false
        
        gameFinished = false
        self.main.isHidden = false
    
        self.backgroundLevel2.isHidden = false
        self.background2Level2.isHidden = false
        self.fieldLevel2.isHidden = false
        self.field2Level2.isHidden = false
        self.upLevel2.isHidden = false
        self.up2Level2.isHidden = false
        
        play()
        
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        
        menuBat.isHidden = true
        menuFluvio.isHidden = true
        menuLogo.isHidden = true
        menuScreen.isHidden = true
        playBut.isHidden = true
    
        menuMusic?.stop()
        
        score = 0
        gameFinished = false
        level = 1
        
        self.main.isHidden = false
        self.background.isHidden = false
        self.background2.isHidden = false
        self.field.isHidden = false
        self.field2.isHidden = false
        self.up.isHidden = false
        self.up2.isHidden = false
        
        play()
    }
   
    @IBAction func menuButton(_ sender: Any) {
        
        replayBut.isHidden = true
        gameOverScreen.isHidden = true
        finalScoreLabel.isHidden = true
        menuBut.isHidden = true
        nextBut.isHidden = true
        
        displayMenu()
        
    }
    
    @IBAction func replayButton(_ sender: UIButton) {
        
        score = 0
        gameFinished = false
        self.main.isHidden = false
        
        if (level == 1){
            self.background.isHidden = false
            self.background2.isHidden = false
            self.field.isHidden = false
            self.field2.isHidden = false
            self.up.isHidden = false
            self.up2.isHidden = false
        }
            
        else{
            self.backgroundLevel2.isHidden = false
            self.background2Level2.isHidden = false
            self.fieldLevel2.isHidden = false
            self.field2Level2.isHidden = false
            self.upLevel2.isHidden = false
            self.up2Level2.isHidden = false
        }
        
        play()
        
    }
    
    //MAIN VIEW
    @IBOutlet weak var main: DraggedImageView!
    @IBOutlet weak var fog: UIImageView!
    @IBOutlet weak var field: UIImageView!
    @IBOutlet weak var field2: UIImageView!
    @IBOutlet weak var up2: UIImageView!
    @IBOutlet weak var up: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var background2: UIImageView!
    
    
    //LEVEL 2
    @IBOutlet weak var up2Level2: UIImageView!
    @IBOutlet weak var upLevel2: UIImageView!
    @IBOutlet weak var field2Level2: UIImageView!
    @IBOutlet weak var fieldLevel2: UIImageView!
    @IBOutlet weak var background2Level2: UIImageView!
    @IBOutlet weak var backgroundLevel2: UIImageView!
    
    //MENU SCREEN
    @IBOutlet weak var menuScreen: UIImageView!
    @IBOutlet weak var menuFluvio: UIImageView!
    @IBOutlet weak var menuBat: UIImageView!
    @IBOutlet weak var menuLogo: UIImageView!
    @IBOutlet weak var playBut: UIButton!
    
    //GAME OVER SCREEN
    @IBOutlet weak var gameOverScreen: UIImageView!
    @IBOutlet weak var menuBut: UIButton!
    @IBOutlet weak var replayBut: UIButton!
    @IBOutlet weak var nextBut: UIButton!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //GLOBAL VARIABLES
    var score:Int = 0
    var bats: [UIImageView] = []
    var coins: [UIImageView] = []
    var gameFinished: Bool = false
    var level: Int = 2
    
    //SOUNDS
    var ambientMusic: AVAudioPlayer?
    var menuMusic: AVAudioPlayer?
    var coinSound: AVAudioPlayer?
    var hitSound: AVAudioPlayer?
    
    //BEHAVIOURS
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    var collisionBehaviour: UICollisionBehavior!
    var coinsCollision: UICollisionBehavior!
    
    //Moves the weather of the background
    func moveWeather(){
        UIView.animate(withDuration: 30, delay: 0, options: [ .repeat, .curveLinear], animations: {
            self.fog.center.x -= self.fog.bounds.width
        }, completion: nil)
    }
    
    //Animates the background
    func moveBackground(background: UIImageView, background2: UIImageView){
        let animateB = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 60, delay: 0, options: .curveLinear, animations: {
            background2.center.x -= (background2.bounds.width * 2)
            }, completion: nil)
        
        let animateB2 = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 30, delay: 0, options: .curveLinear, animations: {
            background.center.x -= background.bounds.width
        }, completion: { _ in
            
            background.frame.origin.x = 1771
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 30, delay: 0, options: .curveLinear, animations:{
                background.center.x -= background.bounds.width
            }, completion: nil)
        })
        
        animateB.startAnimation()
        animateB2.startAnimation()
        
        let timer = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: timer){
            animateB2.stopAnimation(true)
            animateB.stopAnimation(true)
            background.frame.origin.x = 0
            background2.frame.origin.x = 1771
        }
    }
    
    //Animates the foreground
    func moveForeground(field: UIImageView, field2: UIImageView, up: UIImageView, up2: UIImageView){
        
        let animateF = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 50, delay: 0, options: [.curveLinear], animations: {
            field2.center.x -= (field2.bounds.width * 2)
            up2.center.x -= (up2.bounds.width * 2)
        }, completion: nil)
        
        let animateF2 = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 25, delay: 0, options: [.curveLinear], animations: {
            field.center.x -= field.bounds.width
            up.center.x -= up.bounds.width
        }, completion: { _ in
            up.frame.origin.x = 1771
            field.frame.origin.x = 1771
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 25, delay: 0, options: .curveLinear, animations:{
                field.center.x -= field.bounds.width
                up.center.x -= up.bounds.width
            }, completion: nil)
        })
        
        animateF.startAnimation()
        animateF2.startAnimation()
        
        let timer = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: timer){
            animateF.stopAnimation(true)
            animateF2.stopAnimation(true)
            up.frame.origin.x = 0
            up2.frame.origin.x = 1771
            field.frame.origin.x = 0
            field2.frame.origin.x = 1771
        }
    }
    
    //Creates a new enemy of the type BAT
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
    
    //Creates in random positions and at random times the enemies
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
    
    //Creates a coin
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
    
    //Creates random coins throughout the view
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
    
    //Deletes all the enemies from the view
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
    
    //Deletes all the coins from the view
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
    
    //Updates the score label each time an event happens
    func updateLabel(){
        scoreLabel.text = String(score)
    }
    
    func playLevel1(){
        moveBackground(background: self.background, background2: self.background2)
        moveForeground(field: self.field, field2: self.field2, up: self.up, up2: self.up2)
        self.backgroundLevel2.isHidden = true
        self.background2Level2.isHidden = true
        self.fieldLevel2.isHidden = true
        self.field2Level2.isHidden = true
        self.upLevel2.isHidden = true
        self.up2Level2.isHidden = true
    }
    
    func playLevel2(){
        moveBackground(background: self.backgroundLevel2, background2: self.background2Level2)
        moveForeground(field: self.fieldLevel2, field2: self.field2Level2, up: self.upLevel2, up2: self.up2Level2)
        self.background.isHidden = true
        self.background2.isHidden = true
        self.field.isHidden = true
        self.field2.isHidden = true
        self.up.isHidden = true
        self.up2.isHidden = true
    }
    
    //Main function of the game that keeps track of it
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
        menuBut.isHidden = true
        nextBut.isHidden = true
        main.myDelegate = self
        
        
        main.frame.origin.x = 50
        main.frame.origin.y = 50
        
        if (level == 1){
            playLevel1()
            
        }
        else{
            playLevel2()
        }
        
        moveWeather()
        
        finalScoreLabel.isHidden = true
        scoreLabel.text = String(score)
        
        let when = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.displayGameOver()
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
                    let path = Bundle.main.path(forResource: "hit.mp3", ofType:nil)!
                    let url = URL(fileURLWithPath: path)
                    do {
                        self.hitSound = try AVAudioPlayer(contentsOf: url)
                        self.hitSound?.play()
                    } catch {
                        // couldn't load file :(
                    }
                    
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
        
        //Expected behaviour when the main character collides with a coin
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
        
        createCoins()
    }
    
    //Shows the game over screen
    func displayGameOver(){
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
        self.menuBut.isHidden = false
        if (level == 1){
            self.nextBut.isHidden = false
            self.view.bringSubviewToFront(self.nextBut)
            
            self.background.isHidden = true
            self.background2.isHidden = true
            self.field.isHidden = true
            self.field2.isHidden = true
            self.up.isHidden = true
            self.up2.isHidden = true
        }
        else{
            self.menuBut.frame.origin.x = 544
            self.menuBut.frame.origin.y = 224
            
            self.backgroundLevel2.isHidden = true
            self.background2Level2.isHidden = true
            self.fieldLevel2.isHidden = true
            self.field2Level2.isHidden = true
            self.upLevel2.isHidden = true
            self.up2Level2.isHidden = true
        }
        
        self.view.bringSubviewToFront(self.replayBut)
        self.view.bringSubviewToFront(self.menuBut)
        
        
    }
    
    //Shows the menu screen
    func displayMenu(){
        let path = Bundle.main.path(forResource: "menuMusic.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            menuMusic = try AVAudioPlayer(contentsOf: url)
            menuMusic?.numberOfLoops = -1
            menuMusic?.play()
        } catch {
            // couldn't load file :(
        }
        
        self.view.bringSubviewToFront(self.menuFluvio)
        self.view.bringSubviewToFront(self.menuBat)
        self.view.bringSubviewToFront(self.menuLogo)
        self.view.bringSubviewToFront(self.playBut)
        menuScreen.isHidden = false
        menuBat.isHidden = false
        menuFluvio.isHidden = false
        menuLogo.isHidden = false
        playBut.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(gameOverScreen)
        self.view.addSubview(menuScreen)
        
        displayMenu()
        
    }
    
    func changeBoundaries() {
        collisionBehaviour.removeAllBoundaries()
        coinsCollision.removeAllBoundaries()
        collisionBehaviour.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect: main.frame))
        coinsCollision.addBoundary(withIdentifier: "coin" as NSCopying, for: UIBezierPath (rect: main.frame))
    }

}

