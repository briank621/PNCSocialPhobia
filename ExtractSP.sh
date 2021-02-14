#!/bin/bash
cat scores/Groups.csv | awk -F, 'NR > 1 {print $2}' >> SubjectList.txt
