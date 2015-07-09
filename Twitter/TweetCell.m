//
//  TweetCell.m
//  Twitter
//
//  Created by Dan Weng on 7/2/15.
//  Copyright (c) 2015 com.danweng. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import <NSDate+DateTools.h>


@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTweet:(Tweet *)tweet{
    _tweet = tweet;
    [self.img setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.name.text = self.tweet.user.name;
    self.location.text = self.tweet.place;
    self.content.text = self.tweet.text;
    self.createTime.text = self.tweet.createdAt.shortTimeAgoSinceNow;
}

@end
