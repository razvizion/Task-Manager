//
//  CCViewController.m
//  Assignment2
//
//  Created by Michał Kozak on 19.03.2014.
//  Copyright (c) 2014 Raz Labs. All rights reserved.
//

#import "CCViewController.h"
#import "CCDetailTaskViewController.h"

@interface CCViewController ()

@end

@implementation CCViewController

-(NSMutableArray *)taskObjects{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc]init];
    }
    return _taskObjects;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults]arrayForKey:TASK_OBJECTS_KEY];
    for (NSDictionary *dictionary in tasksAsPropertyLists) {
        CCTask *taskObject = [self taskObjectForDictionary:dictionary];
        [self.taskObjects addObject:taskObject];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CCAddTaskViewController class]]){
        CCAddTaskViewController *addTaskViewController = segue.destinationViewController;
        addTaskViewController.delegate = self;
    }
    else if([segue.destinationViewController isKindOfClass:[CCDetailTaskViewController class]]){
        CCDetailTaskViewController *detailTaskViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        CCTask *taskObject = self.taskObjects[path.row];
        detailTaskViewController.task = taskObject;
        
        detailTaskViewController.delegate=self;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender {
    if(self.tableView.editing == YES){
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)addTakBarButtonItemPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

#pragma mark - CCAddTaskViewControllerDelegate

-(void)didAddTask:(CCTask *)task{
    [self.taskObjects addObject:task];
    
    NSLog(@"%@",task.title);
    
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    if(!taskObjectsAsPropertyLists){
        taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    }
    [taskObjectsAsPropertyLists addObject:[self taskObjectsAsPropertyList:task]];
    [[NSUserDefaults standardUserDefaults]setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}
-(void)didCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - CCDetailTaskViewControllerDelegate

-(void)updateTask{
    [self saveTasks];
    [self.tableView reloadData];
}

#pragma mark - helper methods

-(NSDictionary *)taskObjectsAsPropertyList:(CCTask *)taskObject{
    NSDictionary *dictionary = @{TASK_TITLE: taskObject.title,TASK_DESCRIPTION: taskObject.description, TASK_DATE: taskObject.date, TASK_COMPLETION: @(taskObject.isCompleted)};
    return dictionary;
}
-(CCTask *)taskObjectForDictionary:(NSDictionary *)dictionary{
    CCTask *taskObject = [[CCTask alloc]initWithData:dictionary];
    return taskObject;
}
-(BOOL)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate{
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    NSTimeInterval toDateInterval = [toDate timeIntervalSince1970];
    
    if(dateInterval > toDateInterval){
        return YES;
    }else{
        return NO;
    }
}
-(void)updateCompletionOfTask:(CCTask *)task forIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    if(!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    if(task.isCompleted == YES) task.isCompleted = NO;
    else task.isCompleted = YES;
    [taskObjectsAsPropertyLists insertObject:[self taskObjectsAsPropertyList:task]  atIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.tableView reloadData];
}

-(void)saveTasks{
    NSMutableArray *taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    for (int x = 0; x<[self.taskObjects count]; x++){
        [taskObjectsAsPropertyLists addObject:[self taskObjectsAsPropertyList:self.taskObjects[x]]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.taskObjects count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    CCTask *task = [self.taskObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    cell.detailTextLabel.text = stringFromDate;
    
    BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    if(isOverDue == YES) cell.backgroundColor = [UIColor redColor];
    else cell.backgroundColor = [UIColor yellowColor];
    
    if(task.isCompleted) cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCTask *task = self.taskObjects[indexPath.row];
    [self updateCompletionOfTask:task forIndexPath:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        NSMutableArray *newTaskObjectsData = [[NSMutableArray alloc]init];
        for (CCTask *task in self.taskObjects){
            [newTaskObjectsData addObject:[self taskObjectsAsPropertyList:task]];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newTaskObjectsData forKey:TASK_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    CCTask *taskObject = [self.taskObjects objectAtIndex:sourceIndexPath.row];
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    [self saveTasks];
}


@end
