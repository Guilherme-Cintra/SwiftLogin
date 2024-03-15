//
//  LoginViewModel.swift
//  Chatt-ons
//
//  Created by Guilherme Cintra Castro on 2024-03-14.
//

import Foundation

class LoginViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginMessage: String = ""
    @Published var goodLogin: Bool = false
    
    func login(){
        guard let url = URL(string: "http://localhost:8001/api/login") else { return }

        let loginRequest = LoginRequest(email: email, password: password)
        
    
        let finalBody = try? JSONSerialization.data(withJSONObject: loginRequest)
        
        var request = URLRequest(url: url)
              request.httpMethod = "POST"
              request.httpBody = finalBody
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.loginMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.loginMessage = "No data received"
                }
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    self?.loginMessage = "Invalid response: \(response.statusCode)"
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let user = json["user"] as? [String: Any], let token = json["token"] as? String {
                            UserDefaults.standard.setValue(token, forKey: "userToken")
                            self?.loginMessage = "Login successful"
                            self?.goodLogin = true
                        } else if let errorMessage = json["error"] as? String {
                            self?.loginMessage = errorMessage
                        } else {
                            self?.loginMessage = "Unknown error"
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.loginMessage = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
