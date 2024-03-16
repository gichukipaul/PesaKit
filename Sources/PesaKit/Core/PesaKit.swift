import Foundation

public class PesaKit {
    
    private static let shared = PesaKit()
    
    private var pesaKitConfig: PesaKitConfig?
    private var environment: PesaKitEnvironment = .DEV
    
    private init() { }
    
    static func configure(with config: PesaKitConfig, environment: PesaKitEnvironment = .DEV) {
        guard shared.pesaKitConfig == nil else {
            fatalError("Config must be set only once")
        }
        
        shared.pesaKitConfig = config
        shared.environment = environment
    }
    
    public static func getInstance() -> PesaKit {
        guard shared.pesaKitConfig != nil else {
            fatalError("PesaKit is not configured. Call PesaKit.configure(with:environment:) before using getInstance()")
        }
        
        return shared
    }
    
    private func authenticate(completion: @escaping (Result<TokenResponse, PesaError>) -> Void) {
        guard let pesaKitConfig = pesaKitConfig, !pesaKitConfig.consumerKey.isEmpty, !pesaKitConfig.consumerSecret.isEmpty else {
            completion(.failure(.credentialsNotSet))
            return
        }
        
        let credentials = pesaKitConfig.credentials
        let base64Credentials = Data(credentials.utf8).base64EncodedString()
        let authHeader = "Basic \(base64Credentials)"
        
        guard let url = URL(string: environment.credentialsUrl) else {
            completion(.failure(.invalidEnvironment))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(.networkError(error)))
                } else {
                    completion(.failure(.unknownError))
                }
                return
            }
            
            do {
                let token = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(.success(token))
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
    }
    
    func lipaNaMpesa(paymentRequest: LipaNaMpesaPaymentRequest, completion: @escaping (Result<LipaNaMpesaResponse, PesaError>) -> Void) {
            // Authenticate and handle authentication result
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    UserDefaults.standard.set(tokenResponse.access_token, forKey: "token")
                case .failure(_):
                    UserDefaults.standard.set("", forKey: "token")
                    completion(.failure(.invalidAccessToken))
                    return
            }
            
                // Retrieve token from UserDefaults
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.failure(.invalidAccessToken))
                return
            }
            
                // Construct request URL
            guard let url = URL(string: environment.lipaNaMpesaUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }
            
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            
                // Encode payment request body
            guard let body = try? JSONEncoder().encode(paymentRequest) else {
                completion(.failure(.encodingError("Cannot encode paymentRequest body")))
                return
            }
            request.httpBody = body
            
                // Perform data task
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        completion(.failure(.networkError(error)))
                    } else {
                        completion(.failure(.unknownError))
                    }
                    return
                }
                
                    // Decode response
                do {
                    let lipaResponse = try JSONDecoder().decode(LipaNaMpesaResponse.self, from: data)
                    completion(.success(lipaResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }
}
