//
//  ContentView.swift
//  Chatt-ons
//
//  Created by Guilherme Cintra Castro on 2024-03-14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel =  LoginViewModel()
    @State var goodLogin = false
    
    var body: some View {
      
     
        NavigationStack {
            VStack {
                Image(systemName: "message.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                HStack{
                    Text("Welcome to")
                        .bold()
                    Text("!Chatt-ons!")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .bold()
                }
                
              
                    
                TextField("Your email", text: $viewModel.email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())


                SecureField("Your password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
//
              
                Button("login"){
                    viewModel.login()
                    
                }
                
                
                NavigationLink(destination: HomeView(),isActive: $viewModel.goodLogin, label: {
                    EmptyView()
                })
                NavigationLink(destination: SignupView(), label: {
                    Text("Dont have an account yet?")
                        .padding()
                })
                .padding()
             
                Spacer()
               
              
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
