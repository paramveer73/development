//
//  CardBehavior.swift
//  PlayingCardAnimation
//
//  Created by Paramveer  on 2020-01-27.
//  Copyright © 2020 Paramveer . All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itembehavor :UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push ( _ item:UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.random(in: 0...CGFloat.pi)
        push.magnitude = 1.0 + CGFloat.random(in: 0...2)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
        
    }
    
    func addItem ( _ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itembehavor.addItem(item)
        push(item)
    }
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item)
        itembehavor.removeItem(item)
    }
    convenience init( in animator:UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itembehavor)
        
    }
}
