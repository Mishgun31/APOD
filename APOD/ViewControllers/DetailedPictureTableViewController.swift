//
//  DetailedPictureTableViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 30.01.2022.
//

import youtube_ios_player_helper

class DetailedPictureTableViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var astronomyImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var backgroundImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageViewBottomConstraint: NSLayoutConstraint!
    
    var astronomyPicture: AstronomyPicture!
    var pictureDimension: PictureDimension!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.sectionHeaderHeight = 0
        setupLayout()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        
        if astronomyPicture.thumbnailUrl != nil {
            playerView.isHidden = false
            backgroundImageView.isHidden = true
            
            if let videoUrl = astronomyPicture.url {
                let videoID = extractVideID(from: videoUrl)
                playerView.load(withVideoId: videoID)
            }
            
        } else {
            astronomyImage.layer.cornerRadius = 15
            backgroundImageView.setupShadow(
                radius: 5,
                opacity: 0.5,
                offset: CGSize(width: 1, height: 1),
                darkModeColor: .white,
                lightModeColor: .black
            )
            
            let _ = CacheManager.shared.getImage(with: astronomyPicture.url ?? "") {
                [weak self] imageData in
                
                self?.astronomyImage.image = UIImage(data: imageData)
            }
        }
        
        titleLabel.text = astronomyPicture.title
        descriptionLabel.text = astronomyPicture.explanation
    }
    
    private func extractVideID(from url: String) -> String {
        let urlComponents = url.split(separator: "/").map(String.init)
        guard let videoID = urlComponents.last else { return "" }
        
        return videoID
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if astronomyPicture.thumbnailUrl != nil, indexPath.row == 1 {
            return playerView.bounds.width / (4.0 / 3.0)
        }
        
        if astronomyPicture.thumbnailUrl == nil, indexPath.row == 1 {
            let margins = tableView.layoutMargins
            let cellWidth = tableView.bounds.width - margins.left - margins.right
            let cellHeight = cellWidth * pictureDimension.aspectRatio
            + backgroundImageViewTopConstraint.constant
            + backgroundImageViewBottomConstraint.constant
            
            return cellHeight
        }
        return UITableView.automaticDimension
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
