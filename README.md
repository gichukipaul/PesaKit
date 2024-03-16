# P e s a K i t
Pesakit is a lightweight and efficient Swift library for integrating M-Pesa mobile money services into your iOS applications. Built with simplicity and flexibility in mind, Pesakit simplifies payment initiation, transaction tracking, and error handling, allowing you to seamlessly integrate M-Pesa functionality into your apps with ease.
## Technologies Used
- Swift
- CompletionHandlers
- MVVM (Model-View-ViewModel) architecture
- SOLID & DRY principles

## Features
- Secure Authentication: Pesakit provides secure authentication using Basic Authentication with API key and secret, ensuring that sensitive information is protected.
- Payment Initiation: Initiate payment transactions effortlessly with just a few lines of code, enabling users to make payments for goods and services through the M-Pesa platform.
- Robust Error Handling: Pesakit includes a robust error handling mechanism that provides clear feedback on failed requests, helping developers troubleshoot and handle errors gracefully in their applications.
- Comprehensive Documentation: The library comes with comprehensive documentation, including a quick start guide, API reference, and code examples, to facilitate easy integration into iOS applications.

## Upcoming Features
We are continuously working on enhancing PesaKit. Stay tuned for upcoming features, including:
- Async/Await (for efficient multithreading)
- Customer To Business Register URL(C2B) - Register URL API works hand in hand with Customer to Business (C2B) APIs and allows receiving payment notifications to your paybill. This API enables you to register the callback URLs via which you shall receive notifications for payments to your pay bill/till number. 
- Business To Customer (B2C) - B2C API is an API used to make payments from a Business to Customers
- Transaction Status - Check the status of a transaction.
- Account Balance - The Account Balance API is used to request the account balance of a short code. This can be used for both B2C, buy goods and pay bill accounts.
-  Reversals - Reverses a C2B M-Pesa transaction. Once a customer pays and there is a need to reverse the transaction, the organization will use this API to reverse the amount.

## Getting Started with Pesakit
To start using Pesakit, follow these steps:
- **Installation**: 
   - In Xcode, navigate to `File` -> `Swift Packages` -> `Add Package Dependency...`.
   - Enter the URL of the Pesakit repository: `https://github.com/gichukipaul/PesaKit`.
   - Choose the version or branch you want to use.
   - Click `Next` and follow the prompts to complete the installation.
- **Configuration and Authentication**: 
   - Obtain your API key and secret from the M-Pesa developer portal.
   - Configure authentication by providing your credentials:
     ```swift
     import PesaKit

     let config = PesaKitConfig(consumerKey: "yourConsumerKey", consumerSecret: "yourConsumerSecret")
     PesaKit.configure(with: config)
     ```

- **Usage**: 
   - Payment Initiation: Use Pesakit's functions to initiate payment transactions in your iOS application. 
   - Once configured, you can start using the APIs provided by the library:
     ```swift
     import PesaKit

     // Example of using lipaNaMpesa method
     let paymentRequest = LipaNaMpesaPaymentRequest(/* provide necessary parameters */)
     PesaKit.getInstance().lipaNaMpesa(paymentRequest: paymentRequest) { result in
         switch result {
         case .success(let response):
             // Handle success
             print("Payment successful: \(response)")
         case .failure(let error):
             // Handle failure
             print("Payment failed: \(error)")
         }
     }
     ```
- Error Handling: Implement error handling logic to gracefully handle failed requests and unexpected responses.
- Documentation: Refer to the documentation for detailed usage instructions, code examples, and API reference.

## Contributions
I welcome contributions from the community to help improve Pesakit. If you find any bugs, have feature requests, or want to contribute enhancements, please submit a pull request or open an issue on GitHub.

## Acknowledgments
I would like to express my gratitude to the [Safaricom](https://developer.safaricom.co.ke), and all contributors who have played a role in making PesaKit possible.
## License
This project is licensed under the [MIT License](LICENSE).
