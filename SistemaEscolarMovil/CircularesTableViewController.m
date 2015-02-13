//
//  CircularesTableViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "CircularesTableViewController.h"
#import "ElementoEscolar.h"

@interface CircularesTableViewController ()
@property JSONHTTPClient *jsonClient;
@end

@implementation CircularesTableViewController

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response{
    self.elementsData = response;
    [[self tableView] reloadData];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readCircular" withOptions:nil];
    //http://192.168.100.36:8080/SistemaEscolar/readCircular?mobile=true
    
    
    // Do any additional setup after loading the view, typically from a nib.

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.elementsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row]  fecha]
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    dateString = [NSString stringWithFormat:@"Fecha de Publicación: %@" ,dateString];
    
    
    UILabel *titulo =(UILabel*)[cell.contentView viewWithTag:1];
    UILabel *fecha =(UILabel*)[cell.contentView  viewWithTag:2];
    UILabel *remitente =(UILabel*)[cell.contentView  viewWithTag:3];

    
    
    // Configure the cell...
    [titulo setText:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] titulo]];
    [fecha setText: dateString];
    fecha.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    [remitente setText:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] remitente]];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
