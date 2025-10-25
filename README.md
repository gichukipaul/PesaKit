# PesaKit

PesaKit is a comprehensive Swift SDK for integrating M-Pesa mobile money services into your iOS, macOS, tvOS, and watchOS applications. Built with simplicity and flexibility in mind, PesaKit simplifies payment processing, transaction tracking, and secure authentication.

## Features

- **Secure Authentication**: OAuth 2.0 Bearer Token authentication with secure Keychain storage
- **Lipa Na M-Pesa (STK Push)**: Initiate customer payments with mobile prompts
- **STK Push Query**: Check the status of STK Push requests
- **Dynamic QR**: Generate dynamic QR codes for payments
- **C2B Register URL**: Register callback URLs for customer-to-business payments
- **B2C Payments**: Send payments from business to customers
- **Transaction Status**: Query the status of any M-Pesa transaction
- **Account Balance**: Check M-Pesa account balances
- **Reversals**: Reverse erroneous M-Pesa transactions
- **B2B Payments**: Transfer funds between business accounts (PayBill/BuyGoods)
- **Dual API Support**: Both completion handlers and async/await patterns
- **Comprehensive Error Handling**: Detailed error responses for debugging

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.5+
- Xcode 13.0+

## Installation

### Swift Package Manager

Add PesaKit to your project using Swift Package Manager:

1. In Xcode, go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/gichukipaul/PesaKit`
3. Select the version or branch you want to use
4. Click **Add Package**

Alternatively, add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gichukipaul/PesaKit.git", from: "1.0.0")
]
```

## Getting Started

### 1. Obtain M-Pesa Credentials

