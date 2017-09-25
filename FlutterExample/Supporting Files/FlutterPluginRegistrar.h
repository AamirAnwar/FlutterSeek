//
//  FlutterPluginRegistrar.h
//  FlutterExample
//
//  Created by Aamir  on 25/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlutterBinaryMessenger.h"
#import "FlutterMethodChannel.h"

@protocol FlutterPlugin <NSObject>
@end

@protocol FlutterPluginRegistrar <NSObject>
- (nonnull NSObject<FlutterBinaryMessenger> *)messenger;
- (void)addMethodCallDelegate:(nonnull NSObject<FlutterPlugin> *)delegate
                      channel:(nonnull FlutterMethodChannel *)channel;
@end

