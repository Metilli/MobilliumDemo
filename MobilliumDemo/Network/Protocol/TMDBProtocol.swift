//
//  TMDBProtocol.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

protocol TMDBProtocol{
    
    func fetchMovieDetail(movieID: String, params: [String : Any]?, completionHandler: @escaping (NetworkResponseModel<MovieDetail>) -> ())
    
    func fetchMovieNowPlaying(params: [String : Any]?, completionHandler: @escaping (NetworkResponseModel<MovieNowPlaying>) -> ())
    
    func fetchUpcoming(params: [String : Any]?, completionHandler: @escaping (NetworkResponseModel<MovieUpcoming>) -> ())
    
}
