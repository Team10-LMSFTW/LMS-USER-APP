//
//  BookRequestsModel.swift
//  libmgmtftw
//
//  Created by mathangy on 02/05/24.
//

import Foundation
struct BookRequest: Identifiable { // Conforming to Identifiable
    let id: UUID
    let bookName: String
    let author: String
    let description: String?
    let edition: String?
    let status: Int
//    let category: String
//    let library_id : String
    
}
