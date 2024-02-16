{smcl}
{* *! version 1.0 16FEB2024}{...}
{hline}
{pstd}help file for {hi:lbl_list_long_varlbl}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_list_long_varlbl} - List variables whose variable label is longer than the desired character length.
{p_end}

{title:Syntax}

{phang}{bf:lbl_list_long_varlbl} , [{bf:{ul:max}len}({it:integer}) {bf:{ul:v}arlist}({it:varlist})]
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:max}len}({it:integer})}Maximum character length allowed.{p_end}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}When variable labels are too long, Stata truncates them to the first 80 characters of the string provided. This situation might arise for data exported from Survey Solutions. If provided, Survey Solutions uses the Variable label field in Designer, whose length is capped at 80 characters (in line with Stata{c 39}s limits). If no label is specified in that field, Survey Solutions uses the Question text field, whose length maximum length is 2,000 characters. In the latter case, Survey Solutions uses the first 80 characters of the question text as its label.
{p_end}

{pstd}To detect possible cases of truncation, data producers can check the length of each variable label individually (e.g., {inp:local var_lbl : variable label my_var; local lbl_len : ustrlen local var_lbl}). 
{p_end}

{pstd}However, there is no base Stata operation for doing so in batch.
{p_end}

{pstd}This command provides just such a tool.
{p_end}

{pstd}By default, the command take the maximum length to be Stata{c 39}s maximum length for labels: 80 characters. If desired, the command can specify an alternative length through the {bf:{ul:max}len}({it:integer}) option.
{p_end}

{title:Options}

{pstd}{bf:{ul:max}len}({it:integer}) sets the maximum length of variable labels, beyond which a variable is listed by this command.
{p_end}

{pstd}{bf:{ul:v}arlist}({it:varlist}) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With {bf:varlist}(), the scope of the search can be narrowed.
{p_end}

{title:Examples}

{input}{space 8}* create set of variables
{space 8}gen var1 = .
{space 8}gen var2 = .
{space 8}gen var3 = .
{space 8}gen var4 = .
{space 8}gen var5 = .
{space 8}
{space 8}* apply variables
{space 8}label variable var1 "Short label"
{space 8}label variable var2 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
{space 8}label variable var3 "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
{space 8}label variable var4 "Another short label"
{space 8}label variable var5 "你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好"
{space 8}
{space 8}* list variables with longer than the default max length (80 characters)
{space 8}lbl_list_long_varlbl
{space 8}
{space 8}* list variables with longer than the user-specified max length
{space 8}lbl_list_long_varlbl, maxlen(12)
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.
{p_end}

{pstd}Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
