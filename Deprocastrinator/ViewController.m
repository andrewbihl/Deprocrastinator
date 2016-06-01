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
@property NSMutableArray* tableValues;
@property NSMutableArray* tableColors;
@property NSIndexPath* rightSwipeStart;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIGestureRecognizer* cur in self.view.gestureRecognizers){
        cur.cancelsTouchesInView = false;
    }
    self.tableValues = [NSMutableArray new];
    self.tableColors = [NSMutableArray new];

}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (IBAction)onSwipeCell:(UIPanGestureRecognizer*)sender {
    if (self.tableView.isEditing)
        return;
    if ([sender translationInView:self.tableView].x < 0)
        return;
    NSIndexPath* cellPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
    if (sender.state == UIGestureRecognizerStateBegan)
        self.rightSwipeStart = cellPath;
    else if (sender.state == UIGestureRecognizerStateEnded && cellPath==self.rightSwipeStart){
        NSLog(@"Right-swipe completed");
        if ([self.tableColors objectAtIndex:cellPath.row]==[UIColor greenColor])
            [self.tableColors replaceObjectAtIndex:cellPath.row withObject:[UIColor orangeColor]];
        else if ([self.tableColors objectAtIndex:cellPath.row]==[UIColor orangeColor])
            [self.tableColors replaceObjectAtIndex:cellPath.row withObject:[UIColor redColor]];
        else if ([self.tableColors objectAtIndex:cellPath.row]==[UIColor redColor])
            [self.tableColors replaceObjectAtIndex:cellPath.row withObject:[UIColor greenColor]];
        [self.tableView reloadData];
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSLog(@"Left-swipe completed");
        UIAlertController* deleteConfirm = [UIAlertController alertControllerWithTitle:@"Delete Entry?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* deleteEntry = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
            [self.tableValues removeObjectAtIndex:indexPath.row];
            [self.tableColors removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
            [self.tableView setEditing:false];
            
        }];
        [deleteConfirm addAction:cancelAction];
        [deleteConfirm addAction:deleteEntry];
        [self presentViewController:deleteConfirm animated:true completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.tableColors objectAtIndex:indexPath.row]==[UIColor blackColor])
        [self.tableColors replaceObjectAtIndex:indexPath.row withObject:[UIColor greenColor]];
    else
        [self.tableColors replaceObjectAtIndex:indexPath.row withObject:[UIColor blackColor]];
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
    
    NSString* myString = [self.tableValues objectAtIndex:sourceIndexPath.row];
    [self.tableValues removeObjectAtIndex:sourceIndexPath.row];
    [self.tableValues insertObject:myString atIndex:destinationIndexPath.row];
    
    UIColor* myColor = [self.tableColors objectAtIndex:sourceIndexPath.row];
    [self.tableColors removeObjectAtIndex:sourceIndexPath.row];
    [self.tableColors insertObject:myColor atIndex:destinationIndexPath.row];
 
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
    
    if (self.tableView.isEditing){
        sender.title = @"Edit";
        [self.tableView setEditing:false];
    }
    else{
        sender.title = @"Done";
        [self.tableView setEditing:true];
    }
    
}



@end
