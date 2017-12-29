//
//  JS_AVPlayer.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/22.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import AVFoundation
import UIKit


/// Protocol Optional
@objc protocol JS_AudioPlayerDelegate: NSObjectProtocol{
    @objc optional func playedEnd(currentUrl: URL?, currentPlayerItem: AVPlayerItem?,index:Int)
    @objc optional func getLoadingSize(loadSize: Float)
    @objc optional func getProgress(progress:Float,currentTime:String,totalTime:String,status:AudioStatus)
    @objc optional func audioPlayerState(isPlaying: Bool)
    @objc optional func didChangeMusic(music: JS_LocalMusic?)
    
}

fileprivate let kStatus = "status"
fileprivate let kPlaybackLikelyToKeepUp = "playbackLikelyToKeepUp"

@objc enum AudioStatus: Int{
    case AudioStateUnKnown //>>>>>0
    case AudioStateLoading //>>>>>1
    case AudioStatePlaying //>>>>>2
    case AudioStateStopped //>>>>>3
    case AudioStatePause   //>>>>>4
    case AudioStateFailed  //>>>>>5
}


class JS_AVPlayer: NSObject {
    
    // Singleton
    static let shared = JS_AVPlayer()
    private override init(){}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate var player: AVPlayer?            // Instance AVPlayer
    fileprivate(set) var isMuted: Bool = false   // Sound OFF
    fileprivate(set) var volumen: Float = 0      // Volumen >>> 0 - 1
    fileprivate(set) var status: AudioStatus = .AudioStateUnKnown   // Status Audio
    fileprivate var currentUrl: URL!             // Url Current
    fileprivate var isUserPause: Bool = false    // Pause
    fileprivate var totalTimeStr: String = "00:00"  // Total Time En String
    fileprivate var totalTimeInt: Int = 0        // Total Time En Int
    fileprivate var timeRate: Float = 1
    weak var delegate: JS_AudioPlayerDelegate?   // Protocolo Custom For JS_AudioPlayer
    fileprivate var timeObserver: Any?           // Observer Time
    fileprivate var items: [URL] = [URL]()       // UrlItems For AVPlayer
    fileprivate var localMusics: [JS_LocalMusic]?
    fileprivate var callBack: ((_ index: Int)->())? // Clousure CallBack
    
    
    
    /// fileItems
    var musicItems:[String]?{
        didSet{
            items.removeAll()
            for file in musicItems!{
                items.append(URL(fileURLWithPath: file))
            }}}
    
    var indexWithMusic: Int = 0
    
    func startPlay(item: URL,index: Int,localMusics: [JS_LocalMusic], callBack:((_ index: Int)->())?){
        self.localMusics = localMusics
        self.indexWithMusic = index
        self.currentUrl = item
        self.callBack = callBack
        playerWithItem(url: item)
    }
    fileprivate func playerWithItem(url: URL){
        
        self.currentUrl = url
        let urlAsset = player?.currentItem?.asset as? AVURLAsset
        if let url = urlAsset?.url{
            if url == self.currentUrl {
                resumen()
                return
            }}
        playWithFile(url: self.currentUrl)
    }
    
    private func playWithFile(url: URL){
        
        let asset = AVURLAsset(url: url)
        if player?.currentItem != nil {
            // Remove Observer 
            removeObserver()
            if timeObserver != nil { removeTimeObserver() }
        }
        
        let playItem = AVPlayerItem(asset: asset)
        playItem.addObserver(self, forKeyPath: kStatus, options: .new, context: nil)
        playItem.addObserver(self, forKeyPath: kPlaybackLikelyToKeepUp, options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: kPlayEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playIterrupt), name: kPlayInterrupt, object: nil)
        self.player = AVPlayer(playerItem: playItem)
    }
    
}

// MARK: - Open Method
extension JS_AVPlayer{
   open func nextMusic(){
        playEnd()
    }
    
    open func previousMusic(){
            indexWithMusic -= 1
            if indexWithMusic < 0 {
                indexWithMusic = items.count - 1
            }
            playWithIndex(index: indexWithMusic)
        }
    
    open func setPlay(){
        resumen()
        if delegate?.responds(to: #selector(delegate?.audioPlayerState(isPlaying:))) == true {
            delegate?.audioPlayerState!(isPlaying: true)
        }
    }
    
    open func setPause(){
        pause()
        if delegate?.responds(to: #selector(delegate?.audioPlayerState(isPlaying:))) == true {
            delegate?.audioPlayerState!(isPlaying: false)
        }    }
    
    open func setPrevious(){
        previousMusic()
    }
    
    
}

extension JS_AVPlayer{
    
   fileprivate func resumen(){
        if player != nil || player?.currentItem?.isPlaybackLikelyToKeepUp == true{
            player?.play()
            player?.rate = timeRate
            isUserPause = false
            self.status = .AudioStatePlaying
        }
    }
   fileprivate func pause(){
        if status == .AudioStatePlaying || status == .AudioStateLoading {
            player?.pause()
            isUserPause = true
            if player != nil{
                status = .AudioStatePause
            }
        }
    }
    
