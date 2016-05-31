//
//  ViewController.m
//  Deprocastrinator
//
//  Created by Andrew Bihl on 5/31/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isEditing;
@property NSMutableArray* tableValues;
@property NSMutableArray* tableColors;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableValues = [NSMutableArray new];
    self.tableColors = [NSMutableArray new];

}
- (IBAction)onRightSwipe:(UISwipeGestureRecognizer*)sender {
    NSLog(@"Swiped right");
    UITableViewCell* swipedCell = (UITableViewCell*)sender.view;
    NSIndexPath* swipedCellPath = [self.tableView indexPathForCell:swipedCell];
    UIColor* currentColor = [self.tableColors objectAtIndex:swipedCellPath.row];
    //Cycle colors if already colored.
    if (currentColor==[UIColor greenColor])
        [self.tableColors replaceObjectAtIndex:swipedCellPath.row withObject:[UIColor orangeColor]];
    else if (currentColor == [UIColor orangeColor])
        [self.tableColors replaceObjectAtIndex:swipedCellPath.row withObject:[UIColor redColor]];
    else if (currentColor == [UIColor redColor])
        [self.tableColors replaceObjectAtIndex:swipedCellPath.row withObject:[UIColor greenColor]];
    
    [self.tableView reloadData];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.tableValues removeObjectAtIndex:indexPath.row];
        [self.tableColors removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEditing){
        [self.tableValues removeObjectAtIndex:indexPath.row];
        [self.tableColors removeObjectAtIndex:indexPath.row];
    }
    else{
        if ([self.tableColors objectAtIndex:indexPath.row]==[UIColor blackColor])
            [self.tableColors replaceObjectAtIndex:indexPath.row withObject:[UIColor greenColor]];
        else
            [self.tableColors replaceObjectAtIndex:indexPath.row withObject:[UIColor blackColor]];
    }
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.tableValues objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [self.tableColors objectAtIndex:indexPath.row];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableValues.count;
    
}
- (IBAction)onAddButtonPressed:(id)sender {
    NSString* newCellText = self.textField.text;
    self.textField.text =  @"";
    [self.view endEditing:true];
    [self.tableValues addObject:newCellText];
    [self.tableView reloadData];
    [self.tableColors addObject:[UIColor blackColor]];
}
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    
    [self.tableView setEditing:!self.tableView.editing];
    if (self.isEditing){
        sender.title = @"Edit";
        self.isEditing = false;
    }
    else{
        sender.title = @"Done";
        self.isEditing = true;
    }
    
}



@end
