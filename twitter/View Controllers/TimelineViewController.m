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
//            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
            
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
    
    // Fill name, screen name, created at date, and text
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.actualName.text = tweet.user.name;
    cell.screenName.text = tweet.user.screenName;
    cell.createdAtDate.text = tweet.createdAtString;
    cell.tweetText.text = tweet.text;
    
//    // Fill profile image
//    NSString *profileURLString = tweet[@"profile_image_url_https"];
//    tweet.
//    NSURL *profileURL = [NSURL URLWithString:profileURLString];
//    cell.profileImage.image = nil;
//    [cell.profileImage setImageWithURL:profileURL];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

@end
