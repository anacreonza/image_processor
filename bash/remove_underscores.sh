#!/bin/bash

# Remove underscores from filenames.

# Use bash parameter expansion search and replace to change filenames.
# ${file//_/ } replaces all occurrences of "_" with " "

find $1 -type f -name '*_*' | while read file ; do mv "$file" "${file//_/ }" ; done