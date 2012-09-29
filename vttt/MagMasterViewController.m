
//
//  MagMasterViewController.m
//  vttt
//
//  Created by Grails on 24/08/12.
//  Copyright (c) 2012 algos. All rights reserved.


#import "MagMasterViewController.h"
#import "MagDetailViewController.h"
#import "MagAggiungiArticoloViewController.h"

#import "Articolo.h"

#import "LibArticolo.h"
#import "LibPlist.h"

@interface MagMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

static BOOL mostraIcone = false;

static BOOL vistaArticoli = NO;
static BOOL vistaArticoliDB = YES;
static BOOL vistaArticoliDbInCategory = NO;
static BOOL debugMode = NO;

static BOOL alfabeticOrder;
static BOOL mostraTotaleArticloli;

static NSString * const NamePlist = @"articoli";
static NSString * const TableName = @"Articoli";
static NSString * const CellIdentifier = @"Cell";

NSString * const NAME_FIRST_BUTTON = @"Az";
NSString * const NAMe_SECOND_BUTTON = @"Category";
NSString * const NAME_THIRD_BUTTON = @"Aggiorna";


@implementation MagMasterViewController

@synthesize articoliAz;
@synthesize typeListButton;
@synthesize changeTypeListButton;
@synthesize dicArticoli;
@synthesize category;
@synthesize db;


