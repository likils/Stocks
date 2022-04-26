// ----------------------------------------------------------------------------
//
//  TimelineButtonsView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import CombineCocoa
import UIKit
import StocksData
import StocksSystem

// ----------------------------------------------------------------------------

protocol TimelineButtonsViewListener: AnyObject {

    // MARK: - Methods

    func buttonDidClick(with timeline: CompanyCandlesTimeline)
}

// ----------------------------------------------------------------------------

final class TimelineButtonsView: UIStackView {

    // MARK: - Subviews

    private let timelineButtonsStackView = UIStackView() <- {
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = Const.timelineStackViewSpacing
    }

    // MARK: - Construction

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private var timelineButtons: [UIButton] = .empty
    private weak var listener: TimelineButtonsViewListener?
    private var subscriptions: Set<AnyCancellable> = .empty

    // MARK: - Methods

    func updateView(with viewModel: TimelineButtonsViewModel) {

        guard self.timelineButtons.isEmpty else { return }

        self.listener = viewModel.listener
        prepareTimelineButtons(with: viewModel)
    }

    // MARK: - Actions

    private func buttonDidClick(with timeline: CompanyCandlesTimeline) {

        let selectedButtonIndex = timeline.caseIndex
        setupSelectedButton(with: selectedButtonIndex)

        self.listener?.buttonDidClick(with: timeline)
    }

    // MARK: - Private Methods

    private func prepareTimelineButtons(with viewModel: TimelineButtonsViewModel) {

        viewModel.timelines.forEach {
            let button = createTimelineButton(with: $0)
            timelineButtonsStackView.addArrangedSubview(button)
            timelineButtons.append(button)
        }

        let selectedButtonIndex = viewModel.selectedTimeline.caseIndex
        setupSelectedButton(with: selectedButtonIndex)
    }

    private func createTimelineButton(with timeline: CompanyCandlesTimeline) -> UIButton {

        return UIButton() <- {
            $0.titleLabel?.font = StocksFont.body
            $0.setTitle(timeline.rawValue, for: .normal)

            $0.tapPublisher
                .sink { [weak self] in self?.buttonDidClick(with: timeline) }
                .store(in: &self.subscriptions)
        }
    }

    private func setupSelectedButton(with selectedIndex: Int) {
        self.timelineButtons.enumerated().forEach { index, btn in

            let titleColor: UIColor = (index == selectedIndex) ? .black : StocksColor.secondary
            let image: UIImage? = (index == selectedIndex) ? UIImage(named: "ic_oval") : nil

            btn.setTitleColor(titleColor, for: .normal)
            btn.setBackgroundImage(image, for: .normal)
        }
    }

    private func setupView() {
        addSubview(timelineButtonsStackView)
        timelineButtonsStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Const.timelineStackViewSpacing)
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let timelineStackViewSpacing: CGFloat = 24.0
    }
}
