# Title

__lbl_use_meta__ - This command accesses and uses metadata stored in chars

# Syntax

__lbl_use_meta__ , __**v**arlist__(varlist) __**from**_char__(string) [ __**tem**plate__(string) __**app**ly_to__(string) __**all**_missing_ok ]

| _options_ | Description |
|-----------|-------------|
| __**v**arlist__(varlist) | Lists the variables this command should be applied to |
| __**from**_char__(string) | The name of the `char` value the command should use |
| __**tem**plate__(string) | A template that the `char` value should be combined with |
| __**app**ly_to__(string) | Indicate an action the command will do with the meta value |
| __**miss**ing_ok__ | Suppresses the error thrown if no variable in varlist has any value in the `char` |

# Description

This command accesses metadata stored in [chars](https://www.stata.com/manuals/pchar.pdf). This command is intended to be used in combination with [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html) but it will also work with any other `char`.

In addition to accessing a char value and returning in an r-class variable, this command can also apply this value to a template provided in the option `template()`.

Finally, this command can also take the `char` value and apply to a variable label. If a template is provided, then the template populated with the value will be added as the variable label.

# Options

__**v**arlist__(varlist) lists the variables this command should be applied to. It can either be a single variable or a list of variables.

__**from**_char__(string) indicates the name of the [char](https://www.stata.com/manuals/pchar.pdf) that stores the relevant metadata the command should use.

__**tem**plate__(string) allows the user to provide a template that the `char` value should be combined with. The template should be a single string. The string must include the placeholder `{META}` that the `char` value will replace. See below for an example.

__**app**ly_to__(string) indicates that the template should be applied to a variable label for that variable. If the option `template()` is used, then the value in combination with the template will be used. The only valid value this option accepts is `varlabel`. Future versions of this command might allow more options.

__**miss**ing_ok__ suppresses the error thrown if no variable in varlist has any value in the `from_char()`.

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

## Example 1

This example use the example data set up above. It takes the value in the char `other` for the variable `region2` and stores it in a returned local.

```
lbl_use_meta, varlist(region2) from_char(other)
return list
```

## Example 2
This example use the example data set up above. It takes the value in the char `region` for each variable, and applies it to the template `Region: {META}` and stores the respective result for each variable in its variable label.

```
lbl_use_meta, varlist(region?) from_char(region) ///
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
