//
//  PostData.swift
//  Instagram
//
//  Created by Apple on 2020/03/08.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase



class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    var comments: [String] = []
    var commentAll: [String] = []
    

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String

        self.caption = postDic["caption"] as? String
        
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()

        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let comments:[String] = postDic["comments"] as? [String] {
            self.comments = comments
            print("呼ばれました")
        }
        
       
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
        
        
    }
}
