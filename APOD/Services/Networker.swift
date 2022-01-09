//
//  Networker.swift
//  APOD
//
//  Created by Михаил Мезенцев on 19.12.2021.
//

import Foundation

enum RequestType {
    case defaultRequest
    case chosenDateRequest(date: String)
    case randomObjectsRequest(numberOfObjects: Int)
    case rangeDatesRequest(startDate: String, endDate: String)
}

class Networker {
    
    static let shared = Networker()
    
    private let query = "https://api.nasa.gov/planetary/apod?api_key=hmCWwn6l2SmCAbSzNnbeYOSQIPGZwh0CLJ1NCm1G"
    
    private init() {}
    
    // MARK: - Fetch data methods
    
    func fetchData(with requestType: RequestType,
                   completion: @escaping (Result<Any, Error>) -> Void) {
        
        let (urlStirng, isExpectArray) = createURL(withRequestType: requestType)
        guard let url = URL(string: urlStirng) else { return }
        
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data, let _ = urlResponse else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if isExpectArray {
                    let astronomyPictureObject = try decoder.decode([AstronomyPicture].self,
                                                                    from: data)
                    DispatchQueue.main.async {
                        completion(.success(astronomyPictureObject))
                    }
                } else {
                    let astronomyPictureObject = try decoder.decode(AstronomyPicture.self,
                                                                    from: data)
                    DispatchQueue.main.async {
                        completion(.success(astronomyPictureObject))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchImage(with url: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard url == response.url else { return }
            
            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }
    
    private func createURL(withRequestType requestType: RequestType) -> (String, Bool) {
        var urlString = ""
        var isExpectArray = false
        
        switch requestType {
        case .defaultRequest:
            urlString = query
            isExpectArray = false
        case let .chosenDateRequest(date):
            urlString = query + "&date=\(date)"
            isExpectArray = false
        case let .randomObjectsRequest(numberOfObjects):
            urlString = query + "&count=\(numberOfObjects)"
            isExpectArray = true
        case let .rangeDatesRequest(startDate, endDate):
            urlString = query + "&start_date=\(startDate)&end_date=\(endDate)"
            isExpectArray = true
        }
        
        return (urlString, isExpectArray)
    }
}
