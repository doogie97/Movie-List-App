//
//  MovieDetailBottomInfoView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class MovieDetailBottomInfoView: UIView {
    private lazy var plotTitleLabel = pretendardLabel(family: .SemiBold, size: 16, color: .xButtonBG, text: "줄거리")
    private lazy var plotLabel = pretendardLabel(lineCount: 0)
    
    private lazy var actorsTitleLabel = pretendardLabel(family: .SemiBold, size: 16, color: .xButtonBG, text: "출연진")
    private lazy var actorsLabel = pretendardLabel(lineCount: 0)
    
    private lazy var directorTitleLabel = pretendardLabel(family: .SemiBold, size: 16, color: .xButtonBG, text: "감독")
    private lazy var directorLabel = pretendardLabel(lineCount: 0)
    
    private lazy var writerTitleLabel = pretendardLabel(family: .SemiBold, size: 16, color: .xButtonBG, text: "작가")
    private lazy var writerLabel = pretendardLabel(lineCount: 0)
    
    func setViewContents(movieDetail: MovieDetail) {
        plotLabel.text = movieDetail.plot
        actorsLabel.text = movieDetail.actors
        directorLabel.text = movieDetail.director
        writerLabel.text = movieDetail.writer
        
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(plotTitleLabel)
        self.addSubview(plotLabel)
        self.addSubview(actorsTitleLabel)
        self.addSubview(actorsLabel)
        self.addSubview(directorTitleLabel)
        self.addSubview(directorLabel)
        self.addSubview(writerTitleLabel)
        self.addSubview(writerLabel)
        
        plotTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        plotLabel.snp.makeConstraints {
            $0.top.equalTo(plotTitleLabel.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        actorsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(plotLabel.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        actorsLabel.snp.makeConstraints {
            $0.top.equalTo(actorsTitleLabel.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        directorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(actorsLabel.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(directorTitleLabel.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        writerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        writerLabel.snp.makeConstraints {
            $0.top.equalTo(writerTitleLabel.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview() // 다음 뷰로 이동
        }
    }
}
