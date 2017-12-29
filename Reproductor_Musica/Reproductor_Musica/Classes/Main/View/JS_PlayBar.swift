//
//  JS_PlayBar.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/16.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import AVFoundation
import DeckTransition
class JS_PlayBar: UIView{

    
    var localMusic: JS_LocalMusic?{
        didSet{
            setData()
        }
    }
    
    var isPlaying: Bool?{
        didSet{
            playBtn.isSelected = isPlaying!
        }
    }
    
    var musicImage: UIImage?{
        didSet{
            musicIcon.image = musicImage
        }
    }
    
    var callback: ((_ VC: UIViewController)->())?
    
    fileprivate lazy var gradient: CAGradientLayer = {
       let gradient = CAGradientLayer()
        return gradient
    }()
    fileprivate lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "locations")
        return animation
    }()
    lazy fileprivate var isAnimation: Bool = false
    
    @IBOutlet weak var musicIcon: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        musicIcon.layer.cornerRadius = 3
        musicIcon.layer.masksToBounds = true
        setGestureForPlayBar()
        
        
    }
    
    private func setGestureForPlayBar(){
        let tap = UITapGestureRecognizer(target: self, action:#selector(modalMusicView(tap:)) )
        self.addGestureRecognizer(tap)
    }
    
    private func setData(){
        musicTitle.text = localMusic?.music
        musicTitleAnimation()
        playBtn.isSelected = true
        if !localMusic!.existImage {
            musicIcon.image = #imageLiteral(resourceName: "localplaceholder")
        }
    }
    
    @IBAction func nextMusic() {
        if !isMusiciTunes {
            JS_AVPlayer.shared.nextMusic()
        }else{
            JS_SistemMusicPlayer.shared.playNext()
        }
    }
    
    
    @IBAction func playMusic() {
        if playBtn.isSelected {
            if !isMusiciTunes{JS_AVPlayer.shared.setPause()}else{
                JS_SistemMusicPlayer.shared.pause()
            }
        }else{
            if !isMusiciTunes{JS_AVPlayer.shared.setPlay()}else{
                JS_SistemMusicPlayer.shared.play()
            }
        }
        playBtn.isSelected = !playBtn.isSelected
    }
    
    private func musicTitleAnimation(){
        if isAnimation {
            return
        }
        gradient.frame = musicTitle.bounds
        gradient.colors = [UIColor(white: 1.0, alpha: 0.3).cgColor, UIColor.yellow.cgColor, UIColor(white: 1.0, alpha: 0.3).cgColor]
        gradient.startPoint = CGPoint(x:-0.3, y:0.5)
        gradient.endPoint = CGPoint(x:1 + 0.3, y:0.5)
        gradient.locations = [0, 0.15, 0.3]
        musicTitle.layer.mask = gradient
        animation.fromValue = [0, 0.15, 0.3]
        animation.toValue = [1 - 0.3, 1 - 0.15, 1.0];
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.duration = 1.5
        gradient.add(animation, forKey: "musicTitle")
        isAnimation = true
    }
    
    @objc private func modalMusicView(tap: UITapGestureRecognizer) {
            let musicView = JS_MusicViewController()
            let transitionDelegate = DeckTransitioningDelegate()
            musicView.transitioningDelegate = transitionDelegate
            musicView.modalPresentationStyle = .custom
            musicView.localMusic = localMusic
            callback?(musicView)
    }
    
    
}


