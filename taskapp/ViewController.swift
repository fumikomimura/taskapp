//
//  ViewController.swift
//  taskapp
//
//  Created by 三村文子 on 2020/01/31.
//  Copyright © 2020 三村文子. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Realmインスタンス（データベースから事例）を取得す
    let realm = try! Realm()
    
    //DB内のタスクが格納されtるリスト
    //日付の近い順で並び替える:昇順
    //以降内容をアップデートするリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    //検索結果配列　　追加した
    var searchResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //searchBar関連
        //searchBarの作成
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
    }
    
    //データの数（=セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count  //修正する
    }
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //再利用可能なCellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Cellに値を設定する
        //tableView(_:commit:forRowAt)は各セルの内容を返すメソッド
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.category  //変更した
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    //各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil) //←追加する
    }
    
    //各セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath],with: .fade)
            }
        }
    }
    
    //segueで画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            
        } else {
            
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
                
            }
            inputViewController.task = task
        }
    }
    //入力画面から戻ってきた時にtableViewを更新させる
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    //検索時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar :UISearchBar) {
        searchBar.endEditing(true)
        
        
        
        //NSPredicateを使って検索条件をしているする　追加した
        let predicate = NSPredicate(format: "category == %@",searchBar.text! )   //検索条件を指定
        taskArray = realm.objects(Task.self).filter(predicate)
        
        tableView.reloadData()
        
        print("サーチバー")   //調べるために入力
    }
}

