//
//  CALayer_PauseYResume.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/22.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

extension CALayer{
    func pauseAnimation(){
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        timeOffset = pauseTime
        speed = 0.0
    }
    
    func resumeAnimation(){
        let pauseTime = timeOffset
        let timeSincePause = CACurrentMediaTime() - pauseTime
        timeOffset = 0.0
        beginTime = timeSincePause
        speed = 1.0
    }
}
