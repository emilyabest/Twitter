//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "User.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            
            // Set cell height
//            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.tableView.rowHeight = 200;
            
            // Reload tableView
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Access next cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    // Fill name, screen name, created at date, text, retweet count and favorite count
    cell.actualName.text = tweet.user.name;
    cell.screenName.text = tweet.user.screenName;
    cell.createdAtDate.text = tweet.createdAtString;
    cell.tweetText.text = tweet.text;
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favoritedCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    // Fill profile image
    NSString *profileURLString = tweet.user.profileURL;
    NSURL *profileURL = [NSURL URLWithString:profileURLString];
    cell.profileImage.image = nil;
    [cell.profileImage setImageWithURL:profileURL];
    
    // NOTE: potentially just need if branches. We'll see when we get to that step
//    // Fill retweet and favorite image buttons
//    if (tweet.retweeted) {
//        // Set image to green retweet
//        init?([named name: @"retweet-icon", in bundle: nil, compatibleWith traitCollection: nil ]): cell.retweetImage;
//    }
//    else {
//        // set image to gray retweet
//    }
//    if (tweet.favorited) {
//        // set image to green favorited
//    }
//    else {
//        // set image to gray favorited
//    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

@end
