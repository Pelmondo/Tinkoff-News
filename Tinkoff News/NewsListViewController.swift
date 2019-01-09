//
//  ViewController.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 04/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController, NewsBring {
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    let segIndentif = "newsDiscript"
    let api = NetworkingAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.test()
        api.delegate = self
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        newsListTableView.reloadData()
        newsListTableView.rowHeight = 70
        newsListTableView.estimatedRowHeight = UITableView.automaticDimension
       
    }
    
    func newsContainer(news: Response) {
        self.ContiTest = news
        DispatchQueue.main.async {
            self.newsListTableView.reloadData()
        }
    }

    var path = IndexPath()
    var ContiTest : Response?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segIndentif {
            if let title = ContiTest?.response.news[path.row].title {
            segue.destination.title = title
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    var news = [NewsTest(title: "first", text: "text text"), NewsTest(title: "second", text: "text second"), NewsTest(title: "third", text: "text text text")]
 
    
}



extension NewsListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = ContiTest?.response.news.count {
            return news
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitle", for: indexPath)
        if let cell = cell as? CellConfig {
            if let news = ContiTest?.response {
                cell.newsTitleLabel.text = news.news[indexPath.row].title
            }
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
