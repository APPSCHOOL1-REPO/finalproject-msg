//
//  ChallengeRecordViewModel.swift
//  MSG
//
//  Created by zooey on 2023/02/13.
//

import Foundation

// MARK: - ChallengeRecord ViewModel Input
protocol ChallengeRecordViewInput {
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg?
    func getChallengeHistory() async throws
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData?
    func getChallengeUser(users: [String], challengeId: String) async
    func getChallengeTotalMoney(challengeId: String) async throws
    func getHistoryExpenditure(gameId: String) async -> Expenditure?
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}

// MARK: - ChallengeRecord ViewModel Output
protocol ChallengeRecordViewOutput {
    var challengeHistoryArray : [Challenge] { get }
    var challengeUsers: ChallengeUserData { get }
    var challengeHistoryUserList : [(userId: String, totalMoney: Int)] { get }
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
}

final class ChallengeRecordViewModel: ObservableObject, ChallengeRecordViewInput, ChallengeRecordViewOutput {
  
    var challengeRecordUseCase = ChallengeRecordUseCase(challengeRepository: ChallengeRecordRepositoryImpl(dataSource: FirebaseService()))
    typealias ChallengeUserData = [(user:(userName: String, userProfile: String), totalMoney: Int)]
    @Published var challengeHistoryArray : [Challenge] = []
    @Published var challengeUsers: ChallengeUserData = []
    @Published var challengeHistoryUserList : [(userId: String, totalMoney: Int)] = []
    @Published var tagValue: [(tag: String, money: Int)] = []
    @Published var userValue: [(user:(userName: String, userProfile: String), totalMoney: Int)] = []
    @Published var historyExpenditure: Expenditure?
    
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg? {
        let data = try await challengeRecordUseCase.challengeRecordfetchUserInfo(userId)
        return data
    }
    
    // MARK: - ?????? ?????????????????? ?????? ???????????? ??????
    @MainActor
    func getChallengeHistory() async throws {
        print(#function)
        do {
          challengeHistoryArray  = try await challengeRecordUseCase.getChallengeHistory()
        } catch {
            print("Error: Failed to get challenge history.")
        }
    }
    
    // MARK: - ????????? ????????? (?????? ??????, ??????) ????????????
    func getUserData(user: [String], challengeId: String) async -> ChallengeUserData? {
        print(#function)
        let data = await challengeRecordUseCase.getUserData(user: user, challengeId: challengeId)
        return data
    }
    
    // MARK: - ????????? ????????? (?????? ??????, ??????) ????????????
    @MainActor
    func getChallengeUser(users: [String], challengeId: String) async {
        print(#function)
        challengeUsers = await challengeRecordUseCase.getChallengeUser(users: users, challengeId: challengeId)
    }
    
    // MARK: - ????????? ????????? ????????? ?????? ???????????? ???, ??? ????????? ?????? ?????? ???????????? ??????
    func getChallengeTotalMoney(challengeId: String) async throws {
        print(#function)
        do {
            try await challengeRecordUseCase.getChallengeTotalMoney(challengeId: challengeId)
        } catch {
            print("Error: Failed to get user total amount.")
        }
    }
    
    // MARK: - ?????? ????????? ?????? ?????? ?????? ?????? ?????? ????????????
    func getHistoryExpenditure(gameId: String) async -> Expenditure? {
        print(#function)
        let data = await challengeRecordUseCase.getHistoryExpenditure(gameId: gameId)
        return data
    }
    
    // MARK: - ?????? ????????? ?????? ?????? ??????
    func parsingExpenditure(_ expenditureHistory: [String:[String]]) -> [(tag: String, money: Int)]{
        
        var maxValue: (tag:String, money: Int) = ("",Int.min)
        var minValue: (tag:String, money: Int) = ("",Int.max)
        var maxSum = Int.min
        var minSum = Int.max
        
        for (tag, expenditure) in expenditureHistory{
            var sum:Int = 0
            for string in expenditure {
                let stringArr = string.components(separatedBy: "_")
                let money = stringArr[1]
                sum += Int(money)!
            }
            if maxSum < sum {
                maxValue = (tag: tag, money: sum)
                maxSum = sum
            }
            if minSum > sum {
                minValue = (tag: tag, money: sum)
                minSum = sum
            }
        }
        return [maxValue, minValue]
    }
    
    // MARK: - ?????? ????????? ?????? ?????? ?????? ??????
    func userValues(_ challengeUsers: [(user:(userName: String, userProfile: String), totalMoney: Int)]) -> [(user:(userName: String, userProfile: String), totalMoney: Int)] {
        
        var maxValue: (user:(userName: String, userProfile: String), totalMoney: Int) = (("",""), Int.min)
        var minValue: (user:(userName: String, userProfile: String), totalMoney: Int) = (("",""), Int.max)
        var maxSum = Int.min
        var minSum = Int.max
        
        for (user, totalMoney) in challengeUsers {
            var sum:Int = 0
            let money = totalMoney
            sum += money
            
            if maxSum < sum {
                maxValue = (user:(userName: user.userName, userProfile: user.userProfile), totalMoney: sum)
                maxSum = sum
            }
            if minSum > sum {
                minValue = (user:(userName: user.userName, userProfile: user.userProfile), totalMoney: sum)
                minSum = sum
            }
        }
        return [maxValue, minValue]
    }
}
