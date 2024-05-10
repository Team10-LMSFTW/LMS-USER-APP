//
//  DetailView.swift
//  libmgmtftw
//
//  Created by Anvit Pawar on 06/05/24.
//

import SwiftUI

import SwiftUI

struct DetailView: View {
    var headline: String
    var subheadline: String
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                Text(headline)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                Text(subheadline)
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    // Dismiss notification action
                }) {
                    Text("Dismiss Notification")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Notification Detail")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(headline: "Headline", subheadline: "Subheadline")
    }
}
