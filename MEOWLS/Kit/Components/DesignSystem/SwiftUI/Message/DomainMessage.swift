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
        .background {
            backgroundColor
        }
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
            color = Color(.badgeRedPrimary)

        case .attention:
            color = Color(.textPrimary)

        case .success:
            color = Color(.badgeGreenPrimary)

        case .info:
            color = Color(.textSecondary)

        }
        return color
    }

    var backgroundColor: Color {
        let color: Color

        switch type {
        case .error:
            color = Color(.badgeRedSecondary)

        case .attention:
            color = Color(.badgeYellowSecondary)

        case .success:
            color = Color(.badgeGreenSecondary)

        case .info:
            color = Color(.backgroundPrimary)

        }
        return color
    }

    var icon: some View {
        let icon: Image
        let iconColor: Color

        switch type {
        case .error:
            icon = Image(.exclamationMarkCircle)
            iconColor = Color(.badgeRedPrimary)

        case .attention:
            icon = Image(.exclamationMarkCircle)
            iconColor = Color(.badgeYellowPrimary)

        case .success:
            icon = Image(.checkCircle)
            iconColor = Color(.badgeGreenPrimary)

        case .info:
            icon = Image(.exclamationMarkCircle)
            iconColor = Color(.textDisabled)

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
