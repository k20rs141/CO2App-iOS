//
//  BLEConnectingView.swift
//

import SwiftUI

enum ConnectionStatus {
    case idle
    case loading
    case failure
    case success
}

struct BLEConnectingView: View {
    @State private var shouldAnimate: Bool = false
    @State private var connectionStatus: ConnectionStatus = .idle
    @State private var isRead: Bool = false
    @State private var ssid: String = ""
    @State private var password: String = ""
    @State private var deviceName: String = ""

    var screenSize: CGSize

    var body: some View {
        VStack {
            switch connectionStatus {
            case .idle, .loading, .failure:
                ConnectingView(screenSize: screenSize)
                    .onChange(of: connectionStatus) {
                        if connectionStatus == .failure {
                            HapticsManager.shared.feedback(type: .error)
                        }
                    }
            case .success:
                ConnectedView(screenSize: screenSize)
                    .onAppear {
                        HapticsManager.shared.feedback(type: .success)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [Color("blue"), Color("blue 1"), Color("blue 2"), Color("blue 3")], startPoint: .topLeading, endPoint: .bottomTrailing)
            
        )
        .ignoresSafeArea()
        .onAppear {
            self.shouldAnimate = true
            connectionTest()
        }
    }

    @ViewBuilder
    private func ConnectingView(screenSize: CGSize) -> some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 128, height: 128)
                .overlay(
                    ZStack {
                        Circle()
                            .fill(.ultraThickMaterial)
                            .scaleEffect(shouldAnimate ? 1.5 : 0)
                            .opacity(shouldAnimate ? 0.0 : 0.4)
                        Circle()
                            .fill(.ultraThickMaterial)
                            .scaleEffect(shouldAnimate ? 2 : 0)
                            .opacity(shouldAnimate ? 0.0 : 0.9)
                        Circle()
                            .fill(.ultraThickMaterial)
                            .scaleEffect(shouldAnimate ? 3 : 0)
                            .opacity(shouldAnimate ? 0.0 : 0.7)
                        
                    }
                        .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: false), value: shouldAnimate)
                )
            Image(systemName: "link")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(Color("blue 2"))
            
        }
        VStack {
            if connectionStatus == .idle || connectionStatus == .loading {
                HStack {
                    LoadingAnimation(color: .white)
                    Text("検索中...")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Text("しばらくお待ち下さい")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            if connectionStatus == .failure {
                Label("接続できませんでした!", systemImage: "exclamationmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(.red)
                    .font(.callout)
                Button {
                    connectionStatus = .success
                } label: {
                    Text("再接続")
                        .frame(width: screenSize.width * 0.4, height: 52)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: screenSize.height * 0.15)
        .offset(y: screenSize.height * 0.25)
    }

    @ViewBuilder
    private func ConnectedView(screenSize: CGSize) -> some View {
        VStack(alignment: .leading) {
            Text("デバイス名")
            TextField("", text: $deviceName)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("SSID")
            SecureField("", text: $ssid)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("PASSWORD")
            TextField("", text: $password)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            HStack {
                Button {
                    
                } label: {
                    Text(isRead ? "読み込む" : "完了")
                        .frame(width: screenSize.width * 0.4, height: 64)
                        .fontWeight(.bold)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 32)
        }
        .font(.title2)
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
    }

    private func connectionTest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            connectionStatus = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                connectionStatus = .failure
            }
        }
    }
}

#Preview {
    let size: CGSize = .init(width: 393.0, height: 759.0)
    return BLEConnectingView(screenSize: size)
}
