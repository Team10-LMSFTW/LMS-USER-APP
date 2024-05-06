import SwiftUI

struct UserDashboardView_New: View {
    
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment:.leading,spacing: 15) {
                    //Day, Date, Hi UserName
                    HomePageView1()
                    
                    
                    
                    Section(header:
                                Text("Summary")
                        .foregroundStyle(Color.primary)
                        .padding(.leading, 20))
                    {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primary.opacity(0.08))
                            .frame(width:350,height: 160)
                            .padding(10)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                            .overlay(
                                HStack{
                                    VStack(alignment:.leading,spacing: 5){
                                        
                                        Text("\(Image(systemName: "bookmark.circle")) Currently Reading")
                                            .font(.title3)
                                            .foregroundStyle(Color.yellow)
                                            .padding()
                                            .padding(.leading,-25)
                                        
                                        
                                        HStack{
                                            VStack(alignment:.leading){
                                                Text("The Alchemist")
                                                    .font(.title)
                                                    .foregroundStyle(Color.yellow)
                                                    .bold()
                                                //.padding(.leading,20)
                                                    .padding(.bottom,40)
                                                
                                                Text("Paulo Coelho")
                                                    .font(.footnote)
                                                    .foregroundStyle(Color.yellow)
                                                //.padding(.leading,20)
                                                    .padding(.top,-30)
                                            }
                                        }
                                        
                                    }
                                    RemoteImage(url: "https://covers.openlibrary.org/b/isbn/9780008283643-M.jpg")
                                        .frame(width: 40, height: 80)
                                        .cornerRadius(10)
                                        .padding(.top)
                                        .padding()
                                    
                                    
                                }
                            )
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primary.opacity(0.08))
                            .frame(width:350,height: 160)
                            .padding(10)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                            .overlay(
                                HStack{
                                    VStack(alignment:.leading,spacing: 5){
                                        
                                        Text("\(Image(systemName: "book")) Books Read")
                                            .font(.title3)
                                            .foregroundStyle(Color.green)
                                            .padding()
                                            .padding(.leading,-25)
                                        
                                        
                                        HStack{
                                            VStack(alignment:.leading){
                                                Text("4 / 5")
                                                    .font(.title)
                                                    .foregroundStyle(Color.green)
                                                    .bold()
                                                //.padding(.leading,20)
                                                    .padding(.bottom,40)
                                                
                                                Text("Books Returned / Borrowed")
                                                    .font(.footnote)
                                                    .foregroundStyle(Color.green)
                                                //.padding(.leading,20)
                                                    .padding(.top,-30)
                                            }
                                        }
                                        
                                    }
                                    DonutView(fractionFilled: 4/5, fillColor: .green)
                                        .padding()
                                    
                                    
                                }
                            )
                        Section(header:
                                    Text("Reccomendations")
                            .foregroundStyle(Color.primary)
                            .padding(.leading, 20))
                        {
                            HStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary.opacity(0.08))
                                    .frame(width:165, height: 160)
                                    .padding(10)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    .overlay(
                                        HStack{
                                            VStack(alignment:.leading,spacing: 5){
                                                
                                                Text("\(Image(systemName: "medal.fill")) Author")
                                                    .font(.title3)
                                                    .foregroundStyle(Color.blue)
                                                    .padding()
                                                    .padding(.leading,-5)
                                                
                                                
                                                HStack{
                                                    VStack(alignment:.leading){
                                                        Text("JK Rowling")
                                                            .font(.title)
                                                            .foregroundStyle(Color.blue)
                                                            .bold()
                                                        //.padding(.leading,20)
                                                            .padding(.bottom,40)
                                                            .padding(.leading,15)
                                                        
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    )
                                
                                Spacer()
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary.opacity(0.08))
                                    .frame(width:165,height: 160)
                                    .padding(10)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    .overlay(
                                        HStack{
                                            VStack(alignment:.leading,spacing: 5){
                                                
                                                Text("\(Image(systemName: "medal.fill")) Genre")
                                                    .font(.title3)
                                                    .foregroundStyle(Color.purple)
                                                    .padding()
                                                    .padding(.leading,-5)
                                                
                                                
                                                HStack{
                                                    VStack(alignment:.leading){
                                                        Text("Romance")
                                                            .font(.title)
                                                            .foregroundStyle(Color.purple)
                                                            .bold()
                                                            .padding(.leading,15)
                                                        //.padding(.leading,20)
                                                            .padding(.bottom,40)
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    )
                            }
                            
                            HStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary.opacity(0.08))
                                    .frame(width:165, height: 160)
                                    .padding(10)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    .overlay(
                                        HStack{
                                            VStack(alignment:.leading,spacing: 5){
                                                
                                                Text("\(Image(systemName: "magnifyingglass.circle")) Explore")
                                                    .font(.title3)
                                                    .foregroundStyle(Color.orange)
                                                    .padding()
                                                    .padding(.leading,-40)
                                                
                                                
                                                HStack{
                                                    VStack(alignment:.leading){
                                                        Text("More ->")
                                                            .font(.title)
                                                            .foregroundStyle(Color.orange)
                                                            .bold()
                                                        //.padding(.leading,20)
                                                            .padding(.bottom,40)
                                                            .padding(.leading,-25)
                                                        
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    )
                                
                                Spacer()
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary.opacity(0.08))
                                    .frame(width:165,height: 160)
                                    .padding(10)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    .overlay(
                                        HStack{
                                            VStack(alignment:.leading,spacing: 5){
                                                
                                                Text("\(Image(systemName: "indianrupeesign")) Penalty")
                                                    .font(.title3)
                                                    .foregroundStyle(Color.red)
                                                    .padding()
                                                    .padding(.leading,-40)
                                                
                                                
                                                HStack{
                                                    VStack(alignment:.leading){
                                                        Text("Rs. 300")
                                                            .font(.title)
                                                            .foregroundStyle(Color.red)
                                                            .bold()
                                                            .padding(.leading,-25)
                                                        //.padding(.leading,20)
                                                            .padding(.bottom,40)
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    )
                            }
                        }
                    }
                    
                    .listStyle(.plain) // Use plain list style
                }.navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                    .padding() // Add padding to the VStack
            }
        }
    }
}

struct UserDashboardView_New_Previews: PreviewProvider {
    static var previews: some View {
        UserDashboardView_New()
    }
}
