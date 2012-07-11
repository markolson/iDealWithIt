//
//  HomeViewController.m
//  iDealWithIt
//
//  Created by Mark on 7/8/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "HomeViewController.h"
#import "ImageCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize images;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"PlaceHolder", @"PlaceHolder");
        self.tabBarItem.image = [UIImage imageNamed:@"165-glasses-3.png"];
        //images = [@[@"http://i-deal.s3.amazonaws.com/a2828357-b263-4e5c-ac51-ba2247f1a4c7.gif", @"http://i-deal.s3.amazonaws.com/a2b43718-8321-4417-b520-ba2bbcd0fb12.gif", @"http://i-deal.s3.amazonaws.com/f77d9942-ea2f-4705-b9ea-f9d6950ca674.gif"] mutableCopy];
        
        images = [@[@"1341772657.gif", @"1341772033.gif", @"1341760966.gif"] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [images count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell = (ImageCell *) [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:nil options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (ImageCell *) currentObject;
				break;
			}
		}
	}
    NSString *path = [[NSBundle mainBundle] pathForResource:[images objectAtIndex:indexPath.row] ofType:nil];
    
    [cell setImageFromURL:[NSURL fileURLWithPath:path]];
    
	cell.name.text = @"Mark Olson";
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 436;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
