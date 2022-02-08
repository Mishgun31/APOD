//
//  PictureListViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 18.12.2021.
//

import UIKit

class PictureListViewController: UITableViewController {
    
    private var todayPicture: AstronomyPicture?
    private var pictures: [AstronomyPicture]?
    
    private var pictureDimension = PictureDimension(height: 0, width: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(with: .defaultRequest)
        getData(with: .randomObjectsRequest(numberOfObjects: 10))
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 30
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : pictures?.count ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? AstronomyPictureCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            cell.configure(with: todayPicture)
        } else {
            cell.configure(with: pictures?[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedCell = tableView.cellForRow(at: indexPath)
                as? AstronomyPictureCell else { return }
        
        if let size = selectedCell.astronomyImage.image?.size {
            pictureDimension = PictureDimension(
                height: size.height,
                width: size.width
            )
        }
        
        performSegue(withIdentifier: "DetailedPictureVCSegue",
                     sender: indexPath)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailedPictureVC = segue.destination
                as? DetailedPictureTableViewController else { return }
        
        guard let indexPath = sender as? IndexPath else { return }

        switch indexPath.section {
        case 0:
            detailedPictureVC.astronomyPicture = todayPicture
        default:
            detailedPictureVC.astronomyPicture = pictures?[indexPath.row]
        }
        
        detailedPictureVC.pictureDimension = pictureDimension
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let settingVC = segue.source as? SettingsViewController else { return }
        getData(with: settingVC.request)
    }
    
    // MARK: - Private methods
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        section == 0
        ? "The photo of the day"
        : "Test header"
    }
    
    private func getData(with requestType: RequestType) {
        Networker.shared.fetchData(with: requestType) { result in
            switch result {
            case .success(let astronomyPictureObject):
                if let astronomyPicture = astronomyPictureObject as? AstronomyPicture {
                    switch requestType {
                    case .defaultRequest:
                        self.todayPicture = astronomyPicture
                    default:
                        self.pictures?.removeAll()
                        self.pictures?.append(astronomyPicture)
                    }
                    print("111")
                } else if let astronomyPictures = astronomyPictureObject as? [AstronomyPicture] {
                    self.pictures = astronomyPictures
                    print("222")
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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

    
}
