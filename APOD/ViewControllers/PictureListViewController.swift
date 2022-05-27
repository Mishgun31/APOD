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
        loadData()
        
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
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        section == 0
        ? "The photo of the day"
        : "Let's see other photos"
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
    
    private func getData(with requestType: RequestType) {
        Networker.shared.fetchData(with: requestType) { result in
            switch result {
            case .success(let astronomyPictureObject):
                if let astronomyPicture = astronomyPictureObject as? AstronomyPicture {
                    switch requestType {
                    case .defaultRequest:
                        self.todayPicture = astronomyPicture
                        DataManager.shared.saveSingle(picture: self.todayPicture)
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    default:
                        self.pictures?.removeAll()
                        self.pictures?.append(astronomyPicture)
                        DataManager.shared.save(pictures: self.pictures)
                        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    }
                    print("111")
                } else if let astronomyPictures = astronomyPictureObject as? [AstronomyPicture] {
                    self.pictures = astronomyPictures
                    DataManager.shared.save(pictures: self.pictures)
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    print("222")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadData() {
        if let astronomyPicture = DataManager.shared.loadPicture() {
            
            let currentDate = formatDate(from: Date())
            
            if currentDate == astronomyPicture.date {
                todayPicture = astronomyPicture
            } else {
                getData(with: .defaultRequest)
            }
            
        } else {
            getData(with: .defaultRequest)
        }
        
        if let astronomyPictures = DataManager.shared.loadPictures() {
            pictures = astronomyPictures
        } else {
            getData(with: .randomObjectsRequest(numberOfObjects: 10))
        }
    }
}
