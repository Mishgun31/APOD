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
    
    private var lastUserRequest: RequestType = .randomObjectsRequest(numberOfObjects: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        
        tableView.register(
            UINib(nibName: "CustomHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CustomHeaderView"
        )
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 25
        loadData()
    }
    
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        animateHeaderSpinner(forSection: 0, true)
        animateHeaderSpinner(forSection: 1, true)
        getData(with: .defaultRequest)
        getData(with: lastUserRequest)
        sender.endRefreshing()
    }
}
    
// MARK: - Table view data source

extension PictureListViewController {
    
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
        
        indexPath.section == 0
        ? cell.configure(with: todayPicture)
        : cell.configure(with: pictures?[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "CustomHeaderView"
        ) as? CustomHeaderView else { return nil }
        
        section == 0
        ? headerView.configure(with: "The photo of the day")
        : headerView.configure(with: "Let's see other photos")
        
        return headerView
    }
}
    
// MARK: - Table view delegate

extension PictureListViewController {
    
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
}
    
// MARK: - Navigation

extension PictureListViewController {
    
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
        pictures?.removeAll()
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        animateHeaderSpinner(forSection: 1, true)
        getData(with: settingVC.request)
        lastUserRequest = settingVC.request
    }
}

// MARK: - Private methods

extension PictureListViewController {
    
    private func getData(with requestType: RequestType) {
        Networker.shared.fetchData(with: requestType) { result in
            switch result {
            case .success(let astronomyPictureObject):
                if let astronomyPicture = astronomyPictureObject as? AstronomyPicture {
                    
                    switch requestType {
                    case .defaultRequest:
                        self.todayPicture = astronomyPicture
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        self.animateHeaderSpinner(forSection: 0, false)
                        DataManager.shared.saveSingle(picture: self.todayPicture)
                    default:
                        self.pictures?.removeAll()
                        self.pictures?.append(astronomyPicture)
                        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                        self.animateHeaderSpinner(forSection: 1, false)
                        DataManager.shared.save(pictures: self.pictures)
                    }
                    print("Request for single object succed")
                    
                } else if let astronomyPictures = astronomyPictureObject as? [AstronomyPicture] {
                    self.pictures = astronomyPictures
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    self.animateHeaderSpinner(forSection: 1, false)
                    DataManager.shared.save(pictures: self.pictures)
                    print("Request for array of objects succed")
                }
                
            case .failure(let error):
                let error = error as? ConnectionError
                self.animateHeaderSpinner(forSection: 0, false)
                self.animateHeaderSpinner(forSection: 1, false)
                self.showAlert(withTitle: "Error",
                               andMessage: error?.localizedDescription ?? "")
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
    
    private func animateHeaderSpinner(forSection section: Int, _ animate: Bool) {
        guard let headerView = tableView.headerView(forSection: section)
                as? CustomHeaderView else { return }
        
        animate
        ? headerView.activityIndicatorView.startAnimating()
        : headerView.activityIndicatorView.stopAnimating()
    }
}
