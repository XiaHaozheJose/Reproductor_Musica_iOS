//
//  JS_MusicBasicView.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/23.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import MediaPlayer
class JS_MusicBasicView: UIView {
    
    
    var localMusic: JS_LocalMusic?{
        didSet{
            setData(data: localMusic!)
        }
    }
    
    fileprivate var totalTime: Float = 0
    
    @IBOutlet weak var progress: UISlider!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var renamingTime: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var musicAutor: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var volumeSlider: MPVolumeView!
    @IBOutlet weak var airDrop: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configProgress()
        configVolumeSlider()
        musicImage.layer.cornerRadius = 8
        musicImage.layer.masksToBounds = true
        if !isMusiciTunes {
            setNotiTunesData()
        }
        if isMusiciTunes {
            setiTunesData()
        }
    }
    
    override func removeFromSuperview() {
        if !isMusiciTunes {
            JS_AVPlayer.shared.removeTimeObserver()
            JS_AVPlayer.shared.delegate = nil
        }else{
            JS_SistemMusicPlayer.shared.removeTimeObserver()
            JS_SistemMusicPlayer.shared.delegate = nil
        }
    }
    
    private func configProgress(){
        progress.setThumbImage(#imageLiteral(resourceName: "slideNode"), for: .normal)
        progress.setThumbImage(#imageLiteral(resourceName: "slideNodeSelect"), for: .highlighted)
        progress.setMinimumTrackImage(#imageLiteral(resourceName: "lineNormal"), for: .normal)
        progress.setMinimumTrackImage(#imageLiteral(resourceName: "lineselect"), for: .highlighted)
    }
    
    private func configVolumeSlider(){
        volumeSlider.showsRouteButton = false
        volumeSlider.setVolumeThumbImage(#imageLiteral(resourceName: "slideNode"), for: .normal)
        volumeSlider.setVolumeThumbImage(#imageLiteral(resourceName: "slideNodeSelect"), for: .highlighted)
        volumeSlider.setMinimumVolumeSliderImage(#imageLiteral(resourceName: "lineNormal"), for: .normal)
        volumeSlider.setMinimumVolumeSliderImage(#imageLiteral(resourceName: "lineselect"), for: .highlighted)
    }
    
    private func setData(data: JS_LocalMusic){
        musicTitle.text = data.music
        musicAutor.text = data.autor
        if isMusiciTunes {
            musicImage.image = JS_SistemMusicPlayer.shared.player?.nowPlayingItem?.artwork?.image(at: musicImage.frame.size)
            if let totalTime = JS_SistemMusicPlayer.shared.player?.nowPlayingItem?.playbackDuration{
                renamingTime.text = String.init(format: "%02zd:%02zd", Int(totalTime) / 60, Int(totalTime) % 60 )
            }
            totalTime = Float((JS_SistemMusicPlayer.shared.player?.nowPlayingItem?.playbackDuration ?? 0))
        }
    }
    
    @IBAction func previousMUsic() {
        if isMusiciTunes {
            JS_SistemMusicPlayer.shared.playPrevious()
        }else{
            JS_AVPlayer.shared.previousMusic()
        }
    }
    
    @IBAction func nextMusic() {
        if isMusiciTunes {
            JS_SistemMusicPlayer.shared.playNext()
        }else{
            JS_AVPlayer.shared.nextMusic()
        }
    }
    
    @IBAction func playMusic() {
        if isMusiciTunes {
            if playBtn.isSelected{
                JS_SistemMusicPlayer.shared.pause()
            }else{
                JS_SistemMusicPlayer.shared.play()
            }
        }else{
            if playBtn.isSelected{
                JS_AVPlayer.shared.setPause()
            }else{
                JS_AVPlayer.shared.setPlay()
            }
        }
        playBtn.isSelected = !playBtn.isSelected

    }
    
 
    
    @IBAction func speedMusic() {
        
    }
    
    
    @IBAction func showMenu() {
        
    }
    
    @IBAction func changeProgress(_ sender: UISlider, forEvent event: UIEvent) {
        
    }
    
    
    
    /// iTunes Music
    private func setiTunesData(){
        JS_SistemMusicPlayer.shared.delegate = self
        JS_SistemMusicPlayer.shared.addTimeObserver()
        playBtn.isSelected = (JS_SistemMusicPlayer.shared.player?.playbackState == .playing)
    }
    
    
    /// Local Music
    private func setNotiTunesData(){
        JS_AVPlayer.shared.delegate = self
        JS_AVPlayer.shared.addTimeObserver()
        playBtn.isSelected = JS_AVPlayer.shared.status == .AudioStatePlaying
    }
    
    
}


// MARK: - JS_AudioPlayerDelegate
extension JS_MusicBasicView: JS_AudioPlayerDelegate{
    func getProgress(progress: Float, currentTime: String, totalTime: String, status: AudioStatus) {
        self.currentTime.text = currentTime
        self.renamingTime.text = totalTime
        self.progress.value = progress
    }
    
    func audioPlayerState(isPlaying: Bool) {
        JS_LibraryController.mainTabBarController.playTool.playBtn.isSelected = isPlaying
    }
    
    func didChangeMusic(music: JS_LocalMusic?) {
        guard let music = music else {return}
        localMusic = music
        JS_AVPlayer.shared.addTimeObserver()
    }
    
}

// MARK: - JS_SistemPlayerDelegate
extension JS_MusicBasicView: JS_SistemPlayerDelegate{
    func getProgress(currentTime: String, progressValue: Float) {
        self.currentTime.text = currentTime
        self.progress.value = progressValue / totalTime
    }
    func getStates(state: MPMusicPlaybackState) {
        switch state {
        case .playing:
            playBtn.isSelected = true
            JS_LibraryController.mainTabBarController.playTool.playBtn.isSelected = true
            
            UIView.animate(withDuration: 0.25, animations: {
                self.musicImage.transform = CGAffineTransform.identity
            })
        case .paused:
            playBtn.isSelected = false
            JS_LibraryController.mainTabBarController.playTool.playBtn.isSelected = false

            UIView.animate(withDuration: 0.25, animations: {
                self.musicImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        case .interrupted:
            playBtn.isSelected = true
        default:
            print("null")
        }
    }
    
    func getCurrentItem(item: MPMediaItem) {
        let dict = [MUSIC: item.title!, AUTOR: item.artist!, ExistImage: true] as [String: AnyObject]
        localMusic = JS_LocalMusic(dict: dict)

        JS_AVPlayer.shared.addTimeObserver()
    }
}


