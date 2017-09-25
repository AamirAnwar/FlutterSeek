//
//  SwiftAudioplayerPlugin.h
//  FlutterExample
//
//  Created by Aamir  on 25/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

#import <Foundation/Foundation.h>

// Import flutter here
//#import "Flutter.h"

// Placeholder classes to simulate run environment. Definitions are taken from Flutter docs.
//start
#import "FlutterMethodChannel.h"
#import "FlutterPluginRegistrar.h"
#import "FlutterMethodCall.h"
const NSObject *_Nonnull FlutterMethodNotImplemented;
typedef void (^FlutterResult)(id _Nullable);
// end

@import UIKit;
@import AVKit;
@import AVFoundation;

@interface SwiftAudioplayerPlugin : NSObject
@property (nonatomic, strong) FlutterMethodChannel * _Nonnull channel;
@property (nonatomic, strong) AVPlayer * _Nullable player;
@property (nonatomic, strong) AVPlayerItem * _Nullable playerItem;
@property (nonatomic) CMTime duration;
@property (nonatomic) CMTime position;
@property (nonatomic, copy) NSString * _Nullable lastURL;

+ (void)registerWith:(_Nonnull id <FlutterPluginRegistrar>)registrar;
- (instancetype _Nonnull )initWithChannel:(FlutterMethodChannel * _Nonnull)channel;
- (void)handleCall:(FlutterMethodCall * _Nonnull)call result:(FlutterResult _Nonnull )result;
- (void)updateDuration;
- (void)pause;
- (void)stop;
- (void)seek:(CGFloat)seconds;
- (void)onSoundComplete:(NSNotification *_Nonnull)note;
- (void)onTimeInterval:(CMTime)time;

@end
