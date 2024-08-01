//
//  ContentView.swift
//  Pinch
//
//  Created by sidiqtoha on 28/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pageData
    @State private var pageIndex: Int = 1
    
    func resetFungtion(){
        return withAnimation(.spring(), {
            imageScale = 1
            imageOffset = .zero
        })
    }
    
    func currentPage() -> String{
        return pages[pageIndex - 1].imageName
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color.clear
                    
                    Image(currentPage())
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                        .shadow(
                            color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                        .opacity(isAnimating ? 1 : 0)
                        .scaleEffect(imageScale)
                        .offset(x: imageOffset.width, y: imageOffset.height)
                    
                        //DOUBLE TAP GESTURE
                        .onTapGesture(count: 2, perform: {
                            if imageScale == 1 {
                                withAnimation(.spring(), {
                                    imageScale = 5
                                })
                            } else {
                               resetFungtion()
                            }
                        })
                    
                        //DRAG GESTURE
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    withAnimation(.linear(duration: 1), {
                                        imageOffset = value.translation
                                    })
                                }
                                .onEnded{ _ in
                                    if imageScale <= 1 {
                                        resetFungtion()
                                    }
                                }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation(.linear(duration: 1), {
                                        if imageScale >= 1 && imageScale <= 5{
                                            imageScale = value
                                        }else if imageScale > 5{
                                            imageScale = 5
                                        }
                                    })
                                }
                                .onEnded{ _ in
                                    if imageScale > 5{
                                        imageScale = 5
                                    }else if imageScale < 1{
                                        resetFungtion()
                                    }
                                }
                        )
                }
                .navigationTitle("Pinch & Zoom")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(
                    perform: {
                        withAnimation(.linear(duration: 1), {
                            isAnimating = true
                        })
                    })
                .overlay(alignment: .top, content: {
                    InfoPanelView(scale: imageScale, offset: imageOffset)
                        .padding(.horizontal)
                        .padding(.top, 30)
                })
                .overlay(alignment: .bottom, content: {
                    Group{
                        HStack{
                            
                            //SCALE DOWN
                            Button(action: {
                                withAnimation(.spring(), {
                                    if imageScale > 1{
                                        imageScale -= 1
                                        
                                        if imageScale <= 1 {
                                            resetFungtion()
                                        }
                                    }
                                })
                            }, label: {
                                ControlImageView(icon: "minus.magnifyingglass")
                            })
                            
                            //RESET
                            Button(action: {
                               resetFungtion()
                            }, label: {
                                ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                            })
                            
                            //SCALE UP
                            Button(action: {
                                withAnimation(.spring(), {
                                    if imageScale < 5 {
                                        imageScale += 1
                                        
                                        if imageScale > 5 {
                                            imageScale = 5
                                        }
                                    }
                                })
                            }, label: {
                                ControlImageView(icon: "plus.magnifyingglass")
                            })
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 12))
                        .opacity(isAnimating ? 1 : 0)
                    }
                    .padding(.bottom, 30)
                })
                
                //MARK: DRAWER
                .overlay(
                    HStack(spacing: 12, content: {
                        Image(systemName: isDrawerOpen ? "chevron.compact.right": "chevron.compact.left")
                            .resizable()
                            .padding(8)
                            .scaledToFit()
                            .frame(height: 40)
                            .foregroundStyle(.secondary)
                            .onTapGesture(perform: {
                                withAnimation(.easeOut, {
                                    isDrawerOpen.toggle()
                                })
                            })
                        
                        ForEach(pages){ item in
                            Image(item.tumbnailName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .clipShape(.rect(cornerRadius: 8))
                                .shadow(radius: 4)
                                .opacity(isDrawerOpen ? 1 : 0)
                                .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                                .onTapGesture {
                                    isAnimating = true
                                    pageIndex = item.id
                                }
                        }
                        
                        Spacer()
                    })
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12))
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, geometry.size.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                    , alignment: .topTrailing
                )
            }
        }
        
    }
}

#Preview {
    ContentView()
}
