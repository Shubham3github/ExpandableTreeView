//  ViewController.m
//  ExpandableTreeView
//  Created by Vaishali on 12/5/17.
//  Copyright © 2017 VaishaliApp. All rights reserved.

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//@synthesize tableView=_tableView;
//@synthesize mutableArray=_mutableArray;
//@synthesize arrayfortable=_arrayfortable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
    self.arrayOriginal = [dict valueForKey:@"Objects"];
    self.mutableArray = [[NSMutableArray alloc] init];
    [self.mutableArray addObjectsFromArray:self.arrayOriginal];
    NSLog(@"mutableArray");
    self.title=@"Expandable/Collapsable Tree View";
    
}

//---------Customize the number of sections in the table view-----------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

return @"Expandable/Collapsable TableView";

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mutableArray count];
}

//---------Customize the appearance of table view cells------------------//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
 UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
        
        for(NSDictionary *dInner in ar)
        {
            NSInteger index=[self.mutableArray indexOfObjectIdenticalTo:dInner];
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
            for(NSDictionary *abc in ar ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.mutableArray insertObject:abc atIndex:count++];
        }
        [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}
-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(NSDictionary *abc in ar ) {
        NSUInteger indexToRemove=[self.mutableArray indexOfObjectIdenticalTo:abc];
        NSArray *def=[abc valueForKey:@"Objects"];
        if(def && [def count]>0){
            [self miniMizeThisRows:def];
        }
        
        if ([self.mutableArray indexOfObjectIdenticalTo:abc]!=NSNotFound) {
            [self.mutableArray removeObjectIdenticalTo:abc];
            [self.tabelView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
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
