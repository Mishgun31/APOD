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

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(with: .defaultRequest)
        getData(with: .randomObjectsRequest(numberOfObjects: 10))
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Test Header"
    }
    
    private func getData(with requestType: RequestType) {
        Networker.shared.fetchData(with: requestType) { result in
            switch result {
            case .success(let astronomyPictureObject):
                if let astronomyPicture = astronomyPictureObject as? AstronomyPicture {
                    self.todayPicture = astronomyPicture
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
    
    private func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: date)
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
