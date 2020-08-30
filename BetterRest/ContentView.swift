//
//  ContentView.swift
//  BetterRest
//
//  Created by RANGA REDDY NUKALA on 28/08/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading,spacing: 30) {
                HStack {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    Spacer()
                    DatePicker("Set Wake up", selection: $wakeUp,displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 20, alignment: .center)
                }
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.50){
                        Text("\(sleepAmount, specifier: "%g") hrs")
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $coffeeAmount, in: 1...20){
                        if coffeeAmount == 1 {
                            Text("1 Cup")
                        } else {
                            Text("\(coffeeAmount) Cups")
                        }
                    }
                }
                
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        calculateBedtime()
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 250, height: 44, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
                            .overlay(Text("Calculate")
                                        .foregroundColor(.white)
                                        .font(.system(size: 22, weight: .semibold)))
                    
                })
                    Spacer()
                }.padding(.top,30)
                
                
                Spacer()
                
            }.navigationBarTitle("BetterRest 😴")
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            })
            .padding()
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
    
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0 ) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertTitle = "Your ideal bedtime"
            alertMessage = formatter.string(from: sleepTime)
            
            
        } catch {
            alertTitle = ""
            alertMessage = "Sorry, there was a problem calculatin your bedtime"
            
        }
        
        showingAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
