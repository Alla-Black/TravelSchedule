//
//  SwapButton.swift
//  TravelSchedule
//
//  Created by Алла on 12.02.2026.
//

import SwiftUI

struct SwapButton: View {
    var body: some View {
        Button(action: swapDirection) {
                Image(systemName: "arrow.2.squarepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.blueUniversal)
                    .background(
                        Circle()
                            .fill(.whiteUniversal)
                            .frame(width: 36, height: 36)
                    )
                    .frame(width: 36, height: 36)
                    .contentShape(Circle())
        }
    }
    
    private func swapDirection() {
        
    }
}

#Preview {
    SwapButton()
}