#pragma mark- Life Cile
- (void)awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad {
    //Apro DB
    [self openDB];
    
    //-- Creo e Riempio la tabella Articoli con 3 oggetti.
    [self insertDefaultArticles];

    // Titolo della colonna di sinistra
    self.navigationItem.title = NSLocalizedString(@"Lista", @"Lista");
    
    [self loadSettings];
        
    // Setting of Segmented Control
    [self setSegmentedControl];
    
    if (alfabeticOrder)
        [self regolaVista:alfabeticOrder];

    else {
        
        vistaArticoliDbInCategory = YES;
        [self regolaVista:NO];

    }    
        
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (MagDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [super viewDidLoad];

}

- (void)viewDidUnload {
    [self setTypeListButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (alfabeticOrder) {
        
        if (!vistaArticoli) {
            [self regolaVista:alfabeticOrder];

        }
        return 1;
    }
    else {
        
        return [self.categoryArticoli count];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (alfabeticOrder) {
        
        return [articoliAz count];
    }
    else {
        
        NSString * categoryTemp = [self.categoryArticoli objectAtIndex:section];
        NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
        return [articoliTemp count];
    }
}

#warning OTTIMIZZO QUESTO METODO
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (alfabeticOrder && vistaArticoli) {

            Articolo *art = [articoliAz objectAtIndex:indexPath.row];
            cell.textLabel.text = [art code];
    }
    
    else if (alfabeticOrder) {
        
        Articolo *art = [articoliAz objectAtIndex:indexPath.row];
        cell.textLabel.text = art.code;
    }

    else {
        
        NSString *categoryTemp = [self.categoryArticoli objectAtIndex:[indexPath section]];
        NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
        if (vistaArticoliDbInCategory) {
            
            Articolo *art = [articoliTemp objectAtIndex:[indexPath row]];
            cell.textLabel.text = art.code;
        }
        else
            cell.textLabel.text = [articoliTemp objectAtIndex:[indexPath row]];
    }
    
    //--- Mostra Icone
    if (mostraIcone) {
        
        [self setCellWithDefaultImageWithCell:cell indexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#warning OTTIMIZZARE QUESTO METODO
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if (!self.detailViewController) {
            
            self.detailViewController = [[MagDetailViewController alloc] initWithNibName:@"MagDetailViewController" bundle:nil];;
        }
        //self.detailViewController.detailItem = [NSString stringWithFormat:@"%@", [dicArticoli objectAtIndex:indexPath.row]];
        
        if (articoliAz) {
            //if (vistaArticoli) {
  
                Articolo *art = [articoliAz objectAtIndex:indexPath.row];
                //-- Disabilito l'editing x i textField
                [self.detailViewController.codeTextField setEnabled:NO];
                [self.detailViewController.nameTextField setEnabled:NO];
                [self.detailViewController.categoryTextField setEnabled:NO];
                [self.detailViewController.descritpionTextField setEnabled:NO];
                [self.detailViewController.priceTextField setEnabled:NO];

                //-- Riempio i textField.
                self.detailViewController.codeTextField.text = [NSString stringWithFormat:@"%@", [art code]];
                self.detailViewController.nameTextField.text = [NSString stringWithFormat:@"%@", [art name]];
                self.detailViewController.categoryTextField.text = [NSString stringWithFormat:@"%@", [art category]];
                self.detailViewController.descritpionTextField.text = [NSString stringWithFormat:@"%@", [art description]];
                self.detailViewController.priceTextField.text = [NSString stringWithFormat:@"%@",[art price]];


           /* }
            else
                self.detailViewController.detailItem = [NSString stringWithFormat:@"%@", [articoliAz objectAtIndex:indexPath.row]];*/

        }
        else {

            NSString *categoryTemp = [self.categoryArticoli objectAtIndex:indexPath.section];
            NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
            if (vistaArticoliDbInCategory) {
                
                Articolo *art = [articoliTemp objectAtIndex:indexPath.row];
                //-- Disabilito l'editing x i textField
                [self.detailViewController.codeTextField setEnabled:NO];
                [self.detailViewController.nameTextField setEnabled:NO];
                [self.detailViewController.categoryTextField setEnabled:NO];
                [self.detailViewController.descritpionTextField setEnabled:NO];
                [self.detailViewController.priceTextField setEnabled:NO];
                
                //-- Riempio i textField.
                self.detailViewController.codeTextField.text = [NSString stringWithFormat:@"%@", [art code]];
                self.detailViewController.nameTextField.text = [NSString stringWithFormat:@"%@", [art name]];
                self.detailViewController.categoryTextField.text = [NSString stringWithFormat:@"%@", [art category]];
                self.detailViewController.descritpionTextField.text = [NSString stringWithFormat:@"%@", [art description]];
                self.detailViewController.priceTextField.text = [NSString stringWithFormat:@"%@",[art price]];

            }//end if
            else {
                NSObject *obj = [articoliTemp objectAtIndex:indexPath.row];
                self.detailViewController.detailItem = [NSString stringWithFormat:@"%@", obj];
            }
        }
        
        //[dicArticoli objectForKey:indexPath.section];
       // self.detailViewController.detailItem = @"";
        //NSObject *obj= [NSString stringWithFormat:@"%@", [articoliAz objectAtIndex:indexPath.section]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (alfabeticOrder) {
        
        return @"Lista articoli";
    } else {
        
        NSString *categoryTemp = [self.categoryArticoli objectAtIndex:section];
        NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
        
        //--- Se nella Sezione non ci sono articoli, non la mostro.
        if (articoliTemp.count == 0) {
            
            categoryTemp = @"";
        }
        
        return categoryTemp;
        
    }
}

//--display the footer--
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if (alfabeticOrder & mostraTotaleArticloli) {
        NSInteger articoliNum = [articoliAz count];
        return[[NSString alloc] initWithFormat:@"Nel magazzino ci sono %d articoli", articoliNum];
        
    } else {
        return nil;
    }
}

//--indenting each row--
//--non funziona--
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath row] % 2;
}

//--heiht of each row--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
    //return 40 + 30 * ([indexPath row] % 2);
}

#warning QUI X PASSARE AL DETAIL
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *categoryName = [self.categoryArticoli objectAtIndex:indexPath.section];
        NSArray *arrayArt = [self.articoli objectForKey:categoryName];
        Articolo *art = [arrayArt objectAtIndex:[indexPath row]];

        
        [[segue destinationViewController] setDetailItem:art];
    }
}

//--display the header--

#pragma mark - Change List Methods

