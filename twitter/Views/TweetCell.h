//
//  TweetCell.h
//  twitter
//
//  Created by emilyabest on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *actualName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *createdAtDate;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoritedCount;
@property (weak, nonatomic) IBOutlet UIButton *favoritedButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@property (strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