   fileprivate func stop(){
        if let play = player {
            play.pause()
            play.currentItem?.seek(to: kCMTimeZero, completionHandler: nil)
            status = .AudioStateStopped
        }
    }
    
    
   fileprivate func setRate(rate: Float)->Float?{
        timeRate += rate
        if timeRate < 0.1 {
            timeRate = 0.1
        }
        if timeRate > 2 {
            timeRate = 2
        }
        if status == .AudioStatePlaying {
            player?.rate = timeRate
        }
        return timeRate
    }
    
   fileprivate func setMuted(muted: Bool){
        self.isMuted = muted
        player?.isMuted = muted
    }
    
   fileprivate func seekWithProgress(progress: Double){
        if progress < 0 || progress > 1{
            return
        }
        
        guard let totalTime = player?.currentItem?.duration else {return}
        let totalSec = CMTimeGetSeconds(totalTime)
        let playTimeSec = totalSec * progress
        let timeToPlay = CMTimeMake(Int64(playTimeSec), 1)
        
        player?.seek(to: timeToPlay, completionHandler: {
            if $0 == true{self.JSLog("load OK")}else{
                self.JSLog("Load Failed")
            }
        })
    }
    
   fileprivate func seekWithTimeDiffer(timeDiffer:Double){
        
        guard let totalFilmTime = player?.currentItem?.duration else { return }
        let totalFilmSec = CMTimeGetSeconds(totalFilmTime)
        
        guard let currentTime = player?.currentItem?.currentTime()  else { return }
        var playTimeSec = CMTimeGetSeconds(currentTime)
        
        playTimeSec += timeDiffer
        if playTimeSec > Double(self.totalTimeInt){
            playTimeSec = Double(self.totalTimeInt)
        }
        if playTimeSec < 0 {
            playTimeSec = 0
        }
        seekWithProgress(progress: playTimeSec / totalFilmSec)
    }
    
    fileprivate func playWithIndex(index: Int){
        playerWithItem(url: items[index])
        callBack?(index)
        if delegate?.responds(to: #selector(delegate?.playedEnd(currentUrl:currentPlayerItem:index:))) == true{
            delegate?.playedEnd!(currentUrl: currentUrl, currentPlayerItem: player?.currentItem, index: index)
        }
        if delegate?.responds(to: #selector(delegate?.didChangeMusic(music:))) == true{
            delegate?.didChangeMusic?(music: self.localMusics?[index])
        }
    }
    
   @objc fileprivate func playEnd(){
        indexWithMusic += 1
        if indexWithMusic > items.count - 1{
            indexWithMusic = 0
        }
        playWithIndex(index: indexWithMusic)
    }
    
   @objc fileprivate func playIterrupt(){
        pause()
    }
}


extension JS_AVPlayer{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kStatus {
            let status = change?[.newKey] as! Int
            if status == AVPlayerStatus.readyToPlay.rawValue{
                if let play = player{
                    JSLog("preparado")
                    self.totalTimeInt = Int(CMTimeGetSeconds((play.currentItem?.duration)!))
                    self.totalTimeStr = String.init(format: "%02zd:%02zd",self.totalTimeInt / 60,self.totalTimeInt % 60 )
                    self.status = .AudioStatePause
                    resumen()
                }
            }else{
                JSLog("Error")
                self.status = .AudioStateFailed
            }
        }
        else if keyPath == kPlaybackLikelyToKeepUp{
            let playToKeepUp = change?[.newKey] as! Bool
            if playToKeepUp == true{
                if !isUserPause{
                    JSLog("loaded Memory")
                    if self.status == .AudioStatePause{
                        self.resumen()
                    }
                }else{ JSLog("userPause")}
            }else{
                JSLog("loading")
                self.status = .AudioStateLoading
            
        }}
    }
    
    func addTimeObserver(){
        if let play = player {
            if delegate?.responds(to: #selector(delegate?.getProgress(progress:currentTime:totalTime:status:))) == true{
                guard let duration = play.currentItem?.duration else{return}
                timeObserver = play.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: DispatchQueue.main, using: {[weak self] (CmTime:CMTime) in
                    let totalTime = CMTimeGetSeconds(duration)
                    let current = CMTimeGetSeconds(CmTime)
                    let minuts = Int(current / 60)
                    let seconds = Int(current) % 60
                    self?.delegate?.getProgress!(progress: Float(current / totalTime), currentTime: String.init(format: "%02zd:%02zd",minuts,seconds), totalTime: self?.totalTimeStr ?? "00:00", status: self?.status ?? .AudioStateUnKnown)
                })
            }
        } }
    
    
    func removeTimeObserver(){
        if let play = player {
            play.removeTimeObserver(timeObserver as Any)
        }
        timeObserver = nil
    }
    
    // Requied
    func removeObserver(){
        if let play = player {
            play.currentItem?.removeObserver(self, forKeyPath: kStatus)
            play.currentItem?.removeObserver(self, forKeyPath: kPlaybackLikelyToKeepUp)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func JSLog<T>(_ message : T , file : String = #file , funcName : String = #function , lineNum : Int = #line){
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            print("\(fileName):(\(lineNum))-\(message)")
        #endif
    }
}
