//
//  SwiftUIView.swift
//  MySkyView
//
//  Created by Kathiresan on 01/12/24.
//

import SwiftUI

@available(iOS 13.0, *)
public struct SkyView: View {
   private var mode: ColorScheme
    
    public init(mode: ColorScheme) {
        self.mode = mode
    }
        
    public var body: some View {
        if mode == .dark {
            NightSkyBaseView(vm: .init())
        } else {
            EmptyView()
        }
    }
}

//@MainActor
@available(iOS 13.0, *)
final public class NightSkyBaseViewModel: ObservableObject {
    
    private let defaultSlide: String = "SLIDE-0"
    
    @Published var currentSlide: String = "SLIDE-0"
    @Published var angle: Angle = .zero
    
    @Published var rotateTimer = Timer.publish(every: 0.2, on: .main, in: RunLoop.Mode.common).autoconnect()
    
    @Published var starTimer = Timer.publish(every: 1, on: .main, in: RunLoop.Mode.common).autoconnect()

    private var starNames: [String] = ["SLIDE-0",
                                       "SLIDE-1",
                                       "SLIDE-2",
                                       "SLIDE-3",
                                       "SLIDE-4",
                                       "SLIDE-5",
                                       "SLIDE-6",
                                       "SLIDE-7"]
    
    private var currentIndex: Int = 0
    
    func changeSlide() {
        if currentIndex >= 8 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        
        if starNames.indices.contains(currentIndex) {
            currentSlide = starNames[currentIndex]
        } else {
            currentSlide = defaultSlide
        }
//        print(currentSlide)
        
//       let resetStar = DispatchWorkItem(block: {
//           self.currentSlide = self.defaultSlide
//        })
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: resetStar)
    }
    
}

@available(iOS 13.0, *)
public struct NightSkyBaseView: View {
    @ObservedObject var vm: NightSkyBaseViewModel
    
    public var body: some View {
        Image(ImageResource(name: vm.currentSlide, bundle: .module))
            .resizable()
            .aspectRatio(contentMode: .fit) // Preserve aspect ratio
            .rotationEffect(-vm.angle)
            .frame(width: 1400, height: 1400) // Set desired frame size
        //            .background(content: {
        //                Color.black
        //            })
            .onReceive(vm.rotateTimer) { refresh in
                withAnimation {
                    self.vm.angle.degrees += 0.1
                }
            }
            .onReceive(vm.starTimer) { refresh in
                withAnimation(.linear, {
                    self.vm.changeSlide()
                })
            }
        
    }
}

@available(iOS 13.0, *)
#Preview {
    SkyView(mode: .light)
}
