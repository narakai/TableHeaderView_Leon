//
//  ViewController.swift
//  TableHeaderView_Leon
//
//  Created by lai leon on 2017/9/5.
//  Copyright © 2017 clem. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

let HeadViewHeight = YHHeight / 3.0

class ViewController: UIViewController {

    let data = ["下", "拉", "可", "以", "出", "现", "很", "神", "奇", "的", "事", "情", "yo"]
    let cellReuseIdentifier = "CustomCell"

    let tableView: UITableView = {
        let tableView = UITableView(frame: YHRect, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = true
        //下面两句必不可少，否则会出现第一次加载时位置不对的情况
        tableView.contentInset.top = HeadViewHeight
        tableView.contentOffset = CGPoint(x: 0.0, y: -HeadViewHeight)
        tableView.scrollIndicatorInsets.top = HeadViewHeight//右边指示器的位置
        return tableView
    }()

    let headView: UIImageView = {
        let headView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: YHWidth, height: HeadViewHeight))
        headView.backgroundColor = .white
        headView.contentMode = .scaleAspectFill
        headView.clipsToBounds = true
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }


    private func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(headView)

        //加载图片
        let url = URL(string: "http://c.hiphotos.baidu.com/zhidao/pic/item/5ab5c9ea15ce36d3c704f35538f33a87e950b156.jpg")
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard let _ = data, error == nil else {
                return
            }
            //回到主线程
            DispatchQueue.main.sync {
                self.headView.image = UIImage(data: data!)
            }
        }
        task.resume()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.addSubview(tableView)

        view.sendSubview(toBack: tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsety = scrollView.contentOffset.y + scrollView.contentInset.top
        if offsety <= 0 {
            offsety = 0
            tableView.bounces = false
            headView.frame = CGRect(x: 0.0, y: 0.0, width: YHWidth, height: HeadViewHeight)
            headView.alpha = 1
        } else {
            tableView.bounces = true
            let height = (HeadViewHeight - offsety) <= 0.0 ? 0.0 : (HeadViewHeight - offsety)
            headView.frame = CGRect(x: 0.0, y: 0.0, width: YHWidth, height: height)
            headView.alpha = height / HeadViewHeight
        }
    }
}
