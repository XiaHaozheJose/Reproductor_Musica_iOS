//
//  JS_3DTouchPeekController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/30.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_3DTouchPeekController: UITableViewController {

    var name: String?{
        didSet{
            self.title = name
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "3dCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "3dCell")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    override var previewActionItems: [UIPreviewActionItem]{
        
        let action1 = UIPreviewAction(title: "Play This Album", style: .destructive) { (action, previewViewController) in
            
        }
        let action2 = UIPreviewAction(title: "Delete", style: .destructive) { (action, previewViewController) in
            
        }
        let action3 = UIPreviewAction(title: "Add To Favorit", style: .destructive) { (action, previewViewController) in
            //
        }
        let action4 = UIPreviewAction(title: "Share", style: .destructive) { (action, previewViewController) in
            //
        }
        let actionItems = [action1,action2,action3,action4]
        return actionItems
        
    }
    
    
    
    
    
    
}
