//
//  PostViewController.swift
//  Instagram
//
//  Created by Apple on 2020/03/03.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
//    投稿ボタンと接続
    @IBAction func handlePostButton(_ sender: Any) {
//        画像をJPEGに変換
        let imageData = image.jpegData(compressionQuality: 0.75)
//        画像と投稿データの保管場所を定義
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
//        HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
//        Storageに画像をアップロード
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) {(metadata,error) in
            if error != nil {
//         画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました")
//                先頭画面に戻る
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
//            FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
                ] as [String : Any]
            postRef.setData(postDic)
//            HUDで投稿完了を表示
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
//            投稿を完了し、先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
//    キャンセルボタンと接続
    @IBAction func handleCancelButton(_ sender: Any) {
//        加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //    受け取った画像をImageViewに設定
        imageView.image = image
 
    
    }
}
