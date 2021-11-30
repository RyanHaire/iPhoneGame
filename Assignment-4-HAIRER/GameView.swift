//
//  GameView.swift
//  Assignment-4-HAIRER
//
//  Created by Ryan Haire on 2021-11-26.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 1000, height: 750)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        return scene
    }
    
    var body: some View {
         SpriteView(scene: scene)
            .frame(width: 1000, height: 750 )
            .ignoresSafeArea()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
