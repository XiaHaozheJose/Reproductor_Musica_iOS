//
//  JS_TopView.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

fileprivate let identifier: String = "cell"
fileprivate let menus = ["Local Music","Carpeta","ITunes","Dropbox"]

protocol TopViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,title: String)
}

class JS_TopView: UIView {

    
    var delegate: TopViewDelegate?
    fileprivate lazy var tableView: UITableView = {
    let tableView = UITableView(frame: self.bounds)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = topTableRowHeight
    tableView.indicatorStyle = .default
        return tableView
    }()
    
   fileprivate lazy var topHeader: JS_TopTableHeader = {
       let header = Bundle.main.loadNibNamed("JS_TopTableHeader", owner: nil, options: nil)?.first as! JS_TopTableHeader
        header.frame = CGRect(x: 0, y: 0, width: 0, height: topTableHeaderHeight)
        return header
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTopTableView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



extension JS_TopView{
    fileprivate func setTopTableView(){
        self.addSubview(tableView)
        tableView.tableHeaderView = topHeader
    }
    
    func setTopTitle(Title: String, Edit: String){
        topHeader.title.text = Title
        topHeader.edit.setTitle(Edit, for: .normal)
    }
}

extension JS_TopView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView(tableView, didSelectRowAt: indexPath,title: menus[indexPath.row])
    }
    
}
extension JS_TopView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = menus[indexPath.row]
        return cell!
    }
    
}

