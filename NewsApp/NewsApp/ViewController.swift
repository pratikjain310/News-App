//
//  ViewController.swift
//  NewsApp

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var newsTableView: UITableView!
    var newsArr : NewsAPIStructure?
  override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
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
        return newsArr?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CustomTableViewCell
       let article = newsArr?.articles[indexPath.row]
        cell.headingLabel.text = article?.title
        cell.detailLabel.text = article?.description
        let url = URL(string: article!.urlToImage)
        do {
            cell.newsImageView.image = UIImage(data: try Data(contentsOf: url!))
        }catch let error {
            print(error.localizedDescription)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController")as! DetailViewController
        let article = newsArr?.articles[indexPath.row]
        vc.detailArticle = article
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
