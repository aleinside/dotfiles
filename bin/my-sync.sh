#!/bin/bash

rsync -aruzv --exclude=.git/ ~/Works/prima dev-future:/home/ubuntu/Works/future-prima >> ~/Works/my-sync.log

# fswatch -o ~/Works/prima | xargs -n1 -I{} ./my-sync.sh
