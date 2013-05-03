# $Id$

package PermitCategoryPublish::L10N::ja;

use strict;
use base 'PermitCategoryPublish::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'description of PermitCategoryPublish' => 'IDで指定されたカテゴリー以外のインデックスとそのカテゴリに属するパーマリンクが出力されないようにします。',
    'PermitCategoryPublish enable:' => 'プラグインを使用する:',
    'PermitCategoryPublish enable Hint' => 'プラグインを使用する場合はチェックボックスにチェックを入れてください。',
    'PermitCategoryPublish category_ids:' => 'カテゴリー ID',
    'PermitCategoryPublish category_ids Hint' => '出力を許可するカテゴリーのIDをカンマ(,)区切りで入力してください。'
);

1;
