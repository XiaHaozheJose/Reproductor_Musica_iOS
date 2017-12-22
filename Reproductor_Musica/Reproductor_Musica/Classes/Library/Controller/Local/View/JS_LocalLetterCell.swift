//
//  JS_LocalLetterCell.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/20.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_LocalLetterCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var autorName: UILabel!
    @IBOutlet weak var musicAnimator: UIView!
    
    lazy var repleLayer: CAReplicatorLayer = {
        let repleLayer = CAReplicatorLayer()
        repleLayer.frame = musicAnimator.bounds
        repleLayer.instanceCount = 6
        repleLayer.instanceDelay = 0.15
        return repleLayer
    }()
    
    lazy var musicLayer: CALayer = {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 5, height: musicAnimator.bounds.height - 10)
        layer.anchorPoint = CGPoint(x: 1, y: 1)
        layer.backgroundColor = UIColor.red.cgColor
        layer.position = CGPoint(x: 0, y: musicAnimator.bounds.height)
        return layer
    }()
    
    lazy var animation: CABasicAnimation = {
       let animation = CABasicAnimation()
        animation.keyPath = "transform.scale.y"
        animation.toValue = 0
        return animation
    }()
   
    var localMusic: JS_LocalMusic?{
        didSet{
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.detailTextLabel?.textColor = UIColor(hexString: "#757575")
        self.textLabel?.textColor = UIColor(hexString: "#212121")
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    fileprivate func setData(){
        guard let local = self.localMusic else{return}
        musicName.text = local.music
        autorName.text = local.autor
    }
    
    
    
     func playAnimation(){
        musicAnimator.layer.addSublayer(repleLayer)
        repleLayer.addSublayer(musicLayer)
        
        
        animation.repeatCount = HUGE
        animation.duration = 0.25
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        musicLayer.add(animation, forKey: "music")
        repleLayer.instanceTransform  = CATransform3DMakeTranslation(7, 0, 0)
        
    }
    
    func removeAnimation(){
        musicLayer.removeAnimation(forKey: "music")
        repleLayer.removeFromSuperlayer()
    }
    
}
