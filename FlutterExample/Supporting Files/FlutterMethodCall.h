//
//  FlutterMethodCall.h
//  FlutterExample
//
//  Created by Aamir  on 25/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlutterMethodCall : NSObject
@property (readonly, nonatomic) NSString *_Nonnull method;
@property (readonly, nonatomic, nullable) id arguments;
@end
