import Foundation

public class PesaKit {
    
    private static let shared = PesaKit()
    
    private var pesaKitConfig: PesaKitConfig?
    private var environment: PesaKitEnvironment = .DEV
    
    private init() { }
    
    public static func configure(with config: PesaKitConfig, environment: PesaKitEnvironment = .DEV) {
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
    
    public func lipaNaMpesa(paymentRequest: LipaNaMpesaPaymentRequest, completion: @escaping (Result<LipaNaMpesaResponse, PesaError>) -> Void) {
            // Authenticate and handle authentication result
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

                // Retrieve token from Keychain
            guard let token = KeychainManager.shared.getToken() else {
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
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    private func authenticate() async throws -> TokenResponse {
        guard let pesaKitConfig = pesaKitConfig, !pesaKitConfig.consumerKey.isEmpty, !pesaKitConfig.consumerSecret.isEmpty else {
            throw PesaError.invalidCredentials
        }
        
        let credentials = pesaKitConfig.credentials
        let base64Credentials = Data(credentials.utf8).base64EncodedString()
        let authHeader = "Basic \(base64Credentials)"
        
        guard let url = URL(string: environment.credentialsUrl) else {
            throw PesaError.invalidEnvironment
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(TokenResponse.self, from: data)
    }
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func lipaNaMpesa(paymentRequest: LipaNaMpesaPaymentRequest) async throws -> LipaNaMpesaResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }
        
        guard let url = URL(string: environment.lipaNaMpesaUrl) else {
            throw PesaError.invalidEnvironment
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
            // Encode payment request body
        guard let body = try? JSONEncoder().encode(paymentRequest) else {
            throw PesaError.encodingError("Cannot encode paymentRequest body")
        }
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(LipaNaMpesaResponse.self, from: data)
    }

    // MARK: - STK Push Query

    public func stkPushQuery(queryRequest: StkPushQueryRequest, completion: @escaping (Result<StkPushQueryResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.stkPushQueryUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(queryRequest) else {
                completion(.failure(.encodingError("Cannot encode queryRequest body")))
                return
            }
            request.httpBody = body

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
                    let queryResponse = try JSONDecoder().decode(StkPushQueryResponse.self, from: data)
                    completion(.success(queryResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func stkPushQuery(queryRequest: StkPushQueryRequest) async throws -> StkPushQueryResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.stkPushQueryUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(queryRequest) else {
            throw PesaError.encodingError("Cannot encode queryRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(StkPushQueryResponse.self, from: data)
    }

    // MARK: - Dynamic QR

    public func generateDynamicQR(qrRequest: DynamicQRRequest, completion: @escaping (Result<DynamicQRResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.dynamicQRUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(qrRequest) else {
                completion(.failure(.encodingError("Cannot encode qrRequest body")))
                return
            }
            request.httpBody = body

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
                    let qrResponse = try JSONDecoder().decode(DynamicQRResponse.self, from: data)
                    completion(.success(qrResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func generateDynamicQR(qrRequest: DynamicQRRequest) async throws -> DynamicQRResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.dynamicQRUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(qrRequest) else {
            throw PesaError.encodingError("Cannot encode qrRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(DynamicQRResponse.self, from: data)
    }

    // MARK: - C2B Register URL

    public func registerC2BURL(registerRequest: C2BRegisterURLRequest, completion: @escaping (Result<C2BRegisterURLResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.c2bRegisterUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(registerRequest) else {
                completion(.failure(.encodingError("Cannot encode registerRequest body")))
                return
            }
            request.httpBody = body

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
                    let registerResponse = try JSONDecoder().decode(C2BRegisterURLResponse.self, from: data)
                    completion(.success(registerResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func registerC2BURL(registerRequest: C2BRegisterURLRequest) async throws -> C2BRegisterURLResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.c2bRegisterUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(registerRequest) else {
            throw PesaError.encodingError("Cannot encode registerRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(C2BRegisterURLResponse.self, from: data)
    }

    // MARK: - B2C Payment

    public func b2cPayment(b2cRequest: B2CRequest, completion: @escaping (Result<B2CResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.b2cUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(b2cRequest) else {
                completion(.failure(.encodingError("Cannot encode b2cRequest body")))
                return
            }
            request.httpBody = body

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
                    let b2cResponse = try JSONDecoder().decode(B2CResponse.self, from: data)
                    completion(.success(b2cResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func b2cPayment(b2cRequest: B2CRequest) async throws -> B2CResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.b2cUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(b2cRequest) else {
            throw PesaError.encodingError("Cannot encode b2cRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(B2CResponse.self, from: data)
    }

    // MARK: - Transaction Status

    public func transactionStatus(statusRequest: TransactionStatusRequest, completion: @escaping (Result<TransactionStatusResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.transactionStatusUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(statusRequest) else {
                completion(.failure(.encodingError("Cannot encode statusRequest body")))
                return
            }
            request.httpBody = body

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
                    let statusResponse = try JSONDecoder().decode(TransactionStatusResponse.self, from: data)
                    completion(.success(statusResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func transactionStatus(statusRequest: TransactionStatusRequest) async throws -> TransactionStatusResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.transactionStatusUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(statusRequest) else {
            throw PesaError.encodingError("Cannot encode statusRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(TransactionStatusResponse.self, from: data)
    }

    // MARK: - Account Balance

    public func accountBalance(balanceRequest: AccountBalanceRequest, completion: @escaping (Result<AccountBalanceResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.accountBalanceUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(balanceRequest) else {
                completion(.failure(.encodingError("Cannot encode balanceRequest body")))
                return
            }
            request.httpBody = body

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
                    let balanceResponse = try JSONDecoder().decode(AccountBalanceResponse.self, from: data)
                    completion(.success(balanceResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func accountBalance(balanceRequest: AccountBalanceRequest) async throws -> AccountBalanceResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.accountBalanceUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(balanceRequest) else {
            throw PesaError.encodingError("Cannot encode balanceRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(AccountBalanceResponse.self, from: data)
    }

    // MARK: - Reversals

    public func reverseTransaction(reversalRequest: ReversalRequest, completion: @escaping (Result<ReversalResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.reversalUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(reversalRequest) else {
                completion(.failure(.encodingError("Cannot encode reversalRequest body")))
                return
            }
            request.httpBody = body

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
                    let reversalResponse = try JSONDecoder().decode(ReversalResponse.self, from: data)
                    completion(.success(reversalResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func reverseTransaction(reversalRequest: ReversalRequest) async throws -> ReversalResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.reversalUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(reversalRequest) else {
            throw PesaError.encodingError("Cannot encode reversalRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ReversalResponse.self, from: data)
    }

    // MARK: - Business to Business (B2B)

    public func b2bPayment(b2bRequest: B2BRequest, completion: @escaping (Result<B2BResponse, PesaError>) -> Void) {
        authenticate { [self] result in
            switch result {
                case .success(let tokenResponse):
                    KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)
                case .failure(_):
                    KeychainManager.shared.deleteToken()
                    completion(.failure(.invalidAccessToken))
                    return
            }

            guard let token = KeychainManager.shared.getToken() else {
                completion(.failure(.invalidAccessToken))
                return
            }

            guard let url = URL(string: environment.b2bUrl) else {
                completion(.failure(.invalidEnvironment))
                return
            }

            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"

            guard let body = try? JSONEncoder().encode(b2bRequest) else {
                completion(.failure(.encodingError("Cannot encode b2bRequest body")))
                return
            }
            request.httpBody = body

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
                    let b2bResponse = try JSONDecoder().decode(B2BResponse.self, from: data)
                    completion(.success(b2bResponse))
                } catch {
                    completion(.failure(.parsingError))
                }
            }.resume()
        }
    }

    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func b2bPayment(b2bRequest: B2BRequest) async throws -> B2BResponse {
        let tokenResponse = try await authenticate()
        KeychainManager.shared.saveToken(tokenResponse.access_token, expiresIn: tokenResponse.expires_in)

        guard let token = KeychainManager.shared.getToken() else {
            throw PesaError.invalidAccessToken
        }

        guard let url = URL(string: environment.b2bUrl) else {
            throw PesaError.invalidEnvironment
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        guard let body = try? JSONEncoder().encode(b2bRequest) else {
            throw PesaError.encodingError("Cannot encode b2bRequest body")
        }
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(B2BResponse.self, from: data)
    }
}
