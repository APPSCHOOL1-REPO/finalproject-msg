//
//  ChartCellView.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ChartCellView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @Binding var selection: String
    var expenditure = Expenditure(id: "", totalMoney: 0, expenditureHistory: [:])
    // 숫자 세자리씩 끊는 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    var body: some View {
        ForEach(Array((expenditure.expenditureHistory.keys.enumerated())), id: \.element) { index, key in
            ForEach((expenditure.expenditureHistory[key])!, id: \.self) { value in
                let consume = value.components(separatedBy: "_")
                let date = consume[2].components(separatedBy: " ")
                let time = date[1].components(separatedBy: ":")
                if selection == key {
                    HStack{
                        Image(systemName: "dpad.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(15)
                            .foregroundColor(Color("Color2"))
                            .background(
                                Circle()
                                    .fill(
                                        .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                        .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                    )
                                    .foregroundColor(Color("Color1")))
                        
                        VStack(spacing: 5){
                            HStack {
                                Text("\(date[0])")
                                Spacer()
                            }
                            
                            HStack{
                                Text("\(consume[0])")
                                    .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.callout, color: .color2))
                                Spacer()
//                                Text("- \(consume[1])")
                                Text("- \(numberFormatter(number: Int(consume[1])!))원")
                            }
                            
                            HStack{
                                Text("소비태그: \(key)")
                                Spacer()
                                Text("\(time[0]):\(time[1])")
                            }
                        }
                        .padding()
                        .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.callout, color: .color2))
                    }
                    .padding(.leading, 15)
                    .padding(.trailing, 5)
                }
                else if selection.isEmpty || selection == "전체"{
                    HStack{
                        
                        Image(systemName: "dpad.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(15)
                            .foregroundColor(Color("Color2"))
                            .background(
                                Circle()
                                    .fill(
                                        .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                        .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                    )
                                    .foregroundColor(Color("Color1")))
                        
                        VStack(spacing: 5){
                            HStack {
                                Text("\(date[0])")
                                Spacer()
                            }
                            HStack{
                                Text("\(consume[0])")
                                    .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.callout, color: .color2))
                                Spacer()
//                                Text("- \(consume[1])")
                                Text("- \(numberFormatter(number: Int(consume[1])!))원")
                            }
                            
                            HStack{
                                Text("소비태그: \(key)")
                                Spacer()
                                Text("\(time[0])시 \(time[1])분 작성")
                            }
                        }
                        .padding()
                        .modifier(TextModifier(fontWeight: .normal, fontType: FontCustomType.callout, color: .color2))
                    }
                    .padding(.leading, 15)
                    .padding(.trailing, 5)
                }
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
        }
    }
}

struct ChartCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChartCellView(selection: .constant(""))
    }
}
