//
//  ViewController.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 04/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    let segIndentif = "newsDiscript"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        newsListTableView.reloadData()
        newsListTableView.rowHeight = UITableView.automaticDimension
        newsListTableView.estimatedRowHeight = 50
    }

    var path = IndexPath()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segIndentif {
            print(news[path.row].title)
            segue.destination.title = news[path.row].title
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    var news = [News(title: "first", text: "text text"), News(title: "second", text: "text second"), News(title: "third", text: "text text text")]

    
}



extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitle", for: indexPath)
        if let cell = cell as? CellConfig {
            cell.newsTitleLabel.text = news[indexPath.row].title
        }
        
        return cell
    }
    
   
    
}

extension NewsListViewController: UITableViewDelegate {
      func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        path = indexPath
        print (path.row)
        return indexPath
    }
}
