//
//  Publisher+AVPlayer.swift
//  Pool
//
//  Created by yongbeomkwak on 12/14/25.
//

import AVFoundation
import Combine
import Foundation

extension AVPlayer {
  public var playTimePublisher: AnyPublisher<CMTime, Never> {
    AVPlayerPlayTimePublisher(self)
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  struct AVPlayerPlayTimePublisher: Publisher {
    typealias Output = CMTime
    typealias Failure = Never

    private let player: AVPlayer

    init(_ player: AVPlayer) {
      self.player = player
    }

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
      let subscription = Subscription(
        subscriber: subscriber,
        player: player
      )

      subscriber.receive(subscription: subscription)
    }
  }
}

extension AVPlayer.AVPlayerPlayTimePublisher {
  final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == CMTime, S.Failure == Never {
    private var subscriber: S?
    private let player: AVPlayer
    private var timeObserver: Any?

    init(
      subscriber: S,
      player: AVPlayer,
      timeObserver: Any? = nil
    ) {
      self.subscriber = subscriber
      self.player = player
      observe()
    }

    deinit {
      cancel()
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
      if let observer = timeObserver {
        player.removeTimeObserver(observer)
        timeObserver = nil
      }
      subscriber = nil
    }

    private func observe() {
      let interval = CMTime(
          seconds: 1.0 / 30.0,
          preferredTimescale: CMTimeScale(NSEC_PER_SEC)
      )
      self.timeObserver = player.addPeriodicTimeObserver(
        forInterval: interval,
        queue: .global(),
        using: { [weak self] time in
          guard let self,
                let subscriber = self.subscriber
          else { return }
          _ = subscriber.receive(time)
        }
      )
    }
  }
}
