#!/bin/bash
# drive all the GMT scripts in the ./report/ directory

cd ./report/

rm *.png *.ps  # clean up previous output
chmod 755 *.gmt  # assigning permissions

./upward_4km.gmt
./upward_800m.gmt

# ./downward_4km.gmt
./downward_800m.gmt

cd ../
