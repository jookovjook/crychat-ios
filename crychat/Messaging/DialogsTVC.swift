//
//  DialogsTVC.swift
//  crychat
//
//  Created by Жека on 18/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit

class DialogsTVC: UITableViewController {
    
    var dialogsList : [Dialog] = []

    override func viewDidLoad() {
        dialogsList.append(Dialog("sdfsdfws"))
        dialogsList.append(Dialog("sdf4r8wdws"))
        dialogsList.append(Dialog("f324f23dwdfsdfws"))
        dialogsList.append(Dialog("sdd2d3fws"))
        dialogsList.append(Dialog("sd3f3r34fws"))
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dialogCell = tableView.dequeueReusableCell(withIdentifier: "dialogCell", for: indexPath) as! DialogCell
        
        dialogCell.bind(dialogsList[indexPath.row])
        
        return dialogCell
    }

}
