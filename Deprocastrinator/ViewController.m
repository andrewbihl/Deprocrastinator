//
//  ViewController.m
//  Deprocastrinator
//
//  Created by Andrew Bihl on 5/31/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* tableValues;

@end

@implementation ViewController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.tableValues]
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)onAddButtonPressed:(id)sender {
    NSString* newCellText = self.textField.text;
    self.textField.text =  @"";
    [self.view endEditing:true];
    [self.tableValues addObject:newCellText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
