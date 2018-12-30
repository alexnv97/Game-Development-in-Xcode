//
//  DraggedImageView.swift
//
//  Created by Alex Nieto Vila on 05/11/2018.
//  Copyright © 2018 Alex Nieto Vila. All rights reserved.
//

import UIKit

class DraggedImageView: UIImageView {

    var startLocation : CGPoint?
    
    var myDelegate : subViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        self.center = CGPoint(x: self.center.x+dx, y: self.center.y+dy)*/
        
        self.myDelegate?.changeBoundaries()
        
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newcenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        let halfx = self.bounds.midX
        newcenter.x = max(halfx, newcenter.x)
        newcenter.x = min((self.superview?.bounds.size.width)! - halfx, newcenter.x)
        
        let halfy = self.bounds.midY
        newcenter.y = max(halfy, newcenter.y)
        newcenter.y = min((self.superview?.bounds.size.height)! - halfy, newcenter.y)
        
        self.center = newcenter
        
    }
}
