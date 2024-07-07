//
//  DetailGameView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 13/06/24.
//

import SwiftUI
import SwiftData
import Core

struct GameDetailView: View {
    @StateObject var presenter: GameDetailPresenter
    var gameId: String = ""

    init(presenter: GameDetailPresenter, gameId: String) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.gameId = gameId
    }

    var body: some View {
        GameDetailContainer(presenter: presenter, gameId: gameId)
            .task {
                if presenter.gameDetail.data == nil {
                    await presenter.getGameDetail(withId: gameId)
                }
            }
    }
}

struct GameDetailContainer: View {
    @ObservedObject var presenter: GameDetailPresenter
    var gameId: String
    var body: some View {
        presenter.gameDetail.toView(
            onSuccess: {game in
                GameDetail(presenter: presenter, game: game)
            }, onError: { error in
                if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet {
                    NoInternetConnectionView(onTapRetryButton: {
                        Task {
                            await presenter.getGameDetail(withId: gameId)
                        }
                    })
                } else {
                    Text(
                        "An error occurred"
                    )
                }
            },
            onLoading: {
                ProgressView()
            })
    }
}

struct GameDetail: View {
    @State var scrollOffset = CGFloat.zero
    @ObservedObject var presenter: GameDetailPresenter
    var game: Game

    init(presenter: GameDetailPresenter, game: Game) {
        self.presenter = presenter
        self.game = game
    }
    var navigationBarBackgroundIsVisible: Bool {
        if self.scrollOffset > 177 {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        ObservableScrollView(scrollOffset: $scrollOffset) { _ in
            VStack(alignment: .leading) {
                Group {
                    if !game.imageUrl.isEmpty {
                        AsyncImage(url: URL(string: game.imageUrl)) {result in
                            result.image?.resizable()
                        }.frame(width: UIScreen.main.bounds.width, height: 270).edgesIgnoringSafeArea(.top)
                    } else {
                        Rectangle()
                            .fill(.indigo)
                            .frame(width: UIScreen.main.bounds.width, height: 270)
                            .edgesIgnoringSafeArea(.top)
                    }
                }.overlay(alignment: .bottom) {
                    Rectangle().fill(
                        LinearGradient(gradient: .init(colors: [.clear, .black]),
                                       startPoint: .init(x: 1, y: 0),
                                       endPoint: .init(x: 1, y: 1)))
                    .frame(height: 100)
                }
                VStack(alignment: .leading) {
                    Text(game.title).font(
                        .system(
                            size: 30,
                            weight: .bold
                        )
                    ).padding(.bottom, 2)
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(["PC", "PlayStation", "Xbox", "Apple Macintosh", "Nintendo"].joined(separator: " | "))
                            Text("Released on \(game.releasedDate)")
                        }
                        Spacer()
                        VStack {
                            Text(game.playtime).font(
                                .system(
                                    size: 20,
                                    weight: .bold
                                )
                            ).padding(.bottom, 2)
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text(String(format: "%.1f", game.rating)).fixedSize()
                            }.padding(.horizontal, 12)
                        }
                    }
                    Button(action: {
                        presenter.openWebView(url: game.website)
                    }, label: {
                        Text("Visit Website")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .bold
                                ))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(10)
                    }).padding(.vertical, 14).padding(.horizontal, 28)
                    Text("Description").font(
                        .system(
                            size: 20,
                            weight: .bold
                        )).padding(.bottom, 2)
                    Text(game.desc)
                }.padding(.vertical, 8).padding(.horizontal, 12)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(isImageVisible: !navigationBarBackgroundIsVisible))
        .navigationBarItems(trailing: FavoriteButton(
            isFavorite: presenter.isFavorite,
            isImageVisible: !navigationBarBackgroundIsVisible) {
            presenter.setFavoriteState()
        })
        .toolbarBackground(navigationBarBackgroundIsVisible ? .visible : .hidden, for: .navigationBar)
    }
}

#Preview {
    return NavigationStack {
        GameDetailView(presenter: Injection.instance.resolve(GameDetailPresenter.self)!, gameId: "0")
    }
}

struct FavoriteButton: View {
    var isFavorite: Bool
    @Environment(\.colorScheme) var colorScheme
    var isImageVisible: Bool
    var onTapButton: () -> Void

    /// Background
    var backgroundColor: Color {
        if colorScheme == .light {
            if isFavorite {
                if isImageVisible {
                    return Color.white
                } else {
                    return Color.red
                }
            }
            if isImageVisible {
                return Color.black.opacity(0.2)
            } else {
                return Color.gray.opacity(0.2)
            }
        } else {
            if isFavorite {
                if isImageVisible {
                    return Color.white
                } else {
                    return Color.red
                }
            }
            if isImageVisible {
                return Color.black.opacity(0.2)
            } else {
                return Color.gray.opacity(0.2)
            }
        }
    }

    /// Icon
    var foregroundColor: Color {
        if colorScheme == .light {
            if isFavorite {
                if isImageVisible {
                    return Color.black.opacity(0.6)
                } else {
                    return Color.white
                }
            }
            if isImageVisible {
                return Color.white
            } else {
                return Color.red
            }
        } else {
            if isFavorite {
                return Color.black.opacity(isImageVisible ? 0.5 : 1)
            }
            if isImageVisible {
                return Color.white
            } else {
                return Color.red
            }
        }
    }

    var body: some View {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundColor(foregroundColor)
            .padding(8)
            .background(backgroundColor)
            .clipShape(Circle()).onTapGesture {
                onTapButton()
            }
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var isImageVisible: Bool

    var foregroundColor: Color {
        if isImageVisible {
            return Color.white
        } else {
            return Color.red
        }
    }

    var body: some View {
        Image(systemName: "arrow.left")
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundColor(foregroundColor)
            .padding(8)
            .background(Color.black.opacity(0.2))
            .clipShape(Circle())
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    return BackButton(isImageVisible: true)
}

#Preview(traits: .sizeThatFitsLayout) {
    return FavoriteButton(isFavorite: false, isImageVisible: false) {

    }
}
