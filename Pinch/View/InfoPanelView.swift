//
//  InfoPanelView.swift
//  Pinch
//
//  Created by sidiqtoha on 28/07/24.
//

import SwiftUI

struct InfoPanelView: View {
        
    var scale: CGFloat
    var offset: CGSize
    
    @State private var isInfoPanelVisible: Bool = false
    
    var body: some View {
       HStack{
            //MARK: HOTSPOT
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 1, perform: {
                    withAnimation(.easeOut, {
                        isInfoPanelVisible.toggle()
                    })
                })
            
            Spacer()
            
            //MARK: INFO PANEL
            
            HStack(spacing: 2,content: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                
                Spacer()
            })
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1: 0)
            
            Spacer()
            
        }
    }
}

#Preview {
    ZStack {
//        Color(.yellow)
//            .frame(height: 50)
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }

}
