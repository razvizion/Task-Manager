//
//  CCTask.h
//  Assignment2
//
//  Created by Michał Kozak on 19.03.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTask : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSDate *date;
@property (nonatomic) BOOL isCompleted;

-(id)initWithData:(NSDictionary *)data;

@end
