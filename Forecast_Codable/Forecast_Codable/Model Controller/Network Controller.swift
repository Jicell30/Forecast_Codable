//
//  Network Controller.swift
//  Forecast_Codable
//
//  Created by Jicell on 10/10/22.
//

import Foundation

class NetworkController {
    
    //MARK: - Keys
    
    private static let baseURLString = "https://api.weatherbit.io/v2.0/forecast/daily"
    private static let kCityNameKey = "city"
    private static let kCityNameValue = "San Francisco"
    private static let kAPIKeyKey = "key"
    private static let kAPIKeyValue = "231a707c02074a7f9088dd6191472bde"
    
    //MARK: - Helper Functions
    static func fetchDays(completion: @escaping ([Day]?) -> Void) {
        guard let baseURL = URL(string: baseURLString) else { completion(nil); return}
        
        // MARK: - QUERY ITEMS
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let keyQuery = URLQueryItem(name: kAPIKeyKey, value: kAPIKeyValue)
        let cityQuery = URLQueryItem(name: kCityNameKey, value: kCityNameValue)
        urlComponents?.queryItems = [keyQuery, cityQuery]
        
        // FinalURL
        guard let finalURL = urlComponents?.url else { completion(nil); return}
        print(finalURL)
        
        // Start data task to retrieve data
        URLSession.shared.dataTask(with: finalURL) { dayData, _, error in
            if let error = error {
                print("There was an error recieving the data!", error.localizedDescription)
            }
            guard let data = dayData else { completion(nil); return }
            do {
                let forecastData = try JSONDecoder().decode(TopLevelDictionary.self , from: data)
                completion(forecastData.days)
            } catch {
                print("Error in Do/Try/Catch: \(error.localizedDescription)")
                completion(nil); return
            }
        }.resume()
    }
    
}// End of class.
