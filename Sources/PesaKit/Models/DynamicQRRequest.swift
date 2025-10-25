//  DynamicQRRequest.swift
//  PesaKit
//  Dynamic QR Request Model

import Foundation

public struct DynamicQRRequest: Codable {
    public let MerchantName: String
    public let RefNo: String
    public let Amount: Int
    public let TrxCode: QRTransactionCode
    public let CPI: String
    public let Size: String
    
    public init(merchantName: String, refNo: String, amount: Int, trxCode: QRTransactionCode, cpi: String, size: String = "300") {
        self.MerchantName = merchantName
        self.RefNo = refNo
        self.Amount = amount
        self.TrxCode = trxCode
        self.CPI = cpi
        self.Size = size
    }
}

public enum QRTransactionCode: String, Codable {
    case BG // Buy Goods
    case WA // Withdraw Cash at Agent
    case PB // PayBill
    case SM // Send Money
    case SB // Send to Business
}
