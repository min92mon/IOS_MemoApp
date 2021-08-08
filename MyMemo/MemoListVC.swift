//
//  MemoListVC.swift
//  MemoListVC
//
//  Created by 정민영 on 2021/08/02.
//

import UIKit

class MemoListVC: UITableViewController {
    var param: MemoData?
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revealVC = self.revealViewController() {
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            self.navigationItem.leftBarButtonItem = btn
            
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.appDelegate.memoList.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appDelegate.memoList[indexPath.row]
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MemoCell else {
            let cell = MemoCell(style: .default, reuseIdentifier: cellId)
            return cell
        }

        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        let row = self.appDelegate.memoList[indexPath.row]
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
        */
        self.param = self.appDelegate.memoList[indexPath.row]
        performSegue(withIdentifier: "read_sg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "read_sg" == segue.identifier {
            guard let memoReadVC = segue.destination as? MemoReadVC, let memoListVC = sender as? MemoListVC else{
                return
            }
            
            memoReadVC.param = memoListVC.param
        }
    }
}
