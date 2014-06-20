//
//  CCDetailTaskViewController.h
//  Assignment2
//
//  Created by Michał Kozak on 19.03.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"
#import "CCEditTaskViewController.h"


@protocol CCDetailTaskViewControllerDelegate <NSObject>

-(void)updateTask;

@end

@interface CCDetailTaskViewController : UIViewController <CCEditTaskViewControllerDelegate>

@property (strong, nonatomic) CCTask *task;
@property (weak,nonatomic) id <CCDetailTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
