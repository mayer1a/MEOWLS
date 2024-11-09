//
//  DomainMessage.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

public struct DomainMessage: View {

    public let label: String
    public let type: MessageType

    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(LocalizedStringKey(label))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(foregroundColor)
                .padding(.top, 2)

            Spacer(minLength: 16)

            icon.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

}

public extension DomainMessage {

    enum MessageType {
        case error
        case attention
        case success
        case info
    }

}

private extension DomainMessage {

    var foregroundColor: Color {
        let color: Color

        switch type {
        case .error:
            color = Colors.Badge.badgeRedPrimary.suiColor

        case .attention:
            color = Colors.Text.textPrimary.suiColor

        case .success:
            color = Colors.Badge.badgeGreenPrimary.suiColor

        case .info:
            color = Colors.Text.textSecondary.suiColor

        }
        return color
    }

    var backgroundColor: Color {
        let color: Color

        switch type {
        case .error:
            color = Colors.Badge.badgeRedSecondary.suiColor

        case .attention:
            color = Colors.Badge.badgeYellowSecondary.suiColor

        case .success:
            color = Colors.Badge.badgeGreenSecondary.suiColor

        case .info:
            color = Colors.Background.backgroundPrimary.suiColor

        }
        return color
    }

    var icon: some View {
        let icon: Image
        let iconColor: Color

        switch type {
        case .error:
            icon = Images.Common.exclamationMarkCircle.suiImage
            iconColor = Colors.Badge.badgeRedPrimary.suiColor

        case .attention:
            icon = Images.Common.exclamationMarkCircle.suiImage
            iconColor = Colors.Badge.badgeYellowPrimary.suiColor

        case .success:
            icon = Images.Common.checkCircle.suiImage
            iconColor = Colors.Badge.badgeGreenPrimary.suiColor

        case .info:
            icon = Images.Common.exclamationMarkCircle.suiImage
            iconColor = Colors.Text.textDisabled.suiColor

        }

        return icon.foregroundStyle(iconColor)
    }

}

#Preview {
    VStack(spacing: 30) {
        DomainMessage(label: "Отображается информационное сообщение", type: .info)
        DomainMessage(label: "Отображается сообщение об успехе", type: .success)
        DomainMessage(label: "Отображается предупреждение", type: .attention)
        DomainMessage(label: "Отображается ошибка", type: .error)

    }
    .padding(.horizontal, 24)
}
