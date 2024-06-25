//
//  BottomSheetView.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import SwiftUI

struct BottomSheetViewModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                VStack {
                    Spacer()
                    VStack {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(Color.gray.opacity(0.8))
                            .padding(.top, 8)
                        sheetContent()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut)
            }
        }
    }
}

extension View {
    func bottomSheet<SheetContent: View>(isPresented: Binding<Bool>, @ViewBuilder sheetContent: @escaping () -> SheetContent) -> some View {
        self.modifier(BottomSheetViewModifier(isPresented: isPresented, sheetContent: sheetContent))
    }
}
