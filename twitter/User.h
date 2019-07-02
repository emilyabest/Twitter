//
//  User.h
//  
//
//  Created by emilyabest on 7/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// Properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;

// Initializer
- (instancetype)initWithDictionary:(NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
