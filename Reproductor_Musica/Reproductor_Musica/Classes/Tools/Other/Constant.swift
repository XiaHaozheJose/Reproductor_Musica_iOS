//
//  Constant.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/16.
//  Copyright © 2017年 浩哲 夏. All rights reserved.

import UIKit

let TabTitles = ["Library","Favorite","Browse","Radio","Search"]
let tabNorImage = [#imageLiteral(resourceName: "library"),#imageLiteral(resourceName: "favorate"),#imageLiteral(resourceName: "browse"),#imageLiteral(resourceName: "radio"),#imageLiteral(resourceName: "Search")]
let tabSelecImage = [#imageLiteral(resourceName: "library_selected"),#imageLiteral(resourceName: "favorate_selected"),#imageLiteral(resourceName: "browse_selected"),#imageLiteral(resourceName: "radio_selected"),#imageLiteral(resourceName: "Search_selected")]
let kScreen = UIScreen.main.bounds
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let playBarHeight: CGFloat = 64
let margin: CGFloat = 15
let topTableRowHeight: CGFloat = 44
let topTableRowCount: CGFloat = 3
let topTableHeaderHeight: CGFloat = 64
var sistemTopHeight: CGFloat = 64
var sistemBottomHeight: CGFloat = 49
let MUSIC = "music"
let AUTOR = "autor"
let FILEPATH = "filePath"
let ExistImage = "existImage"
let kPlayEnd = NSNotification.Name.AVPlayerItemDidPlayToEndTime
let kPlayInterrupt = NSNotification.Name.AVPlayerItemPlaybackStalled
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height
let khistoryMusic = "history"
var historyMusics: [JS_LocalMusic] = [JS_LocalMusic]()
let notificationClickedMusic = Notification.Name(rawValue: "notificationClickedMusic")
let notificationItunesClick = Notification.Name(rawValue: "notificationItunesClick")
var isMusiciTunes: Bool = false
