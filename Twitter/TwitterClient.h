//
//  TwitterClient.h
//  Twitter
//
//  Created by Dan Weng on 7/1/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)SharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimeLineWithParams:(NSDictionary *) params completion: (void (^) (NSArray * tweets, NSError *error))completion;

@end
