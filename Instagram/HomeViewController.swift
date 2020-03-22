//
//  HomeViewController.swift
//  Instagram
//
//  Created by Apple on 2020/03/03.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var commentDicArray: [String] = []
    
   // 投稿データを格納する配列
   var postArray: [PostData] = []

   // Firestoreのリスナー
   var listener: ListenerRegistration!

   override func viewDidLoad() {
       super.viewDidLoad()

       tableView.delegate = self
       tableView.dataSource = self
    

       // カスタムセルを登録する
       let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
       tableView.register(nib, forCellReuseIdentifier: "Cell")
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       print("DEBUG_PRINT: viewWillAppear")
      
if Auth.auth().currentUser != nil {
           // ログイン済み
           if listener == nil {
               // listener未登録なら、登録してスナップショットを受信する
               let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
               listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                   if let error = error {
                       print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                       return
                   }
                   // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                   self.postArray = querySnapshot!.documents.map { document in
                       print("DEBUG_PRINT: document取得 \(document.documentID)")
                       let postData = PostData(document: document)
                    
                    
                       return postData
                   }
                   // TableViewの表示を更新する
                   self.tableView.reloadData()
                
               }
           }
       } else {
           // ログイン未(またはログアウト済み)
           if listener != nil {
               // listener登録済みなら削除してpostArrayをクリアする
               listener.remove()
               listener = nil
               postArray = []
               tableView.reloadData()
           }
       }
    
    
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return postArray.count
   }

  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        セルを取得してデータを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
//        セル内ボタンのアクションを設定
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
       
        cell.commentButton.addTarget(self, action: #selector(hundleCommentButton(_:forEvent:)), for: .touchUpInside)
       
        
        var postTableViewCell = cell as? PostTableViewCell
        
        return cell
        
        
    }
    
//    セル内のボタンがタップされた時に呼ばれる
    @objc func handleButton(_ sender:UIButton, forEvent event: UIEvent) {
      print("DEBUG_PRINT: likeボタンがタップされました")
        
//        タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
//        配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
        
    }
    
   
    
    @objc func hundleCommentButton(_ sender:UIButton, forEvent event: UIEvent) {
                
                         let touch = event.allTouches?.first
                         let point = touch!.location(in: self.tableView)
                         let indexPath = tableView.indexPathForRow(at: point)
                         
        let cell = tableView.cellForRow(at: indexPath!) as! PostTableViewCell
       
                 //        配列からタップされたインデックスのデータを取り出す
                         let commentData = postArray[indexPath!.row]
        
        var updataComment: FieldValue
        
       
        
        
        if let currentUser = Auth.auth().currentUser {
          let myID = currentUser.uid
          let displayName = currentUser.displayName!
            
            let comment = "\(displayName) : \(cell.commentTextField.text!)"
            var updataComment: FieldValue
                   updataComment = FieldValue.arrayUnion([comment])
       
        let commentRef = Firestore.firestore().collection(Const.PostPath).document(commentData.id)
            commentRef.updateData(["comments": updataComment])
                      
        }
       }
             }
    
   
    
   

