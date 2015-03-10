//
//  CharacterViewCell.m
//  CleverKids
//
//  Created by Mega on 10/03/15.
//  Copyright (c) 2015 8of. All rights reserved.
//

#import "CharacterViewCell.h"

@interface CharacterViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *letterLabel;

@end

@implementation CharacterViewCell

- (void)prepareCellWithCharacter:(NSString *)character {
    _letterLabel.text = character;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    _letterLabel.preferredMaxLayoutWidth = CGRectGetWidth(_letterLabel.frame);
}

- (void)prepareForReuse {
    _letterLabel.text = @"";
}

@end
