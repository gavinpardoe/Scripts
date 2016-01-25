#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

sudo installer -pkg "$DIR/path" -target /
