# Title

__lbl_use_meta__ - This command accesses and uses metadata stored in chars

# Syntax

__lbl_use_meta__ , __**v**arlist__(_varlist_) __**from**_meta__(_string_) [ __**tem**plate__(_string_) __**app**ly_to__(_string_) __**miss**ing_ok__ ]

| _options_ | Description |
|-----------|-------------|
| __**v**arlist__(_varlist_) | Lists the variables this command should be applied to |
| __**from**_meta__(_string_) | The name of the meta data the command should use |
| __**tem**plate__(_string_) | A template that the meta data value should be combined with |
| __**app**ly_to__(_string_) | Indicate an action the command will do with the meta value |
| __**miss**ing_ok__ | Suppresses the error thrown if no variable in __varlist()__ has a `char` with the name used in __from_meta()__ |

# Description

This command accesses metadata stored in [chars](https://www.stata.com/manuals/pchar.pdf). This command is intended to be used in combination with metadata added to chars by the command [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html), but it will work with any other `char` value.

In addition to accessing a char value and returning in an r-class variable, this command can also apply this value to a template provided in the option `template()`.

Finally, this command can also take the `char` value and apply to a variable label. If a template is provided, then the template populated with the value will be added as the variable label.

# Options

__**v**arlist__(_varlist_) lists the variables this command should be applied to. It can either be a single variable or a list of variables.

__**from**_char__(_string_) indicates the name of the meta data the command should use. This values for this meta data is expected to be saved in a  [char](https://www.stata.com/manuals/pchar.pdf) with the same name as the meta data. The command [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html) stores Survey Solution meta data this way.

__**tem**plate__(_string_) allows the user to provide a template that the meta data value should be combined with. The template should be a single string. The string must include the placeholder `{META}` that the meta data value will replace. See below for an example.

__**app**ly_to__(_string_) indicates that the template should be applied to a variable label for that variable. If the option `template()` is used, then the meta data value in combination with the template will be used. The only valid value this option accepts is `varlabel`. Future versions of this command might allow more options.

__**miss**ing_ok__ suppresses the error thrown if no variable in __varlist()__ has a `char` with the name used in __from_meta()__. Variables in __varlist()__ without the relevant `char` will be ignored by this command.

# Examples

Set up example data used in all examples below:

```
clear

gen region1 = .
gen region2 = .
gen region3 = .
gen region4 = .

char region1[region] "North"
char region2[region] "East"
char region3[region] "South"
char region4[region] "West"

char region2[other] "something"

char list
```

## Example 1: Retrieve a metadata value

This example use the example data set up above. It takes the meta data value in `other` for the variable `region2` and stores it in a returned local.

```
* retrieve the metadata name `other`
* return it to a macro
lbl_use_meta, varlist(region2) from_meta(other)
return list
```

## Example 2: Set the the variable label with a template

```
* retrieve the metadata named `other` and
* apply it to the variable label for variable `region2`
* with a template
lbl_use_meta, varlist(region2) from_meta(other) ///
  template("This meta value is {META}. Does it look correct?") ///
  apply_to("varlabel")
return list
```

## Example 3: Set the the variable label in batch
This example use the example data set up above. It takes the meta data value in `region` for each variable, and applies it to the template `Region: {META}`. And then it stores the respective result for each variable in its variable label.

```
* retrieve the metadata named `region` and
* apply it to the variable label for ALL variables matching `region?`
* with a template
lbl_use_meta, varlist(region?) from_meta(region) ///
  template("Region: {META}") apply_to("varlabel")
return list
describe
```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
