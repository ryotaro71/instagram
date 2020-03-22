//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by Apple on 2020/03/03.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLImageEditorDelegate {
    
//    ライブラリボタンの接続
    @IBAction func handleLibraryButton(_ sender: Any) {
//        ライブラリを指定してpickerを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
//    カメラボタンの接続
    @IBAction func handleCameraButton(_ sender: Any) {
//        カメラを指定してpickerを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
//    キャンセルボタンを接続
    @IBAction func handleCancelButton(_ sender: Any) {
//        画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//　　　　　　写真を撮影、選択した時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
//            画像を取得
            let image = info[.originalImage] as! UIImage
            
//            後でライブラリで加工
            print("DEBUG_PRINT: image = \(image)")
//            CLImageEditorにImageを渡して、加工画面を起動
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            picker.present(editor, animated: true, completion: nil)
        }
    }
    
//    CLImageEditorで加工が終わった時に呼ばれる
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
//        投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    
//    編集がキャンセルされた時に呼ばれる
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
//        タブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        タブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
   

}
