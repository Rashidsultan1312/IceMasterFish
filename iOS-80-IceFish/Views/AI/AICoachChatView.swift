import SwiftUI

struct AICoachChatView: View {
    @StateObject private var viewModel: AICoachChatViewModel
    @EnvironmentObject private var loc: LocalizationService
    @State private var draftMessage: String = ""

    init(kind: AICoachChatKind) {
        _viewModel = StateObject(wrappedValue: AICoachChatViewModel(kind: kind))
    }

    private var bodyGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.teamDetailBodyGradientStart,
                ColorPalette.teamDetailBodyGradientMid,
                ColorPalette.teamDetailBodyGradientEnd
            ],
            startPoint: UnitPoint(x: 0.02, y: 0),
            endPoint: UnitPoint(x: 0.98, y: 1)
        )
    }

    private var userBubbleGradient: LinearGradient {
        LinearGradient(
            colors: [ColorPalette.chatUserBubbleTop, ColorPalette.chatUserBubbleBottom],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }

    private var sendButtonGradient: LinearGradient {
        LinearGradient(
            colors: [ColorPalette.chatSendButtonGradientStart, ColorPalette.chatSendButtonGradientEnd],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()
                bodyGradient
                    .ignoresSafeArea()

                Image("AICoachChatDecor")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("ai_coach.chat.nav_title"),
                        backButtonImageName: "AICoachChatBack",
                        bottomPadding: 24,
                        shadowStyle: .softBlue
                    )

                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                dateDivider
                                if let key = viewModel.errorBannerKey {
                                    Text(loc.localized(key))
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(ColorPalette.removeBadgeRed)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 12)
                                }
                                ForEach(viewModel.messages) { message in
                                    messageRow(message)
                                        .id(message.id)
                                }
                                if viewModel.isTyping {
                                    typingRow
                                        .id("typing")
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 24)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onChange(of: viewModel.messages.count) { _ in
                            scrollToEnd(proxy: proxy)
                        }
                        .onChange(of: viewModel.isTyping) { isTyping in
                            if isTyping {
                                scrollToEnd(proxy: proxy)
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    chatInputBar()
                        .padding(.top, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.bootstrapIfNeeded(intro: loc.localized(introKey))
        }
        .onChange(of: loc.language) { _ in
            viewModel.refreshLocalizedIntro(intro: loc.localized(introKey))
        }
    }

    private var introKey: String {
        switch viewModel.kind {
        case .fishing: return "ai_coach.fishing.intro"
        case .tournament: return "ai_coach.tournament.intro"
        }
    }

    private var roleTitleKey: String {
        switch viewModel.kind {
        case .fishing: return "ai_coach.fishing.role_title"
        case .tournament: return "ai_coach.tournament.role_title"
        }
    }

    private func scrollToEnd(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            if viewModel.isTyping {
                proxy.scrollTo("typing", anchor: .bottom)
            } else if let last = viewModel.messages.last?.id {
                proxy.scrollTo(last, anchor: .bottom)
            }
        }
    }

    private var dateDivider: some View {
        HStack {
            Spacer()
            Text(loc.localized("ai_coach.chat.today"))
                .font(.system(size: 10, weight: .bold))
                .tracking(0.5)
                .foregroundColor(ColorPalette.teamStatNumber)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(ColorPalette.chatDatePillBackground)
                .clipShape(Capsule())
                .background(.ultraThinMaterial, in: Capsule())
            Spacer()
        }
    }

    private func messageRow(_ message: CoachChatMessage) -> some View {
        Group {
            switch message.role {
            case .assistant:
                assistantBubble(text: message.text)
            case .user:
                userBubble(text: message.text)
            }
        }
        .padding(.top, 20)
    }

    private func assistantBubble(text: String) -> some View {
        HStack(alignment: .bottom, spacing: 12) {
            Image("AICoachChatAIAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(loc.localized(roleTitleKey))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ColorPalette.chatBubbleLabel)
                    .padding(.leading, 4)

                Text(text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.aiCardTitle)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: 280, alignment: .leading)
                    .background(ColorPalette.background)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 2,
                            topTrailingRadius: 16,
                            style: .continuous
                        )
                    )
                    .overlay(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 2,
                            topTrailingRadius: 16,
                            style: .continuous
                        )
                        .stroke(ColorPalette.chatAiBubbleStroke, lineWidth: 1)
                    )

                Text(loc.localized("ai_coach.chat.time_now"))
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(ColorPalette.leagueSegmentFill)
                    .padding(.leading, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func userBubble(text: String) -> some View {
        HStack(alignment: .bottom, spacing: 12) {
            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 4) {
                Text(loc.localized("ai_coach.chat.sender_you"))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ColorPalette.chatBubbleLabel)
                    .padding(.trailing, 4)

                Text(text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.background)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .frame(maxWidth: 280, alignment: .leading)
                    .background(userBubbleGradient)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 2,
                            bottomTrailingRadius: 16,
                            topTrailingRadius: 16,
                            style: .continuous
                        )
                    )
                    .shadow(color: ColorPalette.shadowBlue.opacity(0.35), radius: 8, x: 0, y: 4)

                Text(loc.localized("ai_coach.chat.time_now"))
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(ColorPalette.leagueSegmentFill)
                    .padding(.trailing, 4)
            }

            Image("AICoachChatUserAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        }
    }

    private var typingRow: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Image("AICoachChatAIAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            Image("AICoachChatTyping")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .frame(height: 48)
            Spacer(minLength: 0)
        }
        .padding(.top, 20)
    }

    private func chatInputBar() -> some View {
        HStack(spacing: 8) {
            TextField("", text: $draftMessage, prompt: Text(loc.localized("ai_coach.chat.placeholder"))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(ColorPalette.leagueSegmentFill))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(ColorPalette.squadHeading)
                .padding(.vertical, 10)

            Button {
                sendTapped()
            } label: {
                Image("AICoachChatSend")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .opacity(draftMessageTrimmed.isEmpty || viewModel.isTyping ? 0.45 : 1)
            }
            .buttonStyle(.plain)
            .disabled(draftMessageTrimmed.isEmpty || viewModel.isTyping)
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .background(ColorPalette.chatInputBarFill)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(ColorPalette.chatInputBarStroke, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    private var draftMessageTrimmed: String {
        draftMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func sendTapped() {
        let text = draftMessageTrimmed
        guard !text.isEmpty else { return }
        draftMessage = ""
        Task {
            await viewModel.send(userText: text)
        }
    }
}

#Preview("Fishing") {
    AICoachChatView(kind: .fishing)
        .environmentObject(LocalizationService.shared)
}

#Preview("Tournament") {
    AICoachChatView(kind: .tournament)
        .environmentObject(LocalizationService.shared)
}
