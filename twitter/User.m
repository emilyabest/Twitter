//
//  User.m
//  
//
//  Created by emilyabest on 7/1/19.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileURL = dictionary[@"profile_image_url_https"];
    }
    return self;
}

@end
