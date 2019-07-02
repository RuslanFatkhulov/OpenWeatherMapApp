//
//  NetworkManager.swift
//  OpenWeatherMapApp
//
//  Created by Ruslan Fatkhulov on 01/07/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private var apiKey: String {
        var dictionary: NSDictionary?
        if let bmpath = Bundle.main.path(forResource: "keys", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: bmpath)
        }
        let apiKey = dictionary?.value(forKeyPath: "apiKey") as! String
        return apiKey
    }
    
    private func prepareUrl(params: [String: String]) -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.string!
    }
    
    func dataRequest(city: String, completition: @escaping (JSONCurrentWeatherModel?, Error?) -> ()) {
        
        let params = ["units" : "metric", "APPID" : "\(apiKey)"]
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = prepareUrl(params: params) + "&q=\(cityEscaped)"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            if let error = error {
                completition(nil, error)
                return }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(JSONCurrentWeatherModel.self, from: data)
                completition(result, nil)
            } catch {
                completition(nil, error)
            }
        }.resume()
    }
}