Register your application on the [Safaricom Developer Portal](https://developer.safaricom.co.ke) to get:
- Consumer Key
- Consumer Secret
- Passkey (for Lipa Na M-Pesa)
- Shortcode/Till Number

### 2. Configure PesaKit

Configure PesaKit in your app's entry point (e.g., `AppDelegate` or SwiftUI `App` struct):

**SwiftUI:**
```swift
import SwiftUI
import PesaKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let config = PesaKitConfig(
                        consumerKey: "YOUR_CONSUMER_KEY",
                        consumerSecret: "YOUR_CONSUMER_SECRET",
                        environment: .DEV  // Use .PRODUCTION for live transactions
                    )
                    PesaKit.configure(with: config)
                }
        }
    }
}
```

**UIKit (AppDelegate):**
```swift
import UIKit
import PesaKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = PesaKitConfig(
            consumerKey: "YOUR_CONSUMER_KEY",
            consumerSecret: "YOUR_CONSUMER_SECRET",
            environment: .DEV
        )
        PesaKit.configure(with: config)
        return true
    }
}
```

## Usage Examples

### 1. Lipa Na M-Pesa (STK Push)

Initiate a payment request that prompts the customer's phone:

**Completion Handler:**
```swift
import PesaKit

let timestamp = DateFormatter.lipaNaMpesaDateFormatter.string(from: Date())
let password = LipaNaMpesaPassword.generatePassword(
    businessShortCode: "174379",
    passKey: "YOUR_PASSKEY",
    timestamp: timestamp
)

let paymentRequest = LipaNaMpesaPaymentRequest(
    businessShortCode: "174379",
    password: password,
    timestamp: timestamp,
    transactionType: .PayBill,  // or .Till for Buy Goods
    amount: 1,
    partyA: "254712345678",  // Customer phone number
    partyB: "174379",
    phoneNumber: "254712345678",
    callBackURL: "https://yourdomain.com/callback",
    accountReference: "Invoice001",
    transactionDesc: "Payment for goods"
)

PesaKit.getInstance().lipaNaMpesa(paymentRequest: paymentRequest) { result in
    switch result {
    case .success(let response):
        print("Checkout Request ID: \(response.CheckoutRequestID)")
        print("Response Code: \(response.ResponseCode)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

**Async/Await:**
```swift
Task {
    do {
        let response = try await PesaKit.getInstance().lipaNaMpesa(paymentRequest: paymentRequest)
        print("Checkout Request ID: \(response.CheckoutRequestID)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

### 2. STK Push Query

Check the status of an STK Push request:

```swift
let timestamp = DateFormatter.lipaNaMpesaDateFormatter.string(from: Date())

let queryRequest = StkPushQueryRequest(
    businessShortCode: 174379,
    passKey: "YOUR_PASSKEY",
    timestamp: timestamp,
    checkoutRequestID: "ws_CO_12345678"
)

// Completion Handler
PesaKit.getInstance().stkPushQuery(queryRequest: queryRequest) { result in
    switch result {
    case .success(let response):
        print("Result Code: \(response.ResultCode)")
        print("Result Description: \(response.ResultDesc)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    do {
        let response = try await PesaKit.getInstance().stkPushQuery(queryRequest: queryRequest)
        print("Result: \(response.ResultDesc)")
    } catch {
        print("Error: \(error)")
    }
}
```

### 3. Dynamic QR Code Generation

Generate a QR code for payments:

```swift
let qrRequest = DynamicQRRequest(
    merchantName: "My Store",
    refNo: "INV001",
    amount: 1000,
    trxCode: .BG,  // .BG for Buy Goods, .PB for Pay Bill, .WA for Withdraw Cash, .SM for Send Money
    cpi: "174379",
    size: "300"  // QR code size in pixels
)

// Completion Handler
PesaKit.getInstance().generateDynamicQR(qrRequest: qrRequest) { result in
    switch result {
    case .success(let response):
        print("QR Code: \(response.QRCode)")  // Base64 encoded image
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().generateDynamicQR(qrRequest: qrRequest)
    // Decode base64 QR code to display
    if let qrData = Data(base64Encoded: response.QRCode) {
        let qrImage = UIImage(data: qrData)
    }
}
```

### 4. C2B Register URL

Register validation and confirmation URLs for C2B payments:

```swift
let registerRequest = C2BRegisterURLRequest(
    shortCode: "600000",
    responseType: .Completed,  // or .Cancelled
    confirmationURL: "https://yourdomain.com/c2b/confirmation",
    validationURL: "https://yourdomain.com/c2b/validation"
)

// Completion Handler
PesaKit.getInstance().registerC2BURL(registerRequest: registerRequest) { result in
    switch result {
    case .success(let response):
        print("Registration: \(response.ResponseDescription)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().registerC2BURL(registerRequest: registerRequest)
    print(response.ResponseDescription)
}
```

### 5. B2C Payment (Business to Customer)

Send payments from your business to customers:

```swift
let b2cRequest = B2CRequest(
    originatorConversationID: "AG_12345_00000000",
    initiatorName: "testapi",
    securityCredential: "YOUR_SECURITY_CREDENTIAL",
    commandID: .BusinessPayment,  // or .SalaryPayment, .PromotionPayment
    amount: 1000,
    partyA: "600000",  // Your shortcode
    partyB: "254712345678",  // Customer phone
    remarks: "Salary payment",
    queueTimeOutURL: "https://yourdomain.com/timeout",
    resultURL: "https://yourdomain.com/result",
    occassion: "January Salary"
)

// Completion Handler
PesaKit.getInstance().b2cPayment(b2cRequest: b2cRequest) { result in
    switch result {
    case .success(let response):
        print("Conversation ID: \(response.ConversationID)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().b2cPayment(b2cRequest: b2cRequest)
    print("Payment initiated: \(response.ConversationID)")
}
```

### 6. Transaction Status

Check the status of any M-Pesa transaction:

```swift
let statusRequest = TransactionStatusRequest(
    initiator: "testapi",
    securityCredential: "YOUR_SECURITY_CREDENTIAL",
    transactionID: "QAH12345XYZ",
    originatorConversationID: "AG_12345_00000000",
    partyA: "600000",
    identifierType: "4",  // 4 for shortcode
    resultURL: "https://yourdomain.com/result",
    queueTimeOutURL: "https://yourdomain.com/timeout",
    remarks: "Status check",
    occasion: "Transaction inquiry"
)

// Completion Handler
PesaKit.getInstance().transactionStatus(statusRequest: statusRequest) { result in
    switch result {
    case .success(let response):
        print("Status: \(response.ResponseDescription)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().transactionStatus(statusRequest: statusRequest)
    print(response.ResponseDescription)
}
```

### 7. Account Balance

Query your M-Pesa account balance:

```swift
let balanceRequest = AccountBalanceRequest(
    initiator: "testapi",
    securityCredential: "YOUR_SECURITY_CREDENTIAL",
    partyA: "600000",  // Your shortcode
    identifierType: "4",  // 4 for shortcode
    remarks: "Balance inquiry",
    queueTimeOutURL: "https://yourdomain.com/timeout",
    resultURL: "https://yourdomain.com/result"
)

// Completion Handler
PesaKit.getInstance().accountBalance(balanceRequest: balanceRequest) { result in
    switch result {
    case .success(let response):
        print("Request accepted: \(response.ResponseDescription)")
        // Actual balance will be sent to your resultURL
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().accountBalance(balanceRequest: balanceRequest)
    print(response.ResponseDescription)
}
```

### 8. Transaction Reversal

Reverse an erroneous M-Pesa transaction:

```swift
let reversalRequest = ReversalRequest(
    initiator: "testapi",
    securityCredential: "YOUR_SECURITY_CREDENTIAL",
    transactionID: "QAH12345XYZ",
    amount: 1000,
    receiverParty: "600000",
    receiverIdentifierType: "11",  // 11 for shortcode
    resultURL: "https://yourdomain.com/result",
    queueTimeOutURL: "https://yourdomain.com/timeout",
    remarks: "Reversal due to error",
    occasion: "Correction"
)

// Completion Handler
PesaKit.getInstance().reverseTransaction(reversalRequest: reversalRequest) { result in
    switch result {
    case .success(let response):
        print("Reversal initiated: \(response.ResponseDescription)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().reverseTransaction(reversalRequest: reversalRequest)
    print(response.ResponseDescription)
}
```

### 9. B2B Payment (Business to Business)

Transfer funds between business accounts:

```swift
let b2bRequest = B2BRequest(
    initiator: "testapi",
    securityCredential: "YOUR_SECURITY_CREDENTIAL",
    commandID: .BusinessPayBill,  // or .BusinessBuyGoods
    amount: 10000,
    partyA: "600000",  // Sender shortcode
    partyB: "600001",  // Receiver shortcode
    accountReference: "Payment for services",
    requester: "254712345678",
    remarks: "B2B payment",
    queueTimeOutURL: "https://yourdomain.com/timeout",
    resultURL: "https://yourdomain.com/result",
    senderIdentifierType: "4",
    receiverIdentifierType: "4"
)

// Completion Handler
PesaKit.getInstance().b2bPayment(b2bRequest: b2bRequest) { result in
    switch result {
    case .success(let response):
        print("Payment initiated: \(response.ConversationID)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}

// Async/Await
Task {
    let response = try await PesaKit.getInstance().b2bPayment(b2bRequest: b2bRequest)
    print("B2B Payment: \(response.ResponseDescription)")
}
```

## Error Handling

PesaKit provides comprehensive error handling through the `PesaError` enum:

```swift
PesaKit.getInstance().lipaNaMpesa(paymentRequest: request) { result in
    switch result {
    case .success(let response):
        // Handle success
        break
    case .failure(let error):
        switch error {
        case .credentialsNotSet:
            print("Configure PesaKit with credentials first")
        case .invalidCredentials:
            print("Invalid consumer key or secret")
        case .invalidAccessToken:
            print("Authentication failed")
        case .networkError(let networkError):
            print("Network error: \(networkError.localizedDescription)")
        case .parsingError:
            print("Failed to parse response")
        case .encodingError(let message):
            print("Encoding error: \(message)")
        case .mpesaError(let mpesaError):
            print("M-Pesa error: \(mpesaError.errorMessage ?? "")")
        case .authenticationError(let authError):
            print("Auth error: \(authError.error_description ?? "")")
        default:
            print("Unknown error")
        }
    }
}
```

## Security

- **Keychain Storage**: OAuth tokens are securely stored in the device Keychain
- **Automatic Token Expiry**: Tokens are automatically invalidated when expired
- **HTTPS Only**: All API calls use secure HTTPS connections
- **No Credential Storage**: Consumer credentials are only used during configuration

## Testing

Use the sandbox environment for testing:

```swift
let config = PesaKitConfig(
    consumerKey: "YOUR_SANDBOX_KEY",
    consumerSecret: "YOUR_SANDBOX_SECRET",
    environment: .DEV  // Sandbox environment
)
PesaKit.configure(with: config)
```

**Test Credentials**: Available on the [Safaricom Developer Portal](https://developer.safaricom.co.ke)

## Important Notes

1. **Phone Number Format**: Always use format `254XXXXXXXXX` (without `+`)
2. **Amount**: Amounts are in KES (Kenya Shillings) as integers
3. **Callbacks**: Ensure your callback URLs are publicly accessible and use HTTPS
4. **Security Credential**: Generate using the Safaricom certificate tool
5. **Identifier Types**:
   - `1` - MSISDN
   - `2` - Till Number
   - `4` - Shortcode (PayBill)
   - `11` - Shortcode (used for reversals)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Safaricom Developer Portal](https://developer.safaricom.co.ke)
- All contributors who have helped improve PesaKit

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/gichukipaul/PesaKit).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.
