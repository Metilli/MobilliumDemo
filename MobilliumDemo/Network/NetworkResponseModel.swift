//
//  NetworkResponse.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

struct NetworkResponseModel<T>{
    
    var statusCode: Int
    var data: T?
    private var errorData: NetworkErrorModel?
    var errorMessage: String?
    
    init(statusCode: Int){
        self.statusCode = statusCode
    }
    
    init(statusCode: Int, data: T? = nil, errorData: NetworkErrorModel? = nil, errorMessage: String? = nil){
        self.statusCode = statusCode
        self.data = data
        self.errorData = errorData
        self.errorMessage = errorMessage ?? getErrorMessage()
        
        if !isSuccess(),
           errorMessage == nil{
            self.errorMessage = getErrorMessage()
        }
    }
    
    func isSuccess() -> Bool {
        return statusCode == 200
    }
    
    private func getErrorMessage() -> String{
        if let safeError = self.errorData?.statusMessage{
            return safeError
        }else{
            return "Unkown error."
        }
    }
}

struct NetworkErrorModel:Codable{
    var statusMessage:String?
    var statusCode:Int?
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
