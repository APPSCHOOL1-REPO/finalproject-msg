//
//  ProgressBar2.swift
//  MSG
//
//  Created by kimminho on 2023/02/03.
//

import SwiftUI

struct ProgressBar2: View {
//    @State var percent: CGFloat = 51
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @ObservedObject var challengeViewModel: ChallengeViewModel
    @Binding var percentage: Int
    let limitMoney: Int
    var color1 = Color(#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))
    var color2 = Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
    var body: some View {
        
        GeometryReader { geometry in
            let multiplier = geometry.size.width / 100
            VStack {
//                Text("\(String(format:"%.1f",Double(percentage) / Double(limitMoney) * 100))%")
                ZStack(alignment: .leading) {
                    //                    LottieView(filename: "run")
                    //                        .frame(width:50,height:50)
                    //                        .padding(.bottom,10)
                    
                    Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(Color(UIColor.systemTeal))
                        .cornerRadius(45.0)
                    
                    
                    //MARK: %가 100이 넘으면 뚫고 나가지 않게 방지
                    /// 퍼센트 게이지
                    if (Double(percentage) / Double(limitMoney)) >= 1.00 {
                        Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(0.3)
//                            .foregroundColor(Color(UIColor.systemBlue))
                            .background(LinearGradient(gradient: Gradient(colors: [color1,color2]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(45.0)
                    }else {
                        Rectangle().frame(width: multiplier * CGFloat(Double(percentage) / Double(limitMoney) * 100), height: geometry.size.height)
                            .opacity(0.3)
//                            .foregroundColor(Color(UIColor.systemBlue))
                            .background(LinearGradient(gradient: Gradient(colors: [color1,color2]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(45.0)
                    }
                    
                    //MARK: %가 13.0보다 작으면 자동차가 안보여서 시작지점으로
                    /// 자동차
                    if (Double(percentage) / Double(limitMoney)) > 1.00 {
                        LottieView(filename: "ambulance")
                            .frame(width: 50,height:100)
                            .padding(.leading, (multiplier * 100) - 50.0)
                        LottieView(filename: "flyingMoney")
                            .frame(width: 50,height:100)
                            .padding(.leading, (multiplier * 100) - 50.0)
                    }
                    
                    else if (Double(percentage) / Double(limitMoney)) < 0.13 {
                        LottieView(filename: "ambulance")
                            .frame(width: 50,height:100)
                            .padding(.leading, (multiplier * 13) - 50.0)
                        LottieView(filename: "flyingMoney")
                            .frame(width: 50,height:100)
                            .padding(.leading, (multiplier * 13) - 50.0)
                    }
                    else {
                        LottieView(filename: "ambulance")
                            .frame(width: 50,height:100)
                            .padding(.leading, ( multiplier * CGFloat(Double(percentage) / Double(limitMoney))*100)-50)
                        LottieView(filename: "flyingMoney")
                            .frame(width: 50,height:100)
                            .padding(.leading, ( multiplier * CGFloat(Double(percentage) / Double(limitMoney))*100)-50)
                        
                    }
                }
            }
            
        }
        .onAppear {
            Task {
                await challengeViewModel.fetchExpenditure()
//                await progressViewModel.fet
                print("나눔결과:",percentage / limitMoney)
                print("percentage:",percentage)
                print("totalMoney:",challengeViewModel.totalMoney)
                print("limitMoney:",limitMoney)
                //                print("나눔결과")
                //                self.totalMoney = fireStoreViewModel.totalMoney
                //                                print("percengate:\(self.totalMoney), limitMoney:\(self.limitMoney)")
            }
        }
    }
}

//struct ProgressBar2_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBar2(value: .constant(10))
////        ChallengeProgressView()
//    }
//}
