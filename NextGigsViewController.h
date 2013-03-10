//
//  NextGigsViewController.h
//  DJReptile
//
//  Created by Carsten Graf on 10.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGETUrl @"http://reptil1990.funpic.de/getjsongigs.php"

@interface NextGigsViewController : UITableViewController{


NSMutableArray *json;
UIRefreshControl *refreshControl;
}

 -(void) refreshMyTableView;


@end
