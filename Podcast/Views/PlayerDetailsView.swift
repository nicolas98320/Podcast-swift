//
//  PlayerDetailsView.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 9/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import MediaPlayer

class PlayerDetailsView: UIView {
  
  var episode: Episode! {
    didSet {
      titleLabel.text = episode.title
      miniTitleLabel.text = episode.title
      authorLabel.text = episode.author
      
      setupNowPlayingInfo()
      
      playEpisode()
      
      guard let url = URL(string: episode.imageUrl ?? "") else { return }
      episodeImageView.kf.setImage(with: url)
      
      miniEpisodeImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, _, _, _) in
        let image = self.episodeImageView.image ?? UIImage()
        let artworkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
          return image
        })
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
      }
    }
  }
  
  fileprivate func setupNowPlayingInfo() {
    var nowPlayingInfo = [String: Any]()
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
  
  fileprivate func playEpisode() {
    if episode.fileUrl != nil {
      playEpisodeUsingFileUrl()
    } else {
      guard let url = URL(string: episode.streamUrl) else { return }
      let playerItem = AVPlayerItem(url: url)
      player.replaceCurrentItem(with: playerItem)
      player.play()
    }
  }
  
  fileprivate func playEpisodeUsingFileUrl() {
    guard let fileURL = URL(string: episode.fileUrl ?? "") else { return }
    let fileName = fileURL.lastPathComponent

    guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    trueLocation.appendPathComponent(fileName)

    let playerItem = AVPlayerItem(url: trueLocation)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  let player: AVPlayer = {
    let avPlayer = AVPlayer()
    avPlayer.automaticallyWaitsToMinimizeStalling = false
    return avPlayer
  }()
  
  fileprivate func observePlayerCurrentTime() {
    let interval = CMTimeMake(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
      guard let `self` = self else { return }
      self.currentTimeLabel.text = time.toDisplayString()
      let durationTime = self.player.currentItem?.duration
      self.durationLabel.text = durationTime?.toDisplayString()
      
      self.updateCurrentTimeSlider()
    }
  }
  
  fileprivate func updateCurrentTimeSlider() {
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationSeconds
    
    currentTimeSlider.value = Float(percentage)
  }
  
  fileprivate func setupAudioSession() {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch let sessionErr {
      print("Failed to activate session:", sessionErr)
    }
  }
  
  fileprivate func setupRemoteControl() {
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.player.play()
      self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      self.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      self.setupElapsedTime(playbackRate: 1)
      return .success
    }
    
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.player.pause()
      self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      self.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      self.setupElapsedTime(playbackRate: 0)
      return .success
    }
    
    commandCenter.togglePlayPauseCommand.isEnabled = true
    commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.handlePlayPause()
      return .success
    }
    
    commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
    commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePrevTrack))
  }
  
  var playlistEpisodes = [Episode]()

  @objc fileprivate func handlePrevTrack(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    if playlistEpisodes.isEmpty {
      return .noSuchContent
    }
    
    let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
      return self.episode.title == ep.title && self.episode.author == ep.author
    }
    guard let index = currentEpisodeIndex else { return .noSuchContent }
    let prevEpisode: Episode
    if index == 0 {
      let count = playlistEpisodes.count
      prevEpisode = playlistEpisodes[count - 1]
    } else {
      prevEpisode = playlistEpisodes[index - 1]
    }
    self.episode = prevEpisode
    return .success
  }
  
  @objc fileprivate func handleNextTrack(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    if playlistEpisodes.count == 0 {
      return .noSuchContent
    }
    
    let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
      return self.episode.title == ep.title && self.episode.author == ep.author
    }
    
    guard let index = currentEpisodeIndex else { return .noSuchContent }
    
    let nextEpisode: Episode
    if index == playlistEpisodes.count - 1 {
      nextEpisode = playlistEpisodes[0]
    } else {
      nextEpisode = playlistEpisodes[index + 1]
    }
    
    self.episode = nextEpisode
    return .success
  }
  
  fileprivate func setupElapsedTime(playbackRate: Float) {
    let elapsedTime = CMTimeGetSeconds(player.currentTime())
    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
  }
  
  fileprivate func observeBoundaryTime() {
    let time = CMTimeMake(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      guard let `self` = self else { return }
      self.enlargeEpisodeImageView()
      self.setupLockscreenDuration()
    }
  }
  
  fileprivate func setupLockscreenDuration() {
    guard let duration = player.currentItem?.duration else { return }
    let durationSeconds = CMTimeGetSeconds(duration)
    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
  }
    
  var panGesture: UIPanGestureRecognizer!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupRemoteControl()
    setupAudioSession()
    setupGestures()
    setupInterruptionObserver()
    observePlayerCurrentTime()
    observeBoundaryTime()
  }
  
  fileprivate func setupInterruptionObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
  }
  
  @objc fileprivate func handleInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
    if type == AVAudioSession.InterruptionType.began.rawValue {
      playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    } else {
      guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
      if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      }
    }
  }
  
  fileprivate func setupGestures() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    addGestureRecognizer(panGesture)
    maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
  }
  
  static func initFromNib() -> PlayerDetailsView {
    return PlayerDetailsView.viewFromNib as! PlayerDetailsView
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
  }
  
  fileprivate func enlargeEpisodeImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.episodeImageView.transform = .identity
    })
  }
  
  fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
  
  fileprivate func shrinkEpisodeImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.episodeImageView.transform = self.shrunkenTransform
    })
  }
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var miniEpisodeImageView: UIImageView!
  @IBOutlet weak var miniTitleLabel: UILabel!
  
  @IBOutlet weak var miniPlayPauseButton: UIButton! {
    didSet {
      miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
      miniPlayPauseButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
  }
  
  @IBOutlet weak var miniFastForwardButton: UIButton! {
    didSet {
      miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
      miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
    }
  }
  
  @IBOutlet weak var miniPlayerView: UIView!
  @IBOutlet weak var maximizedStackView: UIStackView!
  @IBOutlet weak var currentTimeSlider: UISlider!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var currentTimeLabel: UILabel!
  
  @IBAction func handleDismiss(_ sender: Any) {
    UIApplication.mainTabBarController()?.minimizePlayerDetails()
  }
  
  @IBOutlet weak var episodeImageView: UIImageView! {
    didSet {
      episodeImageView.layer.cornerRadius = 5
      episodeImageView.clipsToBounds = true
      episodeImageView.transform = shrunkenTransform
    }
  }
  
  @IBOutlet weak var playPauseButton: UIButton! {
    didSet {
      playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
    }
  }
  
  @objc func handlePlayPause() {
    if player.timeControlStatus == .paused {
      player.play()
      playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      enlargeEpisodeImageView()
      self.setupElapsedTime(playbackRate: 1)
    } else {
      player.pause()
      playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      shrinkEpisodeImageView()
      self.setupElapsedTime(playbackRate: 0)
    }
  }
  
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.numberOfLines = 2
    }
  }
  
  //MARK:- IBActions
  
  @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
    let percentage = currentTimeSlider.value
    guard let duration = player.currentItem?.duration else { return }
    let durationInSeconds = CMTimeGetSeconds(duration)
    let seekTimeInSeconds = Float64(percentage) * durationInSeconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
    
    player.seek(to: seekTime)
  }
  
  @IBAction func handleFastForward(_ sender: Any) {
    seekToCurrentTime(delta: 15)
  }
  
  @IBAction func handleRewind(_ sender: Any) {
    seekToCurrentTime(delta: -15)
  }
  
  fileprivate func seekToCurrentTime(delta: Int64) {
    let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
    let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
    player.seek(to: seekTime)
  }
  
  @IBAction func handleVolumeChange(_ sender: UISlider) {
    player.volume = sender.value
  }
  
}
