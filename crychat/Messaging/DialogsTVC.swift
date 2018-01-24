//
//  DialogsTVC.swift
//  crychat
//
//  Created by Жека on 18/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit

class DialogsTVC: UITableViewController {
    
    var chain : Chain = Chain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refreshData(sender:)), for: UIControlEvents.valueChanged)
        tableView.setContentOffset(CGPoint(x: 0, y: -((refreshControl?.frame.size.height)!)), animated: true)
        refreshControl?.beginRefreshing()
        refreshData(sender: refreshControl!)
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chain.dialogsList.count
    }
    
    @objc func refreshData(sender: UIRefreshControl){
        chain.reload(completionHandler: {_ in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "dialogSegue"? :
            let destination = segue.destination as! DialogVC
            destination.dialog = chain.dialogsChain[(self.tableView.indexPathForSelectedRow?.row)!]
            break
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dialogCell = tableView.dequeueReusableCell(withIdentifier: "dialogCell", for: indexPath) as! DialogCell
        dialogCell.bind(chain.dialogsChain[indexPath.row])
        return dialogCell
    }

}
