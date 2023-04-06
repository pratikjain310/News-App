//
//  DetailViewController.swift
//  NewsApp
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var detailArticle : Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignValue()
       }
    
    @IBAction func shareBarButton(_ sender: UIBarButtonItem) {
        let firstActivityItem = "Description you want.."

        let secondActivityItem : NSURL = NSURL(string: detailArticle!.url)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    func assignValue(){
        publishedAtLabel.text = detailArticle?.publishedAt
        descriptionLabel.text = detailArticle?.description
        titleLabel.text = detailArticle?.title
        let url = URL(string: detailArticle!.urlToImage)
        do {
            newsImageView.image = UIImage(data: try Data(contentsOf: url!))
        }catch let error {
            print(error.localizedDescription)
        }
    }
   
}
