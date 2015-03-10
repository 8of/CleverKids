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

@property (nonatomic, strong) NSString *originalWord;
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSMutableArray *letters;
@property (nonatomic, assign) BOOL puzzleSolved;
@property (weak, nonatomic) IBOutlet UICollectionView *lettersCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareWord];
}

- (void)prepareWord {
    _puzzleSolved = NO;
    /**
     *  Исходное слово, с которым надо будет сравнивать полученное слово при перестановке
     */
    _word = @"ЯБЛОКО";
    
    /**
     Разбивка на буквы
     :returns: получаем массив, где каждый элмент - буква
     */
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[_word length]];
    for (int i=0; i < [_word length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%C", [_word characterAtIndex:i]];
        [characters addObject:ichar];
    }
    
    /**
     *  Расстановка букв в случайном порядке
     */
    NSUInteger count = [characters count];
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [characters exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    
    _letters = characters;
}
/**
 *  Просчёт оступов
 *  Нужно для того, чтобы слово всегда было по центру экрана
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    /**
     *  Ширина квадрата-контейнера для буквы
     */
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
    CharacterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"characterCell"
                                                                        forIndexPath:indexPath];
    /**
     *  Выборка букв из ранее созданного массива
     */
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
    
    NSString *wordToCompare = [_letters componentsJoinedByString:@""];
    
    /**
     *  Проверяем идентичны ли слова
     */
    BOOL isWordtheSame = [wordToCompare isEqualToString:_word];
    
    if (isWordtheSame) {
        _puzzleSolved = YES;
        _doneLabel.hidden = NO;
    }
    
    /**
     *  Здесь надо проверять полученное слово на предмет соответствия оригинальному
     */
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Если задача решена - больше позволять ничего трогать.
     */
    if (_puzzleSolved) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
    canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    /**
     *  Если задача решена - больше позволять ничего трогать.
     */
    if (_puzzleSolved) {
        return NO;
    }
    return YES;
}

@end
