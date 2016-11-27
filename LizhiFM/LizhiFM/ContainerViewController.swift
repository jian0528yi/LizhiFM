//
//  ContainerViewController.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/24.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit
import MJRefresh

class ContainerViewController: UITableViewController {

    let networkTools = NetworkTools.shareInstance
    var container: Container?
    var identifier = "ContainerCell"

    lazy var medias: NSMutableArray = {
        let medias = NSMutableArray()
        return medias
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if (nil == self.container?.title) {
            self.title = "荔枝FM"
        } else {
            self.title = self.container?.title
        }

        setupFooter()
    }

    func setupFooter() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData))
        footer?.setTitle("点击或上拉刷新", for: .idle)
        footer?.setTitle("正在加载...", for: .refreshing)
        footer?.setTitle("没有更多数据了！", for: .noMoreData)
        self.tableView.mj_footer = footer
        self.tableView.mj_footer.beginRefreshing()
    }

    func loadData() {
        weak var weakSelf = self

        if ("playlist" == container?.itemType) {
            self.identifier = "TrackCell"
        }

        networkTools.getMetadata(container: container, index: UInt(self.medias.count), completeHandler: {(dict: NSDictionary) in
            let array = dict.object(forKey: "data")
            let total = dict.object(forKey: "total") as! String
            weakSelf?.medias.addObjects(from: array as! [Any])
            weakSelf?.refreshTableView(total: total)

        }, errorHandler:{ (error: Error) in
            print("加载失败")
        })
    }

    func refreshTableView(total: String) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()

            // 显示没有更多数据
            if (self.medias.count >= Int(total)!) {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }

        // 如果当前数据小于一屏，则隐藏 footer
        let numOfRowsInScreen = self.numOfRowsInScreen()
        let num = Int(total)

        if (num! <= numOfRowsInScreen) {
            self.tableView.mj_footer.isHidden = true
        }
    }

    func numOfRowsInScreen() -> Int {
        let screenHeight = UIScreen.main.bounds.height
        let navMaxY = self.navigationController?.navigationBar.frame.maxY
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let num = (screenHeight - navMaxY! - tabBarHeight!) / 60

        return Int(num)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ("playlist" == self.container?.itemType) {
            self.identifier = "TrackCell"

            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell

            let track = medias.object(at: indexPath.row) as! Track
            cell.track = track
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContainerCell", for: indexPath) as! ContainerCell

            let container = medias.object(at: indexPath.row) as! Container
            cell.container = container
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*[tableView deselectRowAtIndexPath:indexPath animated:YES];

         LBContainer *container = _medias[indexPath.row];

         if ([container.itemType isEqualToString:@"container"]) {
         LBContainerViewController *vc = [[LBContainerViewController alloc] init];
         vc.container = container;
         [self.navigationController pushViewController:vc animated:YES];
         } else if ([container.itemType isEqualToString:@"playlist"]) {
         LBTrackViewController *vc = [[LBTrackViewController alloc] init];
         vc.container = container;
         [self.navigationController pushViewController:vc animated:YES];
         }*/

        tableView.deselectRow(at: indexPath, animated: true)
        let container = medias.object(at: indexPath.row) as! Container

//        if ("container" == container.itemType) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
            vc.container = container
            self.navigationController?.pushViewController(vc, animated: true)
//        } else if ("playlist" == container.itemType) {
//            print("playlist")
//        }
    }

}
