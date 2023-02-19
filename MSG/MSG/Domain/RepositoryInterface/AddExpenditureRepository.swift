//
//  AddExpenditureRepository.swift
//  MSG
//
//  Created by 김민호 on 2023/02/20.
//

import Foundation

protocol AddExpenditureRepository {
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async
}
