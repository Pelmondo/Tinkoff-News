//
//  ViewController.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 04/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class NewsListViewController: UIViewController, NewsBring {
    

    @IBOutlet weak var newsListTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let segIndentif = "newsDiscript"
    let api = NetworkingAPI()
    public var chooseRow : Int?
    let storage = Storage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            print("It's okay")
        } else {
            let alert = UIAlertController(title: nil, message: "Internet connections failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
   var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        let fetchRequest: NSFetchRequest<NewsEn> = NewsEn.fetchRequest()
        
        do {
            let newsE = try self.storage.mainContext.fetch(fetchRequest)
            
            
        } catch {}
        
        DispatchQueue.main.async {
        self.api.test(initial: 0)
        self.api.delegate = self
        self.newsListTableView.delegate = self
        self.newsListTableView.dataSource = self
        }
        newsListTableView.reloadData()
        newsListTableView.rowHeight = 75
        newsListTableView.estimatedRowHeight = UITableView.automaticDimension
        
        // refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        newsListTableView.addSubview(refreshControl)
       
    }
    
    var countRefr = 0;
    @objc func refresh(_ sender: Any) {
        countRefr += 20
        indicatorView.startAnimating()
        self.newsListTableView.isHidden = true
        DispatchQueue.main.async {
            self.api.test(initial: self.countRefr)
        }
    }
    
    func newsContainer(news: Response) {
        self.ContiTest = news
        DispatchQueue.main.async {
            self.newsListTableView.isHidden = false
            self.newsListTableView.reloadData()
            self.indicatorView.stopAnimating()
            self.refreshControl.endRefreshing()
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
                    dvc.inital = self.countRefr
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
                
                //MARK: - CoreData
                let newsEn = NewsEn(context: self.storage.saveContext)
                
                if let title = ContiTest?.response.news[indexPath.row].title {
                    newsEn.title = title
                }
                
                if let text = ContiTest?.response.news[indexPath.row].text {
                    newsEn.text = text
                }
                DispatchQueue.main.async {
                    self.storage.performSave(with: self.storage.saveContext)
                }
                cell.newsTitleLabel.text = news.news[indexPath.row].title
                var times = 1
                cell.countLabel.text = "\(times)"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
