//
//  DayDetailsViewController.swift
//  Forecast_Codable
//
//  Created by Karl Pfister on 2/6/22.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    
    var days: [Day] = []
    var forcastData: TopLevelDictionary?
    
    //MARK: - View Lifecyle
    
    func setUpTable() {
        dayForcastTableView.delegate = self
        dayForcastTableView.dataSource = self 
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
            NetworkController.fetchDays { forcastData in
                guard let forcastData = forcastData else {return}
                self.forcastData = forcastData
                self.days = forcastData.days
                DispatchQueue.main.async {
                    self.updateViews()
                    self.dayForcastTableView.reloadData()
            }
            
        }
    }
    
    func updateViews() {
        let currentDate = days[0]
        cityNameLabel.text = forcastData?.cityName
        currentTempLabel.text = "\(currentDate.temp).F"
        currentHighLabel.text = "\(currentDate.highTemp).F"
        currentLowLabel.text = "\(currentDate.lowTemp).F"
        currentDescriptionLabel.text = currentDate.weather.description
    
    }
}

//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        
        let day = days[indexPath.row]
        cell.updateViews(day: day)
        
        
        return cell
    }
}// End of class

