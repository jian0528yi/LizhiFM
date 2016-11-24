//
//  ContainerViewController.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/24.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit

class ContainerViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupUI() {

    }

    func loadData() {

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContainerCell", for: indexPath) as! ContainerCell

        let c = Container()
        c.title = String(indexPath.row)
        cell.container = c

        return cell
    }

}
