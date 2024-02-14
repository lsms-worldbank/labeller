{smcl}
{* *! version 1.0 14FEB2024}{...}
{hline}
{pstd}help file for {hi:lbl_use_meta}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_use_meta} - This command accesses metadata and, optionally, uses it to set the value of data attributes.
{p_end}

{title:Syntax}

{phang}{bf:lbl_use_meta} , {bf:{ul:v}arlist}({it:varlist}) {bf:{ul:from}_meta}({it:string}) [ {bf:{ul:tem}plate}({it:string}) {bf:{ul:app}ly_to}({it:string}) {bf:{ul:miss}ing_ok} ]
{p_end}

{synoptset 17}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Lists the variables this command should be applied to{p_end}
{synopt: {bf:{ul:from}_meta}({it:string})}The name of the metadata the command should use{p_end}
{synopt: {bf:{ul:tem}plate}({it:string})}A template that the metadata value should be combined with{p_end}
{synopt: {bf:{ul:app}ly_to}({it:string})}Provide the name of the data attribute to which the template will be applied{p_end}
{synopt: {bf:{ul:miss}ing_ok}}Suppresses the error thrown if no variable in {bf:varlist()} has a {inp:char} with the name used in {bf:from_meta()}{p_end}
{synoptline}

{title:Description}

{pstd}This command tackles two related tasks: first, accessing metadata (e.g., question text, answer text, etc.); and second, applying that retrieved metadata to the attributes of in-memory data sets (e.g., variable label).
{p_end}

{pstd}As a getter, this command retrieves metadata stored in {browse "https://www.stata.com/manuals/pchar.pdf":chars}. While intended to be used in combination with metadata added by the {browse "https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html":sel_add_metadata}, this command will work with any other {inp:char} value as well. 
{p_end}

{pstd}As a setter, this command can also set the value of data attributes using the the retrieved metadata. In the most basic case, it retrieves metadata and sets the value of a user-specified data attribute -- for example, retrieving {inp:question_text} for a variable and applying that string to the variable label. In other cases, it can retrieve metadata and set the value of a data attribute using a template (see the {inp:template()} option below) -- for example, retrieving the {inp:answer_text} of a multi-select question and applying it to the variable label (e.g., {inp:{c 34}Water source: {c -(}META{c )-}{c 34}}). And in still other cases, it can effortlessly perform this operation in batch -- for example, identifying all questions derived from a multi-select question in Survey Solutions (through the {inp:varlist(asset_owned*)} option), retrieving their {inp:answer_text} metadata (through the {inp:from_meta()} option), and applying that metadata to the variable label through sensible string template (via {inp:apply_to({c 34}varlabel{c 34}) template({c 34}Asset: {c -(}META{c )-}{c 34})}). 
{p_end}

{title:Options}

{pstd}{bf:{ul:v}arlist}({it:varlist}) lists the variables this command should be applied to. It can either be a single variable or a list of variables.
{p_end}

{pstd}{bf:{ul:from}_meta}({it:string}) indicates the name of the metadata the command should use. This metadata is expected to be saved in a {browse "https://www.stata.com/manuals/pchar.pdf":char} with the same name as the metadata. The command {browse "https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html":sel_add_metadata} stores Survey Solution metadata this way.
{p_end}

{pstd}{bf:{ul:tem}plate}({it:string}) allows the user to provide a template describing how the metadata should be writen into the template. The template should be a single string and must include {inp:{c -(}META{c )-}}, a placeholder indicating where that the metadata value will written. See below for an example. 
{p_end}

{pstd}{bf:{ul:app}ly_to}({it:string}) indicates that the template should be applied to a variable label for that variable. If the option {inp:template()} is used, then the metadata value in combination with the template will be used. The only valid value this option accepts is {inp:varlabel}. Future versions of this command might allow more options. 
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
{dlgtab:Example 1: Retrieve a metadata value}

{pstd}This example use the example data set up above. It takes the meta data value in {inp:other} for the variable {inp:region2} and stores it in a returned local. 
{p_end}

{input}{space 8}* retrieve the metadata name `other` 
{space 8}* return it to a macro
{space 8}lbl_use_meta, varlist(region2) from_meta(other)
{space 8}return list
{text}
{dlgtab:Example 2: Set the variable label of a single variable with a template}

{input}{space 8}* retrieve the metadata named `other` and 
{space 8}* apply it to the variable label for variable `region2` 
{space 8}* with a template
{space 8}lbl_use_meta, varlist(region2) from_meta(other) ///
{space 8}  template("This meta value is {META}. Does it look correct?") ///
{space 8}  apply_to("varlabel")
{space 8}return list
{text}
{dlgtab:Example 3: Set the variable label of multiple variables at once with a template}

{pstd}This example use the example data set up above. It takes the meta data value in {inp:region} for each variable, and applies it to the template {inp:Region: {c -(}META{c )-}}. And then it stores the respective result for each variable in its variable label. 
{p_end}

{input}{space 8}* retrieve the metadata named `region` and 
{space 8}* apply it to the variable label for ALL variables matching `region?` 
{space 8}* with a template
{space 8}lbl_use_meta, varlist(region?) from_meta(region) ///
{space 8}  template("Region: {META}") apply_to("varlabel")
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
