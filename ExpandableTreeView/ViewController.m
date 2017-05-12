//
//  ViewController.m
//  ExpandableTreeView
//
//  Created by Vaishali on 12/5/17.
//  Copyright © 2017 VaishaliApp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

@synthesize tableView;
@synthesize mutableArray;
@synthesize arrayfortable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"]];
    self.arrayfortable = [dict valueForKey:@"Objects"];
    self.mutableArray = [[NSMutableArray alloc] init];
    [self.mutableArray addObjectsFromArray:self.arrayfortable];
    self.title=@"Expandable/Collapsable Tree View";

}

//---------Customize the number of sections in the table view-----------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mutableArray count];
}

//---------Customize the appearance of table view cells------------------//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    cell.textLabel.text=[[self.mutableArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell setIndentationLevel:[[[self.mutableArray objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *d=[self.mutableArray objectAtIndex:indexPath.row];
    if([d valueForKey:@"Objects"]) {
        NSArray *ar=[d valueForKey:@"Objects"];
        
        BOOL isAlreadyInserted=NO;
        
        for(NSDictionary *abc in ar )
        {
            NSInteger index=[self.mutableArray indexOfObjectIdenticalTo:abc];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted)
                break;
        }
        
        if(isAlreadyInserted)
        {
            [self miniMizeThisRows:ar];
        }
        else
        {
           NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(NSDictionary *def in ar ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.mutableArray insertObject:def atIndex:count++];
        }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}
-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(NSDictionary *dInner in ar ) {
        NSUInteger indexToRemove=[self.mutableArray indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"Objects"];
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        
        if([self.mutableArray indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
            [self.mutableArray removeObjectIdenticalTo:dInner];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                         [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                         ]
                                       withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
