{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:lbl_use_meta}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_use_meta} - This command access sand uses meta data stored in chars
{p_end}

{title:Syntax}

{phang}{bf:lbl_use_meta} , {bf:{ul:v}arlist}(varlist) {bf:{ul:from}_char}(string) [ {bf:{ul:tem}plate}(string) {bf:{ul:app}ly_to}(string) {bf:{ul:all}_missing_ok ]
{p_end}

{synoptset 17}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}arlist}(varlist)}Lists the variables this command should be applied to{p_end}
{synopt: {bf:{ul:from}_char}(string)}The name of the {inp:char} meta value the command should use{p_end}
{synopt: {bf:{ul:tem}plate}(string)}A template that the meta value should be combined with{p_end}
{synopt: {bf:{ul:app}ly_to}(string)}Indicate an action the command will do with the meta value{p_end}
{synopt: {bf:{ul:miss}ing_ok}}Suppresses the error thrown if no variable in varlist has any value in the {inp:char}{p_end}
{synoptline}

{title:Description}

{pstd}This command access meta data in stored in {browse "https://www.stata.com/manuals/pchar.pdf":chars}. This command is intended to be used in combination with [sel{it:add}metadata](https://lsms-worldbank.github.io/selector/reference/sel{it:add}metadata.html) but it will also work with any other {inp:char}.
{p_end}

{pstd}In addition to accessing a char value and returning in an r-class variable, this command can also apply this value to a template provided in the option {inp:template()}.
{p_end}

{pstd}Finally, this command can also take the {inp:char} value and apply to a variable label. If a template is provided, then the template populated with the value will be added as the variable label.
{p_end}

{title:Options}

{pstd}{bf:{ul:v}arlist}(varlist) lists the variables this command should be applied to. It can either be a single variable or a list of variables.
{p_end}

{pstd}{bf:{ul:from}_char}(string) indicated the name of the {browse "https://www.stata.com/manuals/pchar.pdf":char} that stores the relevant meta data the command should use.
{p_end}

{pstd}{bf:{ul:tem}plate}(string) allows the user to provide a template that the char meta value should be combined with. The template should be a single string. The string must include the placeholder {inp:{c -(}meta{c )-}} that the char meta value will replace. See below for an example.
{p_end}

{pstd}{bf:{ul:app}ly_to}(string) indicates that the meta data should be applied to a variable label for that variable. If the option {inp:template()} is used, then the value in combination with the template will be used. The only valid value this option accepts is {inp:varlabel}. Future versions of this command might allow more options.
{p_end}

{pstd}{bf:{ul:miss}ing_ok} suppresses the error thrown if no variable in varlist has any value in the {inp:from_char()}.
{p_end}

{title:Examples}

{pstd}Set up example data used in all examples below:
{p_end}

{input}{space 8}clear
{space 8}
{space 8}gen region1 = .
{space 8}gen region2 = .
{space 8}gen region3 = .
{space 8}gen region4 = .
{space 8}
{space 8}char region1[region] "North"
{space 8}char region2[region] "East"
{space 8}char region3[region] "South"
{space 8}char region4[region] "West"
{space 8}
{space 8}char region2[other] "something"
{space 8}
{space 8}char list
{text}
{dlgtab:Example 1}

{pstd}This example use the example data set up above. It takes the value in the char {inp:other} for the variable {inp:region2} and stores it in a returned local.
{p_end}

{input}{space 8}lbl_use_meta, varlist(region2) from_char(other)
{space 8}return list
{text}
{dlgtab:Example 2}
{pstd}This example use the example data set up above. It takes the value in the char {inp:region} for each variable, and applies it to the template {inp:Region: {c -(}META{c )-}} and stores the respective result for each variable in its variable label.
{p_end}

{input}{space 8}lbl_use_meta, varlist(region?) from_char(region) ///
{space 8}template("Region: {META}") apply_to("varlabel")
{space 8}return list
{space 8}describe
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.
{p_end}

{pstd}Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
