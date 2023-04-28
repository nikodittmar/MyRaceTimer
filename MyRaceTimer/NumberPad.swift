//
//  NumberPad.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 2/13/23.
//

import SwiftUI

struct NumberPad: View {    
    var onInputDigit: (Int) -> Void
    var onBackspace: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: -1) {
            HStack(spacing: -1) {
                Button { self.onInputDigit(1) } label: { Text("1").NumPadButtonStyle() }
                Button { self.onInputDigit(2) } label: { Text("2").NumPadButtonStyle() }
                Button { self.onInputDigit(3) } label: { Text("3").NumPadButtonStyle() }
            }
            HStack(spacing: -1) {
                Button { self.onInputDigit(4) } label: { Text("4").NumPadButtonStyle() }
                Button { self.onInputDigit(5) } label: { Text("5").NumPadButtonStyle() }
                Button { self.onInputDigit(6) } label: { Text("6").NumPadButtonStyle() }
            }
            HStack(spacing: -1) {
                Button { self.onInputDigit(7) } label: { Text("7").NumPadButtonStyle() }
                Button { self.onInputDigit(8) } label: { Text("8").NumPadButtonStyle() }
                Button { self.onInputDigit(9) } label: { Text("9").NumPadButtonStyle() }
            }
            HStack(spacing: -1) {
                Button { self.onDelete() } label: { Image(systemName: "trash").NumPadButtonStyle(destructive: true) }
                Button { self.onInputDigit(0) } label: { Text("0").NumPadButtonStyle() }
                Button { self.onBackspace() } label: { Image(systemName: "delete.left").NumPadButtonStyle(destructive: false) }
            }
        }
    }
}

struct NumberPadButton: ViewModifier {
    
    var destructive: Bool = false
    
    func body(content: Content) -> some View {
        if destructive {
            content
                .font(.title)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
        } else {
            content
                .font(.title)
                .foregroundColor(Color(UIColor.label))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
        }
    }
}

extension Text {
    func NumPadButtonStyle() -> some View {
        modifier(NumberPadButton(destructive: false))
    }
}

extension Image {
    func NumPadButtonStyle(destructive: Bool) -> some View {
        modifier(NumberPadButton(destructive: destructive))
    }
}
