//
//  Calculator.swift
//  MLB The Show Flips
//
//  Created by Gavin Ryder on 1/3/22.
//

import Foundation
import SwiftUI

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class Calculator {
//    private var criteria: Criteria
//
//    init(criteriaInst: Criteria) { //not hierarchical
//        self.criteria = criteriaInst
//    }
    
    func flipProfit(_ playerModel: PlayerDataModel) -> Int {
        let buyActual:Double = Double(playerModel.best_buy_price + 1)
        let sellActual:Double = Double(playerModel.best_sell_price - 1) * 0.9
        return Int(sellActual - buyActual)
    }
    
    
//    func sortedPlayerListings(listings: inout [PlayerDataModel]) -> [PlayerDataModel] { //returns the array of player items sorted by their flip values
//        
//        listings.sort { (lhs: PlayerDataModel, rhs: PlayerDataModel) -> Bool in
//            return flipProfit(lhs) < flipProfit(rhs)
//        }
//        
//        return listings.reversed()
//    }
    
    private func signFor(_ val: Int) -> String {
        if (val > 0) {
            return "+"
        } else if (val < 0) {
            return "-"
        } else {
            return ""
        }
    }
    
//    func meetsFlippingCriteria(_ player: inout PlayerListing) -> Bool {
//        let playerItem = player.item
//        if (player.best_buy_price > criteria.budget || criteria.excludedSeries.contains(playerItem.series)) {
//            return false
//        }
//
//        //assign a value for players with no buy orders and thus no buy price
//        if (player.best_buy_price == 0 && playerItem.ovr >= 85) {
//            player.best_buy_price = 5000
//        } else if (player.best_buy_price == 0 && playerItem.ovr < 85 && playerItem.ovr >= 80) {
//            player.best_buy_price = 1000
//        } else if (player.best_buy_price == 0 && playerItem.ovr < 80 && playerItem.ovr >= 75) {
//            player.best_buy_price = 1000
//        }
//
//        if (playerItem.ovr >= 85 && player.best_buy_price < 5000) { //check for cards listed under
//            return false
//        } else if (playerItem.ovr >= 80 && playerItem.ovr < 85 && player.best_buy_price < 1000) {
//            return false
//        }
//
//        return true
//    }
    
    func playerFlipDescription(_ playerModel: PlayerDataModel) -> (title: String, desc: String) {
        //let playerItem = playerModel.item
        let flipVal = flipProfit(playerModel)
        let nameAndFlipMargin = "\(playerModel.name): \(signFor(flipVal))\(flipVal) "
        let desc = "\(playerModel.ovr) OVR \(playerModel.shortPos), \(playerModel.team), \(playerModel.year): \(playerModel.series)"
        return (nameAndFlipMargin, desc)
    }
    
    func transactionsPerMinute(completedOrders: [CompletedOrder]) -> Double {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM/dd/yy hh:mm:ssa"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let mostRecent: CompletedOrder? = completedOrders.first
        let last: CompletedOrder?  = completedOrders.last
        
        let firstDate: Date = dateFormatter.date(from: mostRecent!.date) ?? Date()
        let lastDate: Date = dateFormatter.date(from: last!.date) ?? Date()

        let diffInMinutes = ((firstDate.timeIntervalSinceReferenceDate - lastDate.timeIntervalSinceReferenceDate) / 60).rounded()
        return (Double(completedOrders.count) / diffInMinutes).round(to: 2)
    }
    
    func getPriceHistoriesForGraph(priceHistory: [HistoricalPriceValue]) -> (bestBuy: [Double], bestSell: [Double]) {
        let bestBuy:[Double] = priceHistory.map {price in Double(price.best_buy_price)}
        let bestSell: [Double] = priceHistory.map {price in Double(price.best_sell_price)}
        return (bestBuy, bestSell)
    }
    
    func getRates(priceHistory: [HistoricalPriceValue]) -> (buyRate: Int, sellRate: Int) { //TODO: Calc rate of change of prices ((new - old) / old) * 100
        let newestBuyPrice = priceHistory.first?.best_buy_price ?? 0
        let newestSellPrice = priceHistory.first?.best_sell_price ?? 0
        
        let oldestBuyPrice = priceHistory.last?.best_buy_price ?? 0
        let oldestSellPrice = priceHistory.last?.best_sell_price ?? 0
        
        let buyDiff = newestBuyPrice - oldestBuyPrice
        let sellDiff = newestSellPrice - oldestSellPrice
        
        let buyPct = Int((Double(buyDiff) / Double(max(oldestBuyPrice, 1)))*100) //avoid dividing by 0 using max
        let sellPct = Int((Double(sellDiff) / Double(max(oldestSellPrice, 1)))*100)
        
        return (buyPct, sellPct)
    }
    
}
