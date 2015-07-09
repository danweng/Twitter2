//
//  TwitterClient.m
//  Twitter
//
//  Created by Dan Weng on 7/1/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"jiai2p16IlIZAoJGlKRjxjVIy";
NSString * const kTwitterConsumerSecret = @"qdpcmXK2XrG078vidN7sRChiyQ6otfGyCZ58Vgi5B93uTDVHGR";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) SharedInstance{
    static TwitterClient *instance = nil;
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl ] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion{
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"danwengdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"yes");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error){
        NSLog(@"no");
        self.loginCompletion(nil, error);
    }];
}

-(void)openURL:(NSURL *)url{
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query]  success:^(BDBOAuthToken *accessToken){
        
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            self.loginCompletion(nil, error);
        }];
        
        /*
        [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
        */
    }
    failure: ^(NSError *error){
        self.loginCompletion(nil, error);
    }];

}


- (void)homeTimeLineWithParams:(NSDictionary *) params completion: (void (^) (NSArray * tweets, NSError *error))completion{
    
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error){
        completion(nil, error);
    }];
    
}

@end
