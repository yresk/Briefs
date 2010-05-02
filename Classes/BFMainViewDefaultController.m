//
//  BFMainViewDefaultController.m
//  Briefs
//
//  Created by Rob Rhyne on 5/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFMainViewDefaultController.h"
#import "BFRefreshBriefCellController.h"
#import "BFBriefcastCellController.h"
#import "BFConfig.h"
#import "BFDataManager.h"
#import "BriefRef.h"

@implementation BFMainViewDefaultController

- (id)init
{
    if (self = [super initWithNibName:@"BFMainViewDefaultController" bundle:nil]) {
        // initialization?
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [BFConfig separatorColorForTableView];
    
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self updateAndReload];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFTableViewController methods

- (void)constructTableGroups
{
    NSMutableArray *briefControllers = [NSMutableArray array];
    NSMutableArray *briefcastController = [NSMutableArray array];
    
    // get most recently viewed briefs
    id<BFBriefDataSource> recentBriefs = [[BFDataManager sharedBFDataManager] briefsSortedAs:BFDataManagerSortByDateOpened limitTo:2];
    if ([recentBriefs numberOfRecords] >= 1) {
        [briefControllers addObject:[[[BFRefreshBriefCellController alloc] initWithBrief:[recentBriefs dataForIndex:0]] autorelease]];
        
        if ([recentBriefs numberOfRecords] >= 2)
            [briefControllers addObject:[[[BFRefreshBriefCellController alloc] initWithBrief:[recentBriefs dataForIndex:1]] autorelease]];
    }
    
    
    // get last opened briefcast
    NSArray *lastOpenedBriefcast = [[BFDataManager sharedBFDataManager] briefcastsSortedAs:BFDataManagerSortByDateOpened limitTo:1];
    if (lastOpenedBriefcast != nil) {
        BFBriefcastCellController *controller = [[[BFBriefcastCellController alloc] initWithBriefcast:[lastOpenedBriefcast objectAtIndex:0]] autorelease];
        [briefcastController addObject:controller];
    }
    
    self.tableGroups = [NSArray arrayWithObjects:briefControllers, briefcastController, nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? @"RECENT BRIEFS" : @"LAST OPENED BRIEFCAST";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? briefHeaderView : briefcastHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? briefHeaderView.frame.size.height : briefcastHeaderView.frame.size.height;
}

///////////////////////////////////////////////////////////////////////////////

@end
