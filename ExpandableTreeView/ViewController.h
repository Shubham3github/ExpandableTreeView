//
//  ViewController.h
//  ExpandableTreeView
//
//  Created by Vaishali on 12/5/17.
//  Copyright © 2017 VaishaliApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray *arrayfortable;
@property (nonatomic,retain) NSMutableArray *mutableArray;


//-(void)miniMizeThisRows:(NSArray*)ar;

@end

