//
//  InputViewController.swift
//  taskapp
//
//  Created by 三村文子 on 2020/02/02.
//  Copyright © 2020 三村文子. All rights reserved.
//

import UIKit
import RealmSwift  //追加する
import UserNotifications //追加


class InputViewController: UIViewController {
    
    
    @IBOutlet weak var categoryTextField: UITextField! //追加
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        categoryTextField.text = task.category  //追加
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
    }
    
    @objc func dismissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.category = self.categoryTextField.text! //追加
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
        
    }
    
    //タスクのローカル通知を登録する
    func setNotification (task: Task) {
        let content = UNMutableNotificationContent()
        //タイトルと内容の設定（中身がない場合メッセージ無しで音だけ通知になるので「（＊＊なし）」を表示する）
        if task.category == "" {  //追加
            content.title = "(タイトルなし）"
        } else {
            content.title = task.title
        }
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし) "
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //ローカル通知が発動するtrigger(日付をマッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録　OK")  //error　がnilならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
            
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
                
            }
            
        }
    }
    
}
// Do any additional setup after loading the view.





/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


