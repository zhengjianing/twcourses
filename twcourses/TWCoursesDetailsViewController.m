//
//  TWSectionViewController.m
//  twcourses
//
//  Created by lvjian on 12/21/13.
//  Copyright (c) 2013 xi'an thoughtworks. All rights reserved.
//

#import "TWCoursesDetailsViewController.h"
#import <SDWebImage/SDWebImageManager.h>

@interface TWCoursesDetailsViewController ()

-(void) onRefresh: (id)control;
-(void) refreshView;
@end

@implementation TWCoursesDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void) viewWillAppear:(BOOL)animated {
	
    if (self.courses.isFavoured) {
        
    }
	[self refreshView];
}

- (void) onRefresh: (id)control {
    NSString *name = _courses.name;
    
    [TWCourses findOneByName:name success:^(TWCourses *courses) {
        self.courses = courses;
        if ([control respondsToSelector:@selector(endRefreshing)]) {
            [control endRefreshing];
        }
	}];

}

- (void) refreshView {
	self.navigationItem.title = _courses.name;
	_overviewTextView.text = _courses.overview;
	
	NSString *imagePath = [NSString stringWithFormat:@"%@", _courses.coverImagePath];
	DLog(@"-image path: %@", imagePath);
	NSURL *imageURL = [NSURL URLWithString: imagePath];
	[_coverImageView setImageWithURL: imageURL
					placeholderImage:nil];
        
	[self.chaptersTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _chaptersDetailsViewController = TWController(@"chapter_Storyboard", @"chaptersDetailsViewController");

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.courses.chapters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"SectionTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    
    TWChapter *module = [self.courses.chapters objectAtIndex:indexPath.row];
    cell.textLabel.text = module.name;
	cell.detailTextLabel.text = [module.videoLength stringValueOfMinite];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TWChapter *selectedChapter = [self.courses.chapters objectAtIndex:indexPath.row];

    NSString *name = selectedChapter.name;
    DLog(@"--selected chapter: %@", name);

    _chaptersDetailsViewController.chapter = selectedChapter;
    [self.navigationController pushViewController:_chaptersDetailsViewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)changeFavourStatus:(id)sender {
    _courses.isFavoured = !_courses.isFavoured;

    if (_courses.isFavoured) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favour.add.success", @"添加收藏成功")];
        _addFavourItem.title = @"取消收藏";
        return;
    }
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favour.cancel.success", @"取消收藏成功")];
    _addFavourItem.title = @"收藏";
}
@end
