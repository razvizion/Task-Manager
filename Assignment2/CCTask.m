//
//  CCTask.m
//  Assignment2
//
//  Created by Michał Kozak on 19.03.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "CCTask.h"

@implementation CCTask

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self){
        self.title = data[TASK_TITLE];
        self.description = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.isCompleted = [data[TASK_COMPLETION] boolValue];
        
    }
    return self;
}

-(id)init
{
    self = [self initWithData:nil];
    return self;
}

@end