- (void)toggleTypeListButton {
    UIImage* icon;
    
    if (alfabeticOrder) {
        
        icon = [UIImage imageNamed:@"Ukraine.png"];
        [typeListButton setTitle:@"+"];
        [self regolaVista:TRUE];
        alfabeticOrder = FALSE;
    } else {
        
        icon = [UIImage imageNamed:@"Romania.png"];
        [typeListButton setTitle:@"-"];
        [self regolaVista:FALSE];
        alfabeticOrder = TRUE;
    }
    
    //Fa il refresh
    [self.tableView reloadData];
    //[typeListButton setImage:icon];
}

- (void)regolaVista:(BOOL)alfabetic {
    
    if (alfabetic) {
            self.articoliAz = [self getAllArticoli];
    }
    else {
        
        self.articoliAz = nil;
        self.dicArticoli = [LibArticolo creaVistaCategoryWithArray:[self getAllArticoli]];
        self.articoli = dicArticoli;
        NSLog(@"dicArticoli = %@", self.dicArticoli.description);
        NSLog(@"articoli = %@", self.articoli.description);

        self.categoryArticoli = [[self.dicArticoli allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSLog(@"categoryArticoli = %@", self.categoryArticoli.description);

    }
}

- (IBAction)pressChageTypeListButton:(id)sender {
        
    [self chageViewOrderWithPosition:[self.changeTypeListButton selectedSegmentIndex]];

}

- (void)chageViewOrderWithPosition:(int)posizione{ 
    
    switch (posizione)  {
        case 0:
            
            alfabeticOrder = TRUE;
            vistaArticoli = NO;
            vistaArticoliDbInCategory = FALSE;
            [self regolaVista:alfabeticOrder];

            break;
            
        case 1:
            
            alfabeticOrder = FALSE;
            vistaArticoli = FALSE;
            vistaArticoliDbInCategory = TRUE;
            [self regolaVista:alfabeticOrder];
            break;

        case 2:
            
            [self.tableView reloadData];
            [self inserisciNuovoArticoloNelDb];
            break;
            
            
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void) inserisciNuovoArticoloNelDb {
    
    NSDictionary *dic = [LibPlist readPlistName:[MagAggiungiArticoloViewController plistName]];
    
    [self insertRecordIntoNamed:TableName codeValue:[dic objectForKey:[MagAggiungiArticoloViewController keyCode]] nameValue:[dic objectForKey:[MagAggiungiArticoloViewController keyName]] categoryValue:[dic objectForKey:[MagAggiungiArticoloViewController keyCategory]] descriptionValue:[dic objectForKey:[MagAggiungiArticoloViewController keyDescription]] priceValue:[dic objectForKey:[MagAggiungiArticoloViewController keyPrice]]];
}

- (NSArray *)viewDB {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM %@", TableName];
    sqlite3_stmt *statment;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            char *field1 = (char *) sqlite3_column_text(statment, 1);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            NSString *str = [[NSString alloc] initWithFormat:@"%@", field1Str];
            NSLog(@"%@", str);
            [array addObject:str];
        }
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    
    
    return array;
}

#pragma mark - Settings Mehods

- (void)loadSettings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    alfabeticOrder = [self convertIntegerToBoolean:[defaults objectForKey:@"alfabeticOrder"]];
    NSLog(@"AlfabeticOrder = %d", (int)alfabeticOrder);
    mostraTotaleArticloli = [self convertIntegerToBoolean:[defaults objectForKey:@"mostraTotaleArticoli"]];
    NSLog(@"MostraTotaleArticoli = %d", (int)mostraTotaleArticloli);

}

- (BOOL)convertIntegerToBoolean:(id)integerValue {
    
    return [integerValue boolValue];

}

#pragma mark - Init Methods

- (void)setSegmentedControl {
    //--- Abilito il click su tutti i bottoni del Segmented Control
    [self.changeTypeListButton setEnabled:YES forSegmentAtIndex:0];
    [self.changeTypeListButton setEnabled:YES forSegmentAtIndex:1];
    [self.changeTypeListButton setEnabled:YES forSegmentAtIndex:2];

    //--- Inserisco i titoli su tutti i bottini del Segmented Control
    [self.changeTypeListButton setTitle:NAME_FIRST_BUTTON forSegmentAtIndex:0];
    [self.changeTypeListButton setTitle:NAMe_SECOND_BUTTON forSegmentAtIndex:1];
    [self.changeTypeListButton setTitle:NAME_THIRD_BUTTON forSegmentAtIndex:2];
    
    //--- Dico quale section selezione in base alla fista di default
    switch (alfabeticOrder) {
        case TRUE:
            
            [self.changeTypeListButton setSelectedSegmentIndex:0];
            break;
            
        case FALSE:
            
            [self.changeTypeListButton setSelectedSegmentIndex:1];
            break;
            
        default:
            
            [self.changeTypeListButton setSelectedSegmentIndex:2];
            break;
    }
}

- (UITableViewCell *)setCellWithDefaultImageWithCell :(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    UIImage *image;
    switch (indexPath.row) {
        case 1:
            image = [UIImage imageNamed:@"Ukraine.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"Brazil.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"Switzerland.png"];
            break;
            
        default:
            image = [UIImage imageNamed:@"Belgium.png"];
            break;
    }
    cell.imageView.image = image;
    return cell;
}

#pragma mark - Database Methods

- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
}

