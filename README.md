
Scheduling MiniZinc model to assign students to various groups of various topics, and assigning each group to a timeslot

# Purpose

This MiniZinc model gives an optimal schedule with the following data:

- n students
- m topics
- g possible groups per topic
- t time slots
- the students rank preferences for topics

and with the following constraints: 

- students cannot have two courses at the same time
- the same topic cannot happen twice at the same time (one teacher per topic)
- the groups have bounded size (from above and below)

The minimization is essentially on a sum of preferences to a certain power, to rule out pretty quickly low preferences. 

# In practice: from a spreadsheet containing the list of students and preferences

## Base file

Start with a .xls containing the list of students with their preferences

Open it with LibreOffice

## Exporting from xls to csv and formating

Add a column of xxx to the right of the names

Add a column of xxx to the right of the preferences

Replace empty cells by a certain value (e.g. the maximum of the preferences) by ctrl+H (find/replace), ticking "regular expression", Find : "^$" and replace by "maxvalue"

Export the name part (with xxx) in .csv, separating with commas (,) and turning into strings with quotes (")

Export the preferences (with xxx) in .csv, separating with commas (,)

## Data files

Open them with file editors

Replace ",xxx" by "|"

Control the ends [| and |];

Input them in data files .dzn as "name" and "preference"

## Run the models

Both in MiniZinc, with the coin-bc solver
