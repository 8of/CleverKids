//
//  ViewController.m
//  CleverKids
//
//  Created by Mega on 10/03/15.
//  Copyright (c) 2015 8of. All rights reserved.
//

#import "ViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "CharacterViewCell.h"

@interface ViewController () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSMutableArray *letters;
@property (weak, nonatomic) IBOutlet UICollectionView *lettersCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareWord];
}

- (void)prepareWord {
    _word = @"Тест";
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[_word length]];
    for (int i=0; i < [_word length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [_word characterAtIndex:i]];
        [characters addObject:ichar];
    }
    _letters = characters;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    NSInteger letterViewWidth = 100;
    NSInteger numberOfCells = [_letters count];
    NSInteger edgeInsets = (self.view.frame.size.width - (numberOfCells * letterViewWidth)) / (numberOfCells - 1);
    
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_lettersCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView
     numberOfItemsInSection:(NSInteger)theSectionIndex {
    NSUInteger lettersCount = [_letters count];
    return lettersCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CharacterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"characterCell" forIndexPath:indexPath];
    
    NSString *letter = _letters[indexPath.row];
    [cell prepareCellWithCharacter:letter];

    return cell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
   willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString *letter = _letters[fromIndexPath.row];
    [_letters removeObjectAtIndex:fromIndexPath.row];
    [_letters insertObject:letter atIndex:toIndexPath.row];
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
    canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}

@end
