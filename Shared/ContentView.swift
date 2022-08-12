//
//  ContentView.swift
//  Shared
//
//  Created by Owais Shaikh on 12/08/22.
//

import SwiftUI

struct spirograph: Shape{
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    func gcd(_ a: Int, _ b: Int) -> Int{
        var a = a
        var b = b
        
        while b != 0{
            let temp = b
            b = a % b
            a = temp
        }
        return a
    }
        
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        
        let diff = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius/Double(divisor)) * amount
     
        //Thanks to WikiPedia and @twostraws for the MATH.
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = diff * cos(theta) + distance * cos(diff / outerRadius * theta)
            var y = diff * sin(theta) - distance * sin(diff / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
        
    }
    
}


struct ContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    let BGcolor : Color = Color(red: 255/255, green: 246/255, blue: 234/255)
    
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            
            spirograph(innerRadius:  Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Group {
                    Text("Inner radius: \(Int(innerRadius))")
                    Slider(value: $innerRadius, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])

                    Text("Outer radius: \(Int(outerRadius))")
                    Slider(value: $outerRadius, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])

                    Text("Distance: \(Int(distance))")
                    Slider(value: $distance, in: 1...150, step: 1)
                         .padding([.horizontal, .bottom])

                    Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                    Slider(value: $amount)
                        .padding([.horizontal, .bottom])

                    Text("Color")
                    Slider(value: $hue)
                        .padding(.horizontal)
             }
        }
        .background(BGcolor)
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
