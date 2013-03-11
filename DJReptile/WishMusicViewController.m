//
//  WishMusicViewController.m
//  DJReptile
//
//  Created by Carsten Graf on 04.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "WishMusicViewController.h"

@interface WishMusicViewController ()
{

    NSString *NumberOfGenere;
    NSString *Status;
    NSString *Waittime;
    int *GenereValue;
}


@end

@implementation WishMusicViewController

bool isKeyboardVisible = FALSE;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Load!");
    
    [self start];
   
    

	// Do any additional setup after loading the view.
    
}

-(void) getData:(NSData *) data{
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}



-(void) start {
    
    NSURL *url = [NSURL URLWithString:kGETUrl];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self getData:data];
    NSLog(@"Data: %@", data);
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//DEVELOP
- (IBAction)resetTimer:(id)sender {
    
    [self resetTimer];
}
//DEVELOP



- (IBAction)ConfirmAlert:(id)sender

{
     
    [self start];
    
    NSDictionary *info = [json objectAtIndex:0];
    Status = [info objectForKey:@"Status"];
    NSLog(@"Status: %@", Status);
    if ([Status isEqualToString: @"1"]) {
    
    
    if (self.timer != nil || [self.timer isValid]) {
        UIAlertView *waitalert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have to wait!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [waitalert show];
        return;
    }
    
        if ([_txtName.text isEqualToString:@""] || [_txtArtist.text isEqualToString:@"" ] || [_txtTitle.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uncomplete" message:@"Please Fill all the field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else {
            
            
                        
        
        NSString *Alertshow = [NSString stringWithFormat: @"Artist: %@\nTitle: %@" ,_txtArtist.text,_txtTitle.text];
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Right Insert?" message: Alertshow delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
        
        [confirmAlert show];
            
        }
    }
    else{
    
        UIAlertView *statusalert = [[UIAlertView alloc] initWithTitle:@"Disabled" message:@"Musicwish is not active!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [statusalert show];
    
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    
    
    NSDictionary *info = [json objectAtIndex:0];
    Waittime = [info objectForKey:@"Timer"];
    double timervalue = [Waittime doubleValue];
    
    if(buttonIndex == 1)
    {
        if(self.swTimer.on == true) //DEVELOP
        {
        if(self.timer == nil || ![self.timer isValid]) {
            // Allow the action (set the timer interval to what suits your needs)
            self.timer = [NSTimer scheduledTimerWithTimeInterval: timervalue target:self selector:@selector(resetTimer) userInfo:nil repeats:NO];
            NSLog(@"Timer startet for: %f!",timervalue);
            
            //DEVELOP
            self.TimerValue.text = [NSString stringWithFormat:@"%f",timervalue];
            //DEVELOP
        }
        }
        
        NSString *insertName = [_txtName.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *insertTitle = [_txtTitle.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *insertArtist = [_txtArtist.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        
        NSString *strURL = [NSString stringWithFormat:@"http://reptil1990.funpic.de/phpFile.php?Name=%1@&Artist=%2@&Titel=%3@&Genere=%d",insertName,insertArtist,insertTitle, [self.secGenere selectedSegmentIndex]];
    
        NSLog(@"%@", strURL);
    
        // to execute php code
        NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
        // to receive the returend value
        NSString *strResult = [[NSString alloc] initWithData:dataURL encoding: NSUTF8StringEncoding];
    

        if ([strResult isEqualToString:@"success"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succsess" message:@"Your wish is send! Tank You!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            _txtName.text = nil;
            _txtArtist.text = nil;
            _txtTitle.text = nil;
            NSLog(@"%@", strResult);

            
        }
        else
            {
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went Wrong! Sorry!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert2 show];
                
                [self resetTimer];
            }
        
        }
        
    }
//DEVELOP
- (void)resetTimer
{
    self.timer = nil;
    [self.timer invalidate];
    NSLog(@"Timer Reset");
}
//DEVELOP

- (IBAction)hideKeyboard:(id)sender
{

[sender resignFirstResponder];

}



@end
