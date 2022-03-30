//
//  URL.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

struct URLs{
    
    static let baseUrl = "https://api.themoviedb.org/3/"
    
    static let movieDetail = baseUrl + "movie/"
    static let upcoming = baseUrl + "movie/upcoming?api_key=" + apiKey
    static let nowPlaying = baseUrl + "movie/now_playing?api_key=" + apiKey
    static let imageUrl = "https://image.tmdb.org/t/p/original"
    
    static var apiKey: String {
      get {
          
        guard let filePath = Bundle.main.path(forResource: "TMDB-info", ofType: "plist") else {
          fatalError("Couldn't find file 'TMDB-info.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Api_Key") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
        }
        
        if (value.starts(with: "_")) {
          fatalError("Register for a TMDB developer account and get an API key at https://developers.themoviedb.org/3/getting-started/introduction.")
        }
        return value
      }
    }
}
