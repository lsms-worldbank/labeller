# Title

__lbl_list_matching_vals__ - List value labels whose labels match a pattern.

# Syntax

__lbl_list_matching_vals__, __pattern__(_string_) [__**neg**ate__ __**ver**bose__ __**v**arlist__(_varlist_)]

| _options_ | Description |
|-----------|-------------|
| __pattern__(_string_)   | Pattern to find in an answer option. Provide either a substring or a regular expression.  |
| __**neg**ate__   | Inverts the search, returning value labels that do __not__match the pattern.  |
| __**ver**bose__   | Print out labels that match query. Output corresponds to `label list lblnames`.  |
| __**v**arlist__(_varlist_) | Restrict the scope of variables to consider |

# Description

While Stata offers some tools for searching the content of variable labels (e.g. `lookfor`), it does not have any methods for similarly searching the contents of value labels.

This command aims fill this gap by:

- Searching labels in value labels for a pattern
- Identifying variable labels that contain labels of interest
- Compiling variables that have these labels of interest attached

This command can be particularly useful for checking that variable do (not) contain patterns of interest. Consider for example:

- Confirming that value labels contain (e.g., no)
- Identifying value labels that deviate from standards

# Options

__pattern__(_string_) provides the text pattern to find in the contents of value labels. Rather be the traitional Stata glob pattern, this pattern is a sub-string or a regular expression.

__**neg**ate__ inverts the search, returning value labels that do __not__match the pattern. In isolation, `pattern("my_text")` looks for value labels containing `"my_text"`. With `negate`, `pattern("my_search")` search looks instead for value labels that do not contain `"my_text"`.

__**ver**bose__ manages the how much output is printed. If the `verbose` option is not provided, `lbl_list_matching_vals` reports on whether any matches were found--and, if so, how many value labels match and how many variables the matching value labels describe. If the `verbose` option is specified, the command will additionally print the contents of the matching value labels as a convenience.

__**v**arlist__(_varlist_) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With __varlist__(), the scope of the search can be narrowed.

# Examples

## Example 1: contain a pattern

```
* create some fake data
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .

* create some value labels
label define var1_lbl 1 "Yes" 2 "No"
label define var2_lbl 1 "Oui" 2 "Non" 3 "Oui, oui"
label define var4_lbl 1 "Oui" 2 "Non"

* apply those labels to some, but not all, variables
label values var1 var1_lbl
label values var2 var2_lbl
label values var4 var4_lbl

* find value labels with "Oui" and/or "oui" in at least one constituent label
lbl_list_matching_vals, pattern("[Oo]ui")

* find value labels and print out the contents of the label, for convenience
* i.e., to avoid the next step that many users might logically make:
* [label list matching_lbl]
lbl_list_matching_vals, pattern("[Oo]ui") verbose
```

## Example 2: do not contain a pattern

```
* find value labels that do not contain a certain pattern
* for example, no "Oui"/"oui" in yes/no labels from a French-language survey
lbl_list_matching_vals, pattern("[Oo]ui") negate
```

## Example 3: contain only a certain set of characters

```
* create some value labels
label drop _all
* var1_lbl var2_lbl var4_lbl
label define var1_lbl 1 "YES" 2 "NO"
label define var2_lbl 1 "Yes" 2 "No"
label define var3_lbl 1 "yes" 2 "no"
label define var4_lbl 1 "Où" 2 "Là"

* attach them to variables created above
label values var1 var1_lbl
label values var2 var2_lbl
label values var3 var3_lbl
label values var4 var4_lbl

* contains no lower-case characters
lbl_list_matching_vals, pattern("[:lower:]") negate

* contains no French characters
lbl_list_matching_vals, pattern("[àâäÀÂÄéèêëÉÈÊËîïôöÔÖùûüçÇ]") negate

```

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/lsms-worldbank/labeller) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/lsms-worldbank/labeller/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
