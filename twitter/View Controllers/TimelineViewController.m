//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18. Edited by Emily Best.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "User.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;

// [1] View controller has a tableView as a subview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize table view
    // [3] View controller becomes its (table view cell) dataSource and delegate in viewDidLoad
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Fill the tweets initially
    [self fetchTweets];
    
    // Refresh the tweets when the user pulls down
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

/**
 Gets a list of tweets. Makes a network request to get updated data. Updates the tableView with the new data. Hides the RefreshControl.
 */
- (void)fetchTweets {
    // Get timeline
    // [4] Make an API request
    // [5] API manager calls the completion handler passing back data
    [[APIManager shared] getHomeTimelineWithParam: nil WithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            // [6] View controller stores that data passed into the completion handler
            self.tweets = [NSMutableArray arrayWithArray: tweets];
            
            // Reload tableView with new data
            // [7] Reload the table view
            // [8] Table view asks its dataSource for numberOfRows & cellForRowAt (within its reloadData method)
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        // Tell the refreshControl to stop spinning
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

/**
 Set the TimelineViewController as the delegate of the ComposeViewController
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
    
}

// [9] numberOfRows returns the number of items returned from the API
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

// [10] cellForRow returns an instance of the custom cell with that reuse identifier with it’s elements populated with data at the index asked for
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Access next cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    // Fill name, screen name, created at date, text, retweet count and favorite count
    cell.tweet = tweet;
    cell.actualName.text = tweet.user.name;
    cell.screenName.text = [NSString stringWithFormat:@"%@%@", @"@", tweet.user.screenName];
    cell.createdAtDate.text = tweet.createdAtString;
    cell.tweetText.text = tweet.text;
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favoritedCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    // Fill retweet and favorite icons; also update count font colors
    if (cell.tweet.favorited) {
        [cell.favoritedButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        cell.favoritedCount.textColor = [UIColor colorWithRed:210/255.0 green:57/255.0 blue:78/255.0 alpha:1];
    } else {
        [cell.favoritedButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        cell.favoritedCount.textColor = [UIColor colorWithRed:172/255.0 green:184/255.0 blue:194/255.0 alpha:1];
    }
    if (cell.tweet.retweeted) {
        [cell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        cell.retweetCount.textColor = [UIColor colorWithRed:94/255.0 green:205/255.0 blue:138/255.0 alpha:1];;
    } else {
        [cell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        cell.retweetCount.textColor = [UIColor colorWithRed:172/255.0 green:184/255.0 blue:194/255.0 alpha:1];
    }
    
    // Fill profile image
    NSString *profileURLString = tweet.user.profileURL;
    NSURL *profileURL = [NSURL URLWithString:profileURLString];
    cell.profileImage.image = nil;
    [cell.profileImage setImageWithURL:profileURL];
    
    return cell;
}

/**
 The user tweeted something, add their tweet to the list of tweets
 */
- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

/**
 The user tapped logout
 */
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

/**
 Used to implement infinite scroll.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        
        // Calculate the position of one  screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = YES;
            
            // Start activity indicator
            [self.refreshControl addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventValueChanged];
            [self.tableView insertSubview:self.refreshControl atIndex:0];
            
            [self loadMoreData];
        }
    }
}

/**
Helper method for scrollViewDidScroll. Gets more data to add cells to the bottom.
 */
- (void)loadMoreData {
    // Parameter to pass in
    Tweet *lastTweet = [self.tweets lastObject];

    // Convert String id to NSNumber
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *numID = [f numberFromString:lastTweet.idStr];
    
    // Update to make id exclusive
    long strToLong = [numID longValue];
    long actualID = strToLong - 1;
    NSNumber *maxID = @(actualID);

    NSDictionary *parameter = @{@"max_id": maxID};
    // Get timeline
    [[APIManager shared] getHomeTimelineWithParam: (NSDictionary *) parameter WithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.isMoreDataLoading = NO;
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        // Tell the refreshControl to stop spinning
        [self.refreshControl endRefreshing];
    }];
}

@end
