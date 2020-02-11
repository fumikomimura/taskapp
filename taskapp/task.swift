//
//  task.swift
//  taskapp
//
//  Created by 三村文子 on 2020/02/02.
//  Copyright © 2020 三村文子. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    //管理用ID.プライマリーキー
    @objc dynamic var id = 0
    
    //カテゴリー
    @objc dynamic var category = ""   //追加した
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
