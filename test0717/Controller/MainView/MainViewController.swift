//
//  MainViewController.swift
//  test0717
//
//  Created by imac-1681 on 2024/7/17.
//

import UIKit
import RealmSwift
import AuthenticationServices

class MainViewController: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var tbview: UITableView!
    
    @IBOutlet var tvtext: UITextField!
    
    @IBOutlet var UserName: UITextField!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var SortButton: UIButton!
    @IBOutlet var userNamelab: UILabel!
    @IBOutlet var constentLab: UILabel!
    // MARK: - Proprtty
    var MessageArray: [MessageBoard] = []
    var deleteArr_cell: MessageBoard?
    var edit_cell: MessageBoard?
    var editCell_Time: MessageBoard?
    var sortOrNot = 0
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUI()
        
        button.setTitle("送出", for: .normal)
        let realm = try! Realm()
        let Message_Board = try! Realm().objects(MessageBoard.self)
        for MessageBoard in Message_Board {
            MessageArray.append(MessageBoard)
        }
        print("fileURL : \(realm.configuration.fileURL!)")
    
    }
    func setUI() {
        tableSet()
    }
    func tableSet() {
        tbview.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: MainTableViewCell.identifie)
        
        tbview.dataSource = self
        tbview.delegate = self
    }
    
        
    
    // MARK: - UI Setting
    
    // MARK: - IBAction
    //新增資料庫
    @IBAction func buttonSent(_ sender: Any) {
        let realm = try! Realm()
        if button.currentTitle == "送出" {
            if let user = UserName.text ,let message = tvtext.text {
                    let new_message = MessageBoard(Name: user, Constent: message, CurrenTime: GetSystemTime())
                try! realm.write{
                    realm.add(new_message)}
                if sortOrNot == 0{
                        //資料庫寫入後，儲存的arr也要一起append
                        self.MessageArray.append(new_message)
                }else {
                    let insertionIndex = MessageArray.firstIndex(where: { $0.CurrenTime < new_message.CurrenTime }) ?? MessageArray.count
                        MessageArray.insert(new_message, at: insertionIndex)
                }
            }
                UserName.text = ""
                tvtext.text = ""
                tbview.reloadData()
        }
        if button.currentTitle == "編輯"{
            try! realm.write{
                edit_cell?.Name = self.UserName.text ?? ""
                edit_cell?.Constent = self.tvtext.text ?? ""
                edit_cell?.CurrenTime = GetSystemTime()
                
                self.editCell_Time?.Name = self.edit_cell?.Name ?? ""
                self.editCell_Time?.Constent = self.edit_cell?.Constent ?? ""
                self.editCell_Time?.CurrenTime = edit_cell?.CurrenTime ?? ""
                tbview.reloadData()
            }
            self.button.setTitle("送出", for: .normal)
            self.button.backgroundColor = UIColor.blue
            UserName.text = ""
            tvtext.text = ""
        }
    }
    
    @IBAction func SortButton(_ sender: Any) {
        let realm = try! Realm()
        let Message_Board = realm.objects(MessageBoard.self)
        if Message_Board.count == 0 {
            let controller = UIAlertController(title: "沒有輸入留言", message: "請輸入留言", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true)
        }
        let alertController = UIAlertController(title: "排序方式", message: "排序方式為留言時間的先後順序", preferredStyle: .actionSheet)
        let formNewToOldAction = UIAlertAction(title: "從新到舊", style: .default) { _ in let sort_result = Message_Board.sorted(byKeyPath: "CurrenTime" , ascending: false)
            self.MessageArray = []
            guard sort_result.count > 0 else {
                self.tbview.reloadData()
                return
            }
            for i in 0..<sort_result.count{
                self.MessageArray.append(MessageBoard(
                    Name: sort_result[i]["Name"] as! String,
                    Constent: sort_result[i]["Constent"] as! String,
                    CurrenTime: sort_result[i]["CurrenTime"] as! String))
            }
            self.sortOrNot = 1
            self.tbview.reloadData() }
        let formOldToNewAction = UIAlertAction(title: "從舊到新", style: .default) { _ in  let sort_result = Message_Board.sorted(byKeyPath: "CurrenTime" , ascending: true)
            self.MessageArray = []
            guard sort_result.count > 0 else {
                self.tbview.reloadData()
                return
            }
            for i in 0..<sort_result.count{
                self.MessageArray.append(MessageBoard(
                    Name: sort_result[i]["Name"] as! String,
                    Constent: sort_result[i]["Constent"] as! String,
                    CurrenTime: sort_result[i]["CurrenTime"] as! String))
            }
            self.sortOrNot = 0
            self.tbview.reloadData()}
        
        let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler: nil)
        alertController.addAction(formNewToOldAction)
        alertController.addAction(formOldToNewAction)
        alertController.addAction(closeAction)
        self.present(alertController, animated: true)
        
        
       
        
    }
    //抓取現在時間
    func GetSystemTime() -> String {
        let currectDate = Date()
        let DateFormatter: DateFormatter = DateFormatter()
        DateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        DateFormatter.locale = Locale.ReferenceType.system
        DateFormatter.timeZone = TimeZone.ReferenceType.system
        return DateFormatter.string(from: currectDate)
    }
    
    
    // MARK: - Function
    
}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MessageArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tbview.dequeueReusableCell(withIdentifier: MainTableViewCell.identifie, for: indexPath) as! MainTableViewCell
        cell.lbText!.text = String(self.MessageArray[indexPath.row].Name)
        cell.lbText2!.text = String(self.MessageArray[indexPath.row].Constent)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (_, _, completionHandler) in
            let realm = try! Realm()
            // 比較與原本的資料數量是否一致
            if indexPath.row < self.MessageArray.count{
                self.deleteArr_cell = self.MessageArray[indexPath.row]
                let edit_CurrentTime = self.deleteArr_cell?.CurrenTime
                // 抓取要刪除的資料
                let delete_cell = realm.objects(MessageBoard.self).where{$0.CurrenTime == edit_CurrentTime ?? ""}[0]
                // 刪除
                try! realm.write{
                    realm.delete(delete_cell)
                }
                self.MessageArray.remove(at: indexPath.row)
                self.tbview.deleteRows(at: [indexPath], with: .automatic)
                //self.tbview.reloadData()
                //這邊不用從新更新資料庫的原因是因為deleteRows(at: [indexPath]已經更新過了
            }
            
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //這邊創建了一個實例UIContextualAction，style是正常樣式
        //{ [self] (_,_, completionHandler) 這邊是閉包的開始，前面兩個參數是_可以忽略不看，最後一個completionHandler是操作完成後，要呼叫這個參數，並告訴系統已完成操作
        let editAction = UIContextualAction(style: .normal, title: "edit") { [self] (_,_, completionHandler) in self.button.setTitle("編輯", for: .normal)
            self.button.backgroundColor = UIColor.magenta
            
        //if indexPath.row < self.MessageArray.count 是用來檢查這個索引有沒有超出範圍
            if indexPath.row < self.MessageArray.count{
                self.edit_cell = self.MessageArray[indexPath.row]
                self.UserName.text = self.edit_cell?.Name
                self.tvtext.text = self.edit_cell?.Constent
                
                let edit_CurrenTime = self.edit_cell?.CurrenTime
                //打開資料庫
                let realm = try! Realm()
                //這邊從資料庫查找時間相同的資料，currenTime是抓取第一個符合條件的對象
                editCell_Time = realm.objects(MessageBoard.self).where{
                    $0.CurrenTime == edit_CurrenTime ?? ""
                }[0]
                
            }
            //刷新tableview內的資料
            self.tbview.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [editAction])
    }
                                           
    
    
    
}
