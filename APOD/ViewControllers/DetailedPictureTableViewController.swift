//
//  DetailedPictureTableViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 30.01.2022.
//

import UIKit

class DetailedPictureTableViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var astronomyImage: UIImageView!
    
    var astronomyPicture: AstronomyPicture!
    var pictureDimension: PictureDimension!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        setupLayout()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        titleLabel.text = astronomyPicture.title
        descriptionLabel.text = astronomyPicture.explanation
        astronomyImage.layer.cornerRadius = 15
        
        CacheManager.shared.getImage(with: astronomyPicture.url ?? "") { image in
            self.astronomyImage.image = image
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            let margins = tableView.layoutMargins
            let cellWidth = tableView.bounds.width - margins.left - margins.right
            return cellWidth * pictureDimension.aspectRatio
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
