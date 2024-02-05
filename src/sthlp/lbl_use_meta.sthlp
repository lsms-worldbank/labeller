{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:lbl_use_meta}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_use_meta} - This command accesses and uses metadata stored in chars
{p_end}

{title:Syntax}

{phang}{bf:lbl_use_meta} , {bf:{ul:v}arlist}({it:varlist}) {bf:{ul:from}_meta}({it:string}) [ {bf:{ul:tem}plate}({it:string}) {bf:{ul:app}ly_to}({it:string}) {bf:{ul:miss}ing_ok} ]
{p_end}

{synoptset 17}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Lists the variables this command should be applied to{p_end}
{synopt: {bf:{ul:from}_meta}({it:string})}The name of the meta data the command should use{p_end}
{synopt: {bf:{ul:tem}plate}({it:string})}A template that the meta data value should be combined with{p_end}
{synopt: {bf:{ul:app}ly_to}({it:string})}Indicate an action the command will do with the meta value{p_end}
{synopt: {bf:{ul:miss}ing_ok}}Suppresses the error thrown if no variable in {bf:varlist()} has a {inp:char} with the name used in {bf:from_meta()}{p_end}
{synoptline}

{title:Description}

{pstd}This command accesses metadata stored in {browse "https://www.stata.com/manuals/pchar.pdf":chars}. This command is intended to be used in combination with metadata added to chars by the command [sel{it:add}metadata](https://lsms-worldbank.github.io/selector/reference/sel{it:add}metadata.html), but it will work with any other {inp:char} value.
{p_end}

{pstd}In addition to accessing a char value and returning in an r-class variable, this command can also apply this value to a template provided in the option {inp:template()}.
{p_end}

{pstd}Finally, this command can also take the {inp:char} value and apply to a variable label. If a template is provided, then the template populated with the value will be added as the variable label.
{p_end}

{title:Options}

{pstd}{bf:{ul:v}arlist}({it:varlist}) lists the variables this command should be applied to. It can either be a single variable or a list of variables.
{p_end}

{pstd}{bf:{ul:from}_char}({it:string}) indicates the name of the meta data the command should use. This values for this meta data is expected to be saved in a  {browse "https://www.stata.com/manuals/pchar.pdf":char} with the same name as the meta data. The command [sel{it:add}metadata](https://lsms-worldbank.github.io/selector/reference/sel{it:add}metadata.html) stores Survey Solution meta data this way.
{p_end}

{pstd}{bf:{ul:tem}plate}({it:string}) allows the user to provide a template that the meta data value should be combined with. The template should be a single string. The string must include the placeholder {inp:{c -(}META{c )-}} that the meta data value will replace. See below for an example.
{p_end}

{pstd}{bf:{ul:app}ly_to}({it:string}) indicates that the template should be applied to a variable label for that variable. If the option {inp:template()} is used, then the meta data value in combination with the template will be used. The only valid value this option accepts is {inp:varlabel}. Future versions of this command might allow more options.
{p_end}

{pstd}{bf:{ul:miss}ing_ok} suppresses the error thrown if no variable in {bf:varlist()} has a {inp:char} with the name used in {bf:from_meta()}. Variables in {bf:varlist()} without the relevant {inp:char} will be ignored by this command.
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

{pstd}This example use the example data set up above. It takes the meta data value in {inp:other} for the variable {inp:region2} and stores it in a returned local.
{p_end}

{input}{space 8}lbl_use_meta, varlist(region2) from_meta(other)
{space 8}return list
{text}
{dlgtab:Example 2}
{pstd}This example use the example data set up above. It takes the meta data value in {inp:region} for each variable, and applies it to the template {inp:Region: {c -(}META{c )-}}. And then it stores the respective result for each variable in its variable label.
{p_end}

{input}{space 8}lbl_use_meta, varlist(region?) from_meta(region) ///
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
