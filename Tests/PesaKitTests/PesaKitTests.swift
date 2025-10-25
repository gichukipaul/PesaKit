import XCTest
@testable import PesaKit

final class PesaKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset configuration before each test
        PesaKit.resetConfiguration()
    }

    override func tearDown() {
        // Clean up after each test
        PesaKit.resetConfiguration()
        super.tearDown()
    }

    func test_PesaKitInstanceNotNil_afterConfiguration() throws {
        let config = PesaKitConfig(consumerKey: "test", consumerSecret: "test")
        PesaKit.configure(with: config)

        let instance = PesaKit.getInstance()
        XCTAssertNotNil(instance)
    }

        //    TEST LipaNaMpesa
    func test_successfull_LipaNaMpesa() throws {
        let py = LipaNaMpesaPaymentRequest(
            businessShortCode: 174379,
            lipaNaMpesaPassKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
            timestamp: 20240317011780,
            transactionType: TransactionType.PayBill,
            amount: 1,
            partyA: 254792553747,
            partyB: 174379,
            phoneNumber: 254792553747,
            callBackURL: "https://safaricom.com",
            accountReference: "Test",
            transactionDesc: "Test")

        let config = PesaKitConfig(consumerKey: "test", consumerSecret: "test")
        PesaKit.configure(with: config)

        PesaKit.getInstance().lipaNaMpesa(paymentRequest: py) { result in
            switch result {
                case .success(let response):
                    XCTAssertNotNil(response)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }

    }
}
