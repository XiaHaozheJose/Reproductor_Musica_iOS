//
//  JS_SistemMusicPlayer.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/28.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import MediaPlayer

protocol JS_SistemPlayerDelegate {
    func getProgress(currentTime: String, progressValue: Float)
    func getStates(state: MPMusicPlaybackState)
    func getCurrentItem(item: MPMediaItem)
}


class JS_SistemMusicPlayer: NSObject {
    
    deinit {
    NotificationCenter.default.removeObserver(self)
    }
    
    static let shared = JS_SistemMusicPlayer()
    private override init(){}
    
    var delegate: JS_SistemPlayerDelegate?
    var player: MPMusicPlayerController?
    fileprivate var timer: Timer?
    fileprivate var items: [MPMediaItem]?
    fileprivate var collection: MPMediaItemCollection?
    fileprivate var index: Int = 0
    fileprivate var callBack: ((_ item: MPMediaItem)->())?
    
    func startPlayMusic(items: [MPMediaItem], index: Int, callBack: @escaping ((_ item: MPMediaItem)->())){
        self.callBack = callBack
        self.items = items
        self.index = index
        let item = items[index]
        playWithItem(item: item)
    }
    
    
    fileprivate func playWithItem(item: MPMediaItem){
        if player != nil {
            NotificationCenter.default.removeObserver(self)
        }
        player = MPMusicPlayerController()
        player?.setQueue(with: MPMediaItemCollection(items:items!))
        player?.nowPlayingItem = item
        player?.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(getState), name: Notification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeItem), name: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        player?.prepareToPlay(completionHandler: { (error) in
            if (error == nil){
                self.play()
                self.callBack?(self.items![self.index])
            }
        })
    }
    
    
    
    func play(){
        self.player?.play()
    }
    
    func pause(){
        self.player?.pause()
    }
    
    func playPrevious(){
        if player == nil {
            return
        }
        index -= 1
        if index < 0 {
            index = items!.count - 1
        }
        playWithItem(item: items![index])
        callBack?(items![index])
    }
    

    func playNext(){
        if player == nil {
            return
        }
        index += 1
        if index > items!.count - 1 {
            index = 0
        }
        playWithItem(item: items![index])
        callBack?(items![index])
    }
    
    func addTimeObserver(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
            self.delegate?.getProgress(currentTime: String.init(format: "%02zd:%02zd", Int(self.player!.currentPlaybackTime) / 60, Int(self.player!.currentPlaybackTime) % 60 ), progressValue:
            Float(self.player!.currentPlaybackTime))
        })
        timer?.fire()
    }
    
    func removeTimeObserver(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func getState(){
                switch player!.playbackState {
                case .playing:
                    print("playing")
                    delegate?.getStates(state: .playing)
                case .paused:
                    print("paused")
                    delegate?.getStates(state: .paused)
                case .interrupted:
                    print("interrupted")
                    delegate?.getStates(state: .interrupted)
                case .stopped:
                    print("stoped")
//                    playNext()
                default:
                    print("null")
                }
    }
    
    @objc fileprivate func didChangeItem(){
        guard let changeItem = player?.nowPlayingItem else {return}
        delegate?.getCurrentItem(item: changeItem)
    }
    
}
