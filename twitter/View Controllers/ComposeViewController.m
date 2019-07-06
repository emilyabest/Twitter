//
//  ComposeViewController.m
//  twitter
//
//  Created by emilyabest on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Only allow 280 characters in tweets
    self.composeText.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Set the max character limit
    int charLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newTweet = [self.composeText.text stringByReplacingCharactersInRange:range withString:text];
    
    // The new text should be allowed? True/False
    return newTweet.length < charLimit;
}

/**
 Close screen when close button is tapped.
 */
- (IBAction)didTapClose:(UIBarButtonItem *) sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/**
 Tweet the composed tweet when the user taps tweet. // TODO: composing a tweet sends error
 */
- (IBAction)didTapTweet:(UIBarButtonItem *) sender {
    [[APIManager shared] postStatusWithText:self.composeText.text completion:^(Tweet *tweet, NSError *error) {
        // If text from compose field was successful, the tweet was made
        if (tweet) {
            [self.delegate didTweet:tweet];
            NSLog(@"Compose tweet success!");
        } else {
            NSLog(@"Error composing tweet: %@", error.localizedDescription);
        }
        
        // Close the compose screen
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
