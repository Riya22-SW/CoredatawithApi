//
//  ApiManager.swift
//  CDwithAPI
//
//  Created by admin on 10/12/24.
//

import Foundation
import Alamofire

class ApiManager{
    
   let urlstr="https://official-joke-api.appspot.com/jokes/random/25"
    
    func fetchJokes(completionHandler: @escaping(Result<[JokeModel],Error>)-> Void) {
        
      
        
        AF.request(urlstr).responseDecodable(of: [JokeModel].self){response in
            switch response.result{
                
            case.success(let data):
                completionHandler(.success(data))
                
            case.failure(let error):
                completionHandler(.failure(error))
                
        
        
    }
        
        }
    }
}
