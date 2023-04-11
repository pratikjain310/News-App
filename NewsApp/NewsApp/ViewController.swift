//
//  ViewController.swift
//  NewsApp

import UIKit
import Network
class ViewController: UIViewController {
    let monitor = NWPathMonitor()
    //    var internetConnection : Bool?
    var articleCoreData : ArticleCoreData?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var newsArticle : [ArticleCoreData] = []
    var tempIndexPath : IndexPath?
    @IBOutlet weak var newsTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(style:.medium)
    var newsArr : NewsAPIStructure?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        self.view.addSubview(activityIndicator)
        self.newsTableView.isHidden = true
        
        NetworkConnection.shared.startMonitoring { [unowned self](isConnected) in
            if isConnected {
                self.fetchData()
            } else {
                self.fetchCoreData()
                //show activity indicator
            }
        }
        NetworkConnection.shared.stopMonitoring()
        
    }
    
    func fetchCoreData(){
        do {
            self.newsArticle = try self.context.fetch(ArticleCoreData.fetchRequest())
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.newsTableView.isHidden = false
                self.newsTableView.reloadData()
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    func fetchData(){
        let str = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=95955161d2d04e0ab9676514858a19a3"
        let url = URL(string: str)
        URLSession.shared.dataTask(with: url!) {[unowned self] (data, response, error) in
            do {
                if error == nil {
                    self.newsArr = try JSONDecoder().decode(NewsAPIStructure.self, from: data!)
                }
                DispatchQueue.main.async {
                    
                    let ArticleArr = self.newsArr?.articles
                    do {
                        self.newsArticle = try self.context.fetch(ArticleCoreData.fetchRequest())
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    for obj in newsArticle{
                        context.delete(obj)
                    }
                    do {
                        try context.save()
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    
                    for obj in ArticleArr! {
                        articleCoreData = ArticleCoreData(context: context)
                        articleCoreData?.title = obj.title
                        articleCoreData?.articleDescription = obj.title
                        articleCoreData?.urlToImage = obj.urlToImage
                        articleCoreData?.publishedAt = obj.publishedAt
                        articleCoreData?.url = obj.url
                        do {
                            try context.save()
                        }catch let error{
                            print(error.localizedDescription)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.newsTableView.isHidden = false
                    self.newsTableView.reloadData()
                   }
            }catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NetworkConnection.shared.isReacheableOnCellular == true{
            return newsArr?.articles.count ?? 0
        }else {
            return newsArticle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CustomTableViewCell
        if NetworkConnection.shared.isReacheableOnCellular == true{
            
            // when connected to internet fetching from url
            let article = newsArr?.articles[indexPath.row]
            cell.headingLabel.text = article?.title
            cell.detailLabel.text = article?.description
            let url = URL(string: article!.urlToImage)
            do {
                cell.newsImageView.image = UIImage(data: try Data(contentsOf: url!))
            }catch let error {
                print(error.localizedDescription)
            }
        }else{
            // when not connected to internet fetching from coredata
            
            let alert = UIAlertController.init(title: "Alert", message: "No Internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            let newsArticleObj = newsArticle[indexPath.row]
            cell.headingLabel.text = newsArticleObj.title
            cell.detailLabel.text = newsArticleObj.articleDescription
            let url = URL(string: (newsArticleObj.urlToImage)!)
            do {
                cell.newsImageView.image = UIImage(data: try Data(contentsOf: url!))
            }catch let error {
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController")as! DetailViewController
        if NetworkConnection.shared.isReacheableOnCellular == true{
            let article = newsArr?.articles[indexPath.row]
            vc.detailArticle2 = article
        }else{
            let newsArticleObj = newsArticle[indexPath.row]
            vc.detailArticle = newsArticleObj
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
