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
    

    //Behavior of the button next: should go to next level
    @IBAction func nextButton(_ sender: UIButton) {
        level += 1
        gameFinished = false
        seconds = 20
        self.main.isHidden = false
        
        //Show the level 2 scenario
        hideLevel2(hide: false)
        
        play()
        
    }
    
    //Behavior of the button play: should go to level 1
    @IBAction func playButton(_ sender: UIButton) {
        
        //Hide all the menu scenario
        menuBat.isHidden = true
        menuFluvio.isHidden = true
        menuLogo.isHidden = true
        menuScreen.isHidden = true
        playBut.isHidden = true
        
        //Initialize components
        score = 0
        seconds = 20
        gameFinished = false
        level = 1
        
        self.main.isHidden = false
        
        //Show the level 1 scenario
        hideLevel1(hide: false)
        
        play()
    }
   
    //Behavior of the button menu: should go to the principal menu
    @IBAction func menuButton(_ sender: UIButton) {
        
        //Hide the game over scenario
        replayBut.isHidden = true
        gameOverScreen.isHidden = true
        finalScoreLabel.isHidden = true
        menuBut.isHidden = true
        nextBut.isHidden = true
        
        displayMenu()
        
    }
    
    //Behavior of the button replay: should replay the game (always goes to level 1)
    @IBAction func replayButton(_ sender: UIButton) {
        
        //Restart all the components
        score = 0
        seconds = 20
        level = 1
        gameFinished = false
        
        self.main.isHidden = false
        
        //Show the level 1 scenario
        hideLevel1(hide: false)
       
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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    
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
    
    //GLOBAL VARIABLES
    var score:Int = 0
    var seconds:Int = 20
    var timer = Timer()
    var bats: [UIImageView] = []
    var monsters: [UIImageView] = []
    var coins: [UIImageView] = []
    var gameFinished: Bool = false
    var level: Int = 2
    
    //SOUNDS
    var ambientMusic: AVAudioPlayer?
    var coinSound: AVAudioPlayer?
    var hitSound: AVAudioPlayer?
    
    //BEHAVIOURS
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    var enemiesCollision: UICollisionBehavior!
    var coinsCollision: UICollisionBehavior!
    
    //Moves the weather of the background (fog)
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
    @objc func createBat(){
        let batView = UIImageView(image: nil)
        var batArray: [UIImage]!
        
        batArray = [UIImage(named: "b1.png")!,
                    UIImage(named: "b2.png")!,
                    UIImage(named: "b3.png")!,
                    UIImage(named: "b2.png")!]
        
        batView.image = UIImage.animatedImage(with: batArray, duration: 0.6)
    
        let random = CGFloat.random(in: 0 ... self.view.frame.height-50)
        batView.frame = CGRect(x: UIScreen.main.bounds.width, y:random, width: 70, height: 60)
        self.view.addSubview(batView)

        dynamicItemBehaviour.addItem(batView)
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: -200, y: 0), for: batView)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
        enemiesCollision.addItem(batView)
        dynamicAnimator.addBehavior(enemiesCollision)
        
        bats.append(batView)
        
    }
    
    func createMonster(){
        let monsterView = UIImageView(image:nil)
        var monsterArray: [UIImage]!
        
        monsterArray = [UIImage(named: "m1.png")!,
                        UIImage(named: "m2.png")!,
                        UIImage(named: "m3.png")!,
                        UIImage(named: "m4.png")!,
                        UIImage(named: "m5.png")!,
                        UIImage(named: "m4.png")!,
                        UIImage(named: "m3.png")!,
                        UIImage(named: "m2.png")!]
        
        monsterView.image = UIImage.animatedImage(with: monsterArray, duration: 1.5)
        
        let random = CGFloat.random(in: 0...self.view.frame.height-80)
        monsterView.frame = CGRect(x: UIScreen.main.bounds.width, y: random, width: 80, height: 80)
        self.view.addSubview(monsterView)
        
        dynamicItemBehaviour.addItem(monsterView)
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: -250, y: 0), for: monsterView)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
        enemiesCollision.addItem(monsterView)
        dynamicAnimator.addBehavior(enemiesCollision)
        
        monsters.append(monsterView)
        
    }
    
    //Creates in random positions and at random times the enemies
    func createEnemies(){
        
        var appear = 0.0
        
        if (level == 1){
            appear = Double.random(in: 1 ... 2)
        }
        else{
            appear = Double.random(in: 0.5 ... 1.5)
        }
        let timer = DispatchTime.now() + Double(appear)
        
        DispatchQueue.main.asyncAfter(deadline: timer){
            if (!self.gameFinished){
                if (self.level == 1){
                    self.createBat()
                }
                else{
                    self.createMonster()
                }
                self.createEnemies()
            }
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
        
        let velocity = CGFloat.random(in: -150 ... -100)
        dynamicItemBehaviour.addItem(coinView)
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: velocity, y: 0), for: coinView)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
        coinsCollision.addItem(coinView)
        //coinsCollision.collisionMode = .boundaries
        dynamicAnimator.addBehavior(coinsCollision)
        
        coins.append(coinView)
        
    }
    
    //Creates random coins throughout the view
    func createCoins(){
        let appear = Double.random(in: 1 ... 3)
        let timer = DispatchTime.now() + Double(appear)
        DispatchQueue.main.asyncAfter(deadline: timer){
            if (!self.gameFinished){
                self.createCoin()
                self.createCoins()
            }
        }
    }
    
    //Deletes all the enemies from the view
    func deleteEnemies(){
        if (level == 1){
            var i = 0
            while (i < bats.count){
                bats[i].frame = .zero
                bats[i].removeFromSuperview()
                i += 1
            }
            
        }
        else{
            var i = 0
            while (i < monsters.count){
                monsters[i].frame = .zero
                monsters[i].removeFromSuperview()
                i += 1
                
            }
        }
        bats.removeAll()
        monsters.removeAll()
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
    
    @objc func updateTimer(){
        seconds -= 1
        self.timerLabel.text = String(seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func hideLevel1(hide: Bool){
        self.background.isHidden = hide
        self.background2.isHidden = hide
        self.field.isHidden = hide
        self.field2.isHidden = hide
        self.up.isHidden = hide
        self.up2.isHidden = hide
    }
    
    func hideLevel2(hide: Bool){
        self.backgroundLevel2.isHidden = hide
        self.background2Level2.isHidden = hide
        self.fieldLevel2.isHidden = hide
        self.field2Level2.isHidden = hide
        self.upLevel2.isHidden = hide
        self.up2Level2.isHidden = hide
    }
    
    func playLevel1(){
        let path = Bundle.main.path(forResource: "mainTheme.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            ambientMusic = try AVAudioPlayer(contentsOf: url)
            ambientMusic?.numberOfLoops = -1
            ambientMusic?.play()
        } catch {
            // couldn't load file :(
        }
        moveBackground(background: self.background, background2: self.background2)
        moveForeground(field: self.field, field2: self.field2, up: self.up, up2: self.up2)
        hideLevel2(hide: true)
    }
    
    func playLevel2(){
        let path = Bundle.main.path(forResource: "level2music.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            ambientMusic = try AVAudioPlayer(contentsOf: url)
            ambientMusic?.numberOfLoops = -1
            ambientMusic?.play()
        } catch {
            // couldn't load file :(
        }
        moveBackground(background: self.backgroundLevel2, background2: self.background2Level2)
        moveForeground(field: self.fieldLevel2, field2: self.field2Level2, up: self.upLevel2, up2: self.up2Level2)
        
       hideLevel1(hide: true)
    }
    
    //Main function of the game that keeps track of it
    func play(){
        
        gameOverScreen.isHidden = true
        replayBut.isHidden = true
        menuBut.isHidden = true
        nextBut.isHidden = true
        finalScoreLabel.isHidden = true
        
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
        
        scoreLabel.text = String(score)
        timerLabel.text = String(seconds)
        runTimer()
        
        let when = DispatchTime.now() + 20
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.displayGameOver()
        }
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehaviour = UIDynamicItemBehavior(items: [])
        
        enemiesCollision = UICollisionBehavior(items: [])
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
        
        enemiesCollision.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect:main.frame))
        enemiesCollision.collisionMode = .boundaries
        coinsCollision.collisionMode = .boundaries
        
        enemiesCollision.action = {
            var i = 0
            
            if (self.level == 1){
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
                        self.enemiesCollision.removeItem(self.bats[i])
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
            
            else{
                while (i < self.monsters.count){
                    if (self.monsters[i].frame.intersects(self.main.frame)){
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
                        self.enemiesCollision.removeItem(self.monsters[i])
                        self.monsters[i].frame = .zero
                        self.monsters[i].removeFromSuperview()
                        self.monsters.remove(at: i)
                        if (self.score > 0){
                            self.score -= 20
                        }
                        self.updateLabel()
                    }
                    i += 1
                }
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
        let path = Bundle.main.path(forResource: "gameOvermusic.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            ambientMusic = try AVAudioPlayer(contentsOf: url)
            ambientMusic?.numberOfLoops = -1
            ambientMusic?.play()
        } catch {
            // couldn't load file :(
        }
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
        
        self.timer.invalidate()
        
        if (level == 1){
            self.nextBut.isHidden = false
            self.view.bringSubviewToFront(self.nextBut)
            
            hideLevel1(hide: true)
        }
        else{
            hideLevel2(hide: true)
        }
        
        self.view.bringSubviewToFront(self.replayBut)
        self.view.bringSubviewToFront(self.menuBut)
        
        
    }
    
    //Shows the menu screen
    func displayMenu(){
        let path = Bundle.main.path(forResource: "menuMusic.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            ambientMusic = try AVAudioPlayer(contentsOf: url)
            ambientMusic?.numberOfLoops = -1
            ambientMusic?.play()
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
        enemiesCollision.removeAllBoundaries()
        coinsCollision.removeAllBoundaries()
        enemiesCollision.addBoundary(withIdentifier: "enemy" as NSCopying, for: UIBezierPath(rect: main.frame))
        coinsCollision.addBoundary(withIdentifier: "coin" as NSCopying, for: UIBezierPath (rect: main.frame))
    }

}

