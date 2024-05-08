//
//  CommonDetailView.swift
//  libmgmtftw
//
//  Created by Anvit Pawar on 08/05/24.
//

import SwiftUI
import FirebaseFirestore

struct CommonDetailView: View {
    var detailType: DetailType
    
    enum DetailType {
        case author(String)
        case genre(String)
        case membership(String)
        case penalty(String)
        
        var title: String {
            switch self {
            case .author:
                return "Author Details"
            case .genre:
                return "Genre Details"
            case .membership:
                return "Membership Details"
            case .penalty:
                return "Penalty Details"
            }
        }
        
        var content: String {
            switch self {
            case .author(let author):
                return "Author: \(author)"
            case .genre(let genre):
                return "Genre: \(genre)"
            case .membership(let membership):
                return "Membership: \(membership.uppercased())"
            case .penalty(let penalty):
                return "Penalty: Rs.\(penalty)"
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment:.center) {
                
               Spacer()
                
                Text(detailType.content)
                    .font(.title2)
                    .padding()
                
                Spacer()
            }
        }.navigationTitle("\(detailType.title)")
    }
}


