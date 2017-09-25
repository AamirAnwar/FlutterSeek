//
//  FlutterMethodChannel.h
//  FlutterExample
//
//  Created by Aamir  on 25/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlutterBinaryMessenger.h"

@interface FlutterMethodChannel : NSObject
+ (instancetype)methodChannelWithName:(NSString*)name
                      binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (void)invokeMethod:(NSString*)method arguments:(id _Nullable)arguments;
@end
