//
//  CCViewController.h
//  Assignment2
//
//  Created by Michał Kozak on 19.03.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAddTaskViewController.h"
#import "CCDetailTaskViewController.h"

@interface CCViewController : UIViewController <CCAddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CCDetailTaskViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *taskObjects;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)addTakBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
