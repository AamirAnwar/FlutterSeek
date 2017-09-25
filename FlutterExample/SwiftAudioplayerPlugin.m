//
//  SwiftAudioplayerPlugin.m
//  FlutterExample
//
//  Created by Aamir  on 25/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//


#import "SwiftAudioplayerPlugin.h"
#import "FlutterMethodChannel.h"

const NSObject *_Nonnull FlutterMethodNotImplemented;
@interface SwiftAudioplayerPlugin() <FlutterPlugin>
@property (nonatomic) BOOL isPlaying;
@end

@implementation SwiftAudioplayerPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        self.duration = CMTimeMake(0, 1);
        self.position = CMTimeMake(0, 1);
    }
    return self;
}

+ (void)registerWith:(id <FlutterPluginRegistrar>)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"bz.rxla.flutter/audio" binaryMessenger:[registrar messenger]];
    SwiftAudioplayerPlugin *instance = [[SwiftAudioplayerPlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    if (!(call.method.length > 0)) {
        return;
    }

    if ([call.method isEqualToString:@"play"]) {
        if ([call.arguments isKindOfClass:[NSDictionary class]] == NO) {
            result(0);
            return;
        }

        NSDictionary *info = (NSDictionary *)call.arguments;
        NSString *url = [info objectForKey:@"url"];
        id isLocalValue = [info valueForKey:@"isLocal"];

        if (url == nil || [isLocalValue isKindOfClass:[NSNumber class]] == false) {
            result(0);
            return;
        }

        NSNumber *isLocalNumber = (NSNumber *)isLocalValue;
        [self togglePlay:url isLocal:isLocalNumber.boolValue];
    }
    else if ([call.method isEqualToString:@"pause"]) {
        [self pause];
    }
    else if ([call.method isEqualToString:@"stop"]) {
        [self stop];

    }
    else if ([call.method isEqualToString:@"seek"]) {

        // This should be an NSNumber. Please double check this.
        if ([call.arguments isKindOfClass:[NSNumber class]] == NO) {
            result(0);
            return;
        }
        NSNumber *seekValue = (NSNumber *)call.arguments;
        [self seek:seekValue.floatValue];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
    // This also needs to be checked. Not sure what class type the SDK expects after converting from the generic 'id'.
    result(@(1));

}

- (void)togglePlay:(NSString *)url isLocal:(BOOL)local {
    if (url == nil) {
        return;
    }
    
    if ([url isEqualToString:self.lastURL] == false) {
        @try {
            [self.playerItem removeObserver:self forKeyPath:@"status"];
        }
        @catch (NSException *exceptiom) {
            
        }
        
#warning - Not sure about this line. onSoundComplete is probably an object elsewhere. Adding the converted line below this.
        // NotificationCenter.default.removeObserver(onSoundComplete)
        //[[NSNotificationCenter defaultCenter] removeObserver:<#(nonnull id)#>];
        
        self.playerItem = [[AVPlayerItem alloc] initWithURL:local ? [NSURL fileURLWithPath:url] : [NSURL URLWithString:url]];
        self.lastURL = url;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self onSoundComplete:note];
        }];
        
        if (self.player != nil) {
            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        }
        else {
            self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        }
        __weak SwiftAudioplayerPlugin *weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.2, NSEC_PER_SEC)  queue:nil usingBlock:^(CMTime time) {
            [weakSelf onTimeInterval:time];
        }];
        
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        
        if (self.isPlaying) {
            [self pause];
        }
        else {
            [self updateDuration];
            [self.player play];
            self.isPlaying = YES;
        }
    }
}


- (void)updateDuration {
    if (self.player.currentItem) {
        self.duration = self.player.currentItem.duration;
        if (CMTimeGetSeconds(self.duration) > 0) {
            // @(CMTimeGetSeconds(self.duration)) sends an NSNumber. Please check if this is the type expected.
            [self.channel invokeMethod:@"audio.onDuration" arguments:@(CMTimeGetSeconds(self.duration))];
        }
        
    }
}

- (void)onTimeInterval:(CMTime)time {
    double seconds = CMTimeGetSeconds(time) * 1000;
    [self.channel invokeMethod:@"audio.onCurrentPosition" arguments:@(seconds)];
}


- (void)pause {
    [self.player pause];
    self.isPlaying = NO;
}

- (void)stop {
    if (self.isPlaying) {
        [self.player pause];
        [self.player seekToTime:CMTimeMake(0, 1)];
        self.isPlaying = false;
    }
}
- (void)seek:(CGFloat)seconds {
    CMTime time = CMTimeMakeWithSeconds(seconds, 1);
    [self.playerItem seekToTime:time completionHandler:nil];
}

- (void)onSoundComplete:(NSNotification *)note {
    self.isPlaying = NO;
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.channel invokeMethod:@"audio.onComplete" arguments:nil];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: @"status"] == false) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self updateDuration];
        }
        else if (self.player.status == AVPlayerItemStatusFailed) {
            [self.channel invokeMethod:@"audio.onError" arguments:@"AVPlayerItemStatus.failed"];
        }
    }
}


- (void)dealloc {
    
    @try {
        if (self.player) {
#warning - Not sure about this line. OnTimeInterval seems to be defined elsewhere as an object. Adding the converted syntax below
             //p.removeTimeObserver(onTimeInterval)
            //[self.player removeTimeObserver:<#(nonnull id)#>]
            
            
            [self.player.currentItem removeObserver:self forKeyPath:@"status"];
            
#warning - Not sure about this line. Added the converted line below. onSoundComplete seems to be declared elsewhere
            //NotificationCenter.default.removeObserver(onSoundComplete)
            //[[NSNotificationCenter defaultCenter] removeObserver:<#(nonnull id)#>]
            
        }
    } @catch (NSException *exception) {
        
    }
}
@end
