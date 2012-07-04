//
//  User.h
//  iDealWithIt
//
//  Created by Mark on 7/3/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"

@interface FBUser : NSObject <FBSessionDelegate, FBRequestDelegate> { Facebook *fb; }

@property (strong, nonatomic) Facebook *fb;
@end
