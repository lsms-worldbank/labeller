{smcl}
{* *! version 0.0 11FEB2024}{...}
{hline}
{pstd}help file for {hi:lbl_assert_no_long_varlbl}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_assert_no_long_varlbl} - Assert that there is no variable in memory whose variable length exceeds the desired character length.
{p_end}

{title:Syntax}

{phang}{bf:lbl_assert_no_long_varlbl} , [{bf:{ul:max}len}({it:integer}) {bf:{ul:v}arlist}({it:varlist}) ]
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:max}len}({it:integer})}Maximum character length allowed.{p_end}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}This command assert that there is no variable in memory whose variable label length exceeds the desired character length.
{p_end}

{pstd}By default, the command take the maximum length to be Stata{c 39}s maximum length for labels: 80 characters. If desired, the command can specify an alternative length through the {bf:{ul:max}len}({it:integer}) option.
{p_end}

{pstd}If there is at least one variable whose length exceeds the maximum length, the command will return an error and list the variables whose variable labels are too long.
{p_end}

{title:Options}

{pstd}{bf:{ul:max}len}({it:integer}) sets the maximum length of variable labels.
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
{space 8}* assert no variables with labels longer than default max length (80 characters)
{space 8}lbl_assert_no_long_varlbl
{space 8}
{space 8}* assert no variables with labels longer than user-specified max length (80 characters)
{space 8}lbl_assert_no_long_varlbl, maxlen(12)
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
