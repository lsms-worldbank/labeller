# Title

__lbl_list_matching_vars__ - Identify variables whose label matches a pattern.

# Syntax

__lbl_list_matching_vars__ _regexstring_, [__**neg**ate__ __**v**arlist__(_varlist_)]

| _options_ | Description |
|-----------|-------------|
| __**neg**ate__        | Returns variables whose label does __not__ match  |
| __**v**arlist__(_varlist_) | Restrict the scope of variables to consider |

# Description

Stata provides relatively few and mostly imperfect tools for searching variable labels for a matching string. The [label](https://www.stata.com/manuals13/dlabel.pdf) tools to not offer any methods for querying the variable labels. The [lookfor](https://www.stata.com/manuals/dlookfor.pdf) command, while the nearest match, falls short in a few ways. First, it searches over both variable names and variable labels. Second, it does not provide a means for restricting the scope of search to a variable list. And third, it fails to provide a means for inverting the search (i.e., returning everything that does not match).

This function to fill the gap the following gaps:

- Search over variable labels only
- Specify search through (regex) patterns
- Restrict search to an (optionally) user-provided variable list
- Invert search to identify variables whose variables do not match

# Options

__**neg**ate__ inverts the match. Rather than return variables with matching variable labels, this option returns variables whose variable label do not match.

__**v**arlist__(_varlist_) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With __varlist__(), the scope of the search can be narrowed.

# Examples

## Example 1: Simple search

```
* create a set of variables
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .

* apply variables
label variable var1 "First label"
label variable var2 "2. label"
label variable var3 "3. label"
label variable var4 "Fourth label"

* find variables whose label contains "First"
lbl_list_matching_vars "First"
```

## Example 2: Regex search

```
* find variables whose labels start with a number
lbl_list_matching_vars "^[0-9]"
```

## Example 3: Restrict search to a variable list

```
* find variables whose label starts with "F" in var1 - var3
lbl_list_matching_vars "^F", varlist(var1 - var3)
```

## Example 4: Return variables whose labels do not match

```
* find variables whose labels do NOT start with a number
lbl_list_matching_vars "^[0-9]", negate
```

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/lsms-worldbank/labeller) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/lsms-worldbank/labeller/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
