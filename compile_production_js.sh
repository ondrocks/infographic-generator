#!/bin/bash

cd "$(dirname "$0")"
mkdir -p production
rm    -v production/includes.production.*.js

CODE_FILES=$( perl -n -e "print \".\$1\n\" if m/^\s*['\"](\S+)['\"],?\s*\$/" public/js/includes.js | 
    perl -p -e 's!^\.?/(js|angular)/!./public/$1/!' | 
    # grep -v browserify.js |
    grep '^\./public/'  );

LIBS_FILES=$( perl -n -e "print \".\$1\n\" if m/^\s*['\"](\S+)['\"],?\s*\$/" public/js/includes.js | 
    perl -p -e 's!^\.?/(js|angular)/!./public/$1/!' | 
    # grep -v browserify.js |
    grep '\./\(vendor\|bower\)/' );

echo
echo
echo CODE_FILES
echo $CODE_FILES
echo
echo
echo LIBS_FILES
echo $LIBS_FILES
echo
echo



for FILE in $LIBS_FILES; do
    echo -e "//***** $FILE *****//\n"  >> production/includes.production.libs.js
    cat  $FILE                         >> production/includes.production.libs.js
    echo -e ';\n\n'                    >> production/includes.production.libs.js
done
for FILE in $CODE_FILES; do
    echo -e "//***** $FILE *****//\n"  >> production/includes.production.code.js
    cat  $FILE                         >> production/includes.production.code.js
    echo -e ";\n\n"                    >> production/includes.production.code.js
done
uglifyjs production/includes.production.libs.js -o production/includes.production.libs.min.js
uglifyjs production/includes.production.code.js -o production/includes.production.code.min.js

# browserify production/includes.production.code.js | tee production/includes.production.code.browserify.js | uglifyjs -o production/includes.production.code.browserify.min.js
    
ls production/includes.production.*.js | xargs -L1 echo wrote