//
//  TweetCell.m
//  twitter
//
//  Created by emilyabest on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "TimelineViewController.h"
#import "APIManager.h"

// [2] Define a custom table view cell and set it’s reuse identifier
@interface TweetCell ()

@end

@implementation TweetCell

/**
 Initializes the cell? Boiler plate code.
 */
- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 Sets the selected cell as selected? Boiler plate code.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 User tapped the favorite button
 */
- (IBAction)didTapFavorite:(id)sender {
    // If user tapped to favorite the tweet
    if (!self.tweet.favorited){
        // Update to favorited; also update the favorite count and favorited symbol to favorited; also update favorite font color
        self.tweet.favorited = YES;
        self.favoritedCount.text = [@(++self.tweet.favoriteCount) stringValue];
        [sender setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        self.favoritedCount.textColor = [UIColor colorWithRed:210/255.0 green:57/255.0 blue:78/255.0 alpha:1];
        
        // Send a POST request to the POST favorite/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            } else {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
        }];
    } // Else, user tapped to unfavorite the tweet
    else {
        // Update to unfavorited; also update the favorite count and favorited symbol to unfavorited
        self.tweet.favorited = NO;
        self.favoritedCount.text = [@(--self.tweet.favoriteCount) stringValue];
        [sender setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        self.favoritedCount.textColor = [UIColor colorWithRed:172/255.0 green:184/255.0 blue:194/255.0 alpha:1];
        
        // Send a POST request to the POST unfavorite/destroy endpoint
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            } else {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
        }];
    }
}

/**
 User tapped the retweet button
 */
- (IBAction)didTapRetweet:(id)sender {
    // If user tapped to retweet the tweet
    if (!self.tweet.retweeted) {
        // Update to retweeted; also update retweet count and retweet symbol to retweeted; also update retweet font color
        self.tweet.retweeted = YES;
        self.retweetCount.text = [@(++self.tweet.retweetCount) stringValue];
        [sender setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        self.retweetCount.textColor = [UIColor colorWithRed:94/255.0 green:205/255.0 blue:138/255.0 alpha:1];;
        
        // Send a POST request to the POST retweet endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            } else {
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
        }];
    } // Else, user tapped to unretweet the tweet
    else {
        // Update to unretweeted; also update retweet count and retweet symbol to unretweeted
        self.tweet.retweeted = NO;
        self.retweetCount.text = [@(--self.tweet.retweetCount) stringValue];
        [sender setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        self.retweetCount.textColor = [UIColor colorWithRed:172/255.0 green:184/255.0 blue:194/255.0 alpha:1];
        
        // Send a POST request to the POST unretweet endpoint
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            } else {
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
        }];
    }
}

@end
