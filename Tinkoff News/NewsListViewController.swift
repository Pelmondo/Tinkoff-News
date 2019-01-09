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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let segIndentif = "newsDiscript"
    let api = NetworkingAPI()
    public var chooseRow : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        DispatchQueue.main.async {
        self.api.test()
        self.api.delegate = self
        self.newsListTableView.delegate = self
        self.newsListTableView.dataSource = self
        }
        newsListTableView.reloadData()
        newsListTableView.rowHeight = 75
        newsListTableView.estimatedRowHeight = UITableView.automaticDimension
       
    }
    
   
    
    func newsContainer(news: Response) {
        self.ContiTest = news
        DispatchQueue.main.async {
            self.newsListTableView.isHidden = false
            self.newsListTableView.reloadData()
            self.indicatorView.stopAnimating()
        }
    }

    var path = IndexPath()
    var ContiTest : Response?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segIndentif {
            if let title = ContiTest {
            segue.destination.title = title.response.news[path.row].title
                if let dvc = segue.destination as? NewsTextViewController {
                    print(path.row)
                    dvc.choose = path.row
                }
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}



extension NewsListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = ContiTest?.response.news.count {
            return news
        }
        return 0
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
