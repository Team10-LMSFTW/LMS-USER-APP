//
//  ChoiceBookEntry.swift
//  libmgmtftw
//
//  Created by Yuvraj Pandey on 10/05/24.
//

import SwiftUI

struct ChoiceBookEntry: View {
    @State private var isPresentingRequestBookPage: Bool = false
    @State private var isPresentingScanBookPage: Bool = false
    @State private var bookRequest: BookRequest
    
    init(bookRequest: BookRequest = BookRequest(id: UUID(), name: "", author: "", description: nil, edition: nil, status: 0, category: "",library_id: "1")) {
        _bookRequest = State(initialValue: bookRequest)
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 120) {
                Text("Request New Book")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                    .padding(.leading, 20)
                
                Spacer()
                
                VStack {
                    HStack (spacing: 80) {
                        
                        VStack (spacing: 20) {
                            
                            Button(action: {
                                self.isPresentingRequestBookPage = true
                            }) {
                                Image(systemName: "plus.viewfinder")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .padding()
                            }
                            .background(Color(hex:"FD5F00", opacity :0.8))
                            .cornerRadius(12)
                            .sheet(isPresented: $isPresentingRequestBookPage) {
                                RequestsaddView(bookRequest: bookRequest)
                            }
                            
                            Text("Add Book")
                            
                        }
                        
                        
                        VStack (spacing: 20) {
                            
                            Button(action: {
                                self.isPresentingScanBookPage = true
                            }) {
                                Image(systemName: "barcode.viewfinder")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .padding()
                            }
                            .background(Color(hex:"FD5F00", opacity :0.8))
                            .cornerRadius(12)
                            .sheet(isPresented: $isPresentingScanBookPage) {
                                BookDetailsEntryView()
                            }
                            
                            Text("Scan Book")
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ChoiceBookEntry()
}
