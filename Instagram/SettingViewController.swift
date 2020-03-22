//
//  SettingViewController.swift
//  Instagram
//
//  Created by Apple on 2020/03/03.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
//    テキストフィールドの接続
    @IBOutlet weak var displayNameTextField: UITextField!
    
//    表示名変更ボタンの接続
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            
//            表示名が何も入力されていない時
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            
//            表示名を設定
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    
                    print("DEBUG_PRINT: [displayName =\(user.displayName!)]の設定に成功しました")
                    
//                    HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        
//        キーボードを閉じる
        self.view.endEditing(true)
    }
    
//    ログアウトボタンの接続
    @IBAction func handleLogoutButton(_ sender: Any) {
//        ログアウトする
        try! Auth.auth().signOut()
        
//        ログインの画面を表示
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
//        ホーム画面を選択しておく
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        表示名を取得し、テキストフィールドに設定
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }

    
}
