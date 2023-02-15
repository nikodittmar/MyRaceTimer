//
//  NumberPad.swift
//  Race Timer
//
//  Created by niko dittmar on 2/13/23.
//

import SwiftUI

struct NumberPad: View {
    @ObservedObject var viewModel: ContentViewViewModel
    
    var body: some View {
        VStack(spacing: -1) {
            HStack(spacing: -1) {
                Button { viewModel.appendDigit(1) } label: { Text("1").NumPadButtonStyle() }
                Button { viewModel.appendDigit(2) } label: { Text("2").NumPadButtonStyle() }
                Button { viewModel.appendDigit(3) } label: { Text("3").NumPadButtonStyle() }
            }
            HStack(spacing: -1) {
                Button { viewModel.appendDigit(4) } label: { Text("4").NumPadButtonStyle() }
                Button { viewModel.appendDigit(5) } label: { Text("5").NumPadButtonStyle() }
                Button { viewModel.appendDigit(6) } label: { Text("6").NumPadButtonStyle() }
            }
            HStack(spacing: -1) {
                Button { viewModel.appendDigit(7) } label: { Text("7").NumPadButtonStyle() }
                Button { viewModel.appendDigit(8) } label: { Text("8").NumPadButtonStyle() }
                Button { viewModel.appendDigit(9) } label: { Text("9").NumPadButtonStyle() }
            }
            HStack(spacing: -1) {
                Button { viewModel.presentDeleteWarning() } label: { Image(systemName: "trash").NumPadButtonStyle(destructive: true) }
                Button { viewModel.appendDigit(0) } label: { Text("0").NumPadButtonStyle() }
                Button { viewModel.backspace() } label: { Image(systemName: "delete.left").NumPadButtonStyle(destructive: false) }
            }
            .alert("Are you sure you want to delete the selected recording?",
                isPresented: $viewModel.presentingDeleteWarning,
                actions: {
                    Button("No", role: .cancel, action: {})
                    Button("Yes", role: .destructive, action: {
                        viewModel.deleteResult()
                    })
                },
                message: { Text("This cannot be undone.") })
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
