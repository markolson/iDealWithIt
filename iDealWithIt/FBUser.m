//
//  User.m
//  iDealWithIt
//
//  Created by Mark on 7/3/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "FBUser.h"

static NSString* kAppId = @"474165092612690";
@implementation FBUser
@synthesize fb;


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.fb handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.fb handleOpenURL:url];
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[fb accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[fb expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)apiFQLIMe {
    NSLog(@"whut");
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [fb requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (id) init
{
    self = [super init];
    NSLog(@"initing facebook");
    fb = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        fb.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        fb.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![fb isSessionValid]) {
        NSArray * permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
        [fb authorize:permissions];
        [permissions release];
    }else{
        [self apiFQLIMe];
    }
    return self;
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    NSLog(@"%@ %@", [result objectForKey:@"name"], [result objectForKey:@"uid"]);
}



@end
