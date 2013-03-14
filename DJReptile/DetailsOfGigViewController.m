//
//  DetailsOfGigViewController.m
//  DJReptile
//
//  Created by Carsten Graf on 11.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "DetailsOfGigViewController.h"
#import "MapController.h"

@interface DetailsOfGigViewController ()

@end

@implementation DetailsOfGigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goBack:(id)sender {
    
    HowtoViewController *howto = [[HowtoViewController alloc]init];
    [self.navigationController pushViewController:howto animated:YES];
    
}
@end
