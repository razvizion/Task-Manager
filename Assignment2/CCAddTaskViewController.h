//
//  CCAddTaskViewController.h
//  Assignment2
//
//  Created by Michał Kozak on 19.03.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"

@protocol CCAddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(CCTask *)task;

@end


@interface CCAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak,nonatomic) id <CCAddTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
