//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "DivvyDataManager.h"
#import "DivvyStation.h"
#import "MapViewController.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, DivvyDataDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property bool isFiltered;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property DivvyDataManager *dataManager;
@property NSMutableArray *divvyStations;
@property NSMutableArray *filteredDivvyList;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFiltered = NO;
    self.dataManager = [[DivvyDataManager alloc] initWithURL];
    self.dataManager.delegate = self;
    self.searchBar.delegate = self; 
    self.divvyStations = [NSMutableArray new];
    [self.dataManager requestData];
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltered) {
        return self.filteredDivvyList.count;
    }
    else
    return self.divvyStations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    DivvyStation* divvy;
    if(self.isFiltered){
        divvy = [self.filteredDivvyList objectAtIndex:indexPath.row];
    }
    else{
        divvy = [self.divvyStations objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = divvy.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%li", divvy.bikesAvailable];
    cell.tag = indexPath.row;
    return cell;
}

-(void)getDivvyData:(id)data{
    self.divvyStations = data;
    NSLog(@"%li",self.divvyStations.count);
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender{
    if ([segue.identifier isEqualToString:@"ToMapSegue"]){
        MapViewController *mvc = [segue destinationViewController];
        mvc.divvyStation = self.divvyStations[sender.tag];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";

    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0)
    {
        self.isFiltered = FALSE;
    }
    else
    {
        self.isFiltered = true;
        self.filteredDivvyList = [[NSMutableArray alloc] init];

        for (DivvyStation* divvy in self.divvyStations)
        {
            NSRange nameRange = [divvy.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.filteredDivvyList addObject:divvy];
            }
        }
    }

    [self.tableView reloadData];
}


@end