- (void) openDB {
    
    //-- Create Database --
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Database falied to open.");
    }
}

- (void) insertDefaultArticles {
    
    [self createTableNamed:@"Articoli" withCode:@"code" withName:@"name" withCateogry:@"category" withDescription:@"description" withPrice:@"price"];
    
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"001" nameValue:@"Rossa" categoryValue:@"Vernici" descriptionValue:@"Vernice Rossa" priceValue:@"54€"];
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"002" nameValue:@"Verde" categoryValue:@"Vernici" descriptionValue:@"Vernice Verde" priceValue:@"90€"];
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"003" nameValue:@"Gialla" categoryValue:@"Vernici" descriptionValue:@"Vernice Gialla" priceValue:@"110€"];
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"004" nameValue:@"Gialla" categoryValue:@"Cacca" descriptionValue:@"Vernice Gialla" priceValue:@"110€"];
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"005" nameValue:@"Gialla" categoryValue:@"Puppu" descriptionValue:@"Vernice Gialla" priceValue:@"110€"];
    
}

- (void)createTableNamed:(NSString *)tableName withCode:(NSString *)code withName:(NSString *)name withCateogry:(NSString *)cateogry withDescription:(NSString *)descritpion withPrice:(NSString *)price;{
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, code, name, cateogry, descritpion, price];
    
    if (sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Database falied create.");
    }
}

- (void) insertRecordIntoNamed:(NSString *)tableName codeValue:(NSString *)codeValue nameValue:(NSString *)nameValue categoryValue:(NSString *)categoryValue descriptionValue:(NSString *)descriptionValue priceValue:(NSString *)priceValue {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('code', 'name', 'category', 'description', 'price') "
                     "VALUES ('%@','%@','%@','%@','%@')", tableName, codeValue, nameValue, categoryValue, descriptionValue, priceValue];
    
    
    char *err;
    if (sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Error Updating table. '%s'", err);
    }
}


- (NSArray *)getAllArticoli {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM Articoli"];
    sqlite3_stmt *statment;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            Articolo *art = [[Articolo alloc] init];

            char *field1 = (char *) sqlite3_column_text(statment, 0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statment, 1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            
            char *field3 = (char *) sqlite3_column_text(statment, 2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            
            char *field4 = (char *) sqlite3_column_text(statment, 3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            
            char *field5 = (char *) sqlite3_column_text(statment, 4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            
            [art setCode:field1Str];
            [art setName:field2Str];
            [art setCategory:field3Str];
            [art setDescription:field4Str];
            
            [tempArray addObject:(Articolo *)art];
        }
        //[self creaVistaCategoryWithArray:tempArray];
        
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    return tempArray;
}
@end
