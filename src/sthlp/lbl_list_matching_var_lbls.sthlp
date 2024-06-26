{smcl}
{* *! version 1.0 20240216}{...}
{hline}
{pstd}help file for {hi:lbl_list_matching_var_lbls}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_list_matching_var_lbls} - Identify variables whose label matches a pattern.
{p_end}

{title:Syntax}

{phang}{bf:lbl_list_matching_vars} {bf:pattern}({it:string}), [{bf:{ul:neg}ate} {bf:{ul:v}arlist}({it:varlist})]
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:pattern}}Provides to find in the variable label. Provide either a substring or a regular expression.{p_end}
{synopt: {bf:{ul:neg}ate}}Returns variables whose label does {bf:not} match{p_end}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}Stata provides relatively few and mostly imperfect tools for searching variable labels for a matching string. The {browse "https://www.stata.com/manuals13/dlabel.pdf":label} tools do not offer any methods for querying the variable labels. The {browse "https://www.stata.com/manuals/dlookfor.pdf":lookfor} command, while the nearest match, falls short in a few ways. First, it searches over both variable names and variable labels. Second, it does not provide a means for restricting the scope of search to a variable list. And third, it fails to provide a means for inverting the search (i.e., returning everything that does not match).
{p_end}

{pstd}This function to fill the gap the following gaps:
{p_end}

{pstd}- Search over variable labels only
- Specify search through (regex) patterns
- Restrict search to an (optionally) user-provided variable list
- Invert search to identify variables whose variables do not match
{p_end}

{title:Options}

{pstd}{bf:pattern}({it:string}) provides the text pattern to find in the contents of variable labels. Rather than the traditional Stata glob pattern, this pattern is a sub-string or a regular expression.
{p_end}

{pstd}{bf:{ul:neg}ate} inverts the match. Rather than return variables with matching variable labels, this option returns variables whose variable label do not match.
{p_end}

{pstd}{bf:{ul:v}arlist}({it:varlist}) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With {bf:varlist}(), the scope of the search can be narrowed.
{p_end}

{title:Examples}

{dlgtab:Example 1: Simple search}

{input}{space 8}* create a set of variables
{space 8}gen var1 = .
{space 8}gen var2 = .
{space 8}gen var3 = .
{space 8}gen var4 = .
{space 8}
{space 8}* apply variables
{space 8}label variable var1 "First label"
{space 8}label variable var2 "2. label"
{space 8}label variable var3 "3. label"
{space 8}label variable var4 "Fourth label"
{space 8}
{space 8}* find variables whose label contains "First"
{space 8}lbl_list_matching_vars, pattern("First")
{text}
{dlgtab:Example 2: Regex search}

{input}{space 8}* find variables whose labels start with a number
{space 8}lbl_list_matching_vars, pattern("^[0-9]")
{text}
{dlgtab:Example 3: Restrict search to a variable list}

{input}{space 8}* find variables whose label starts with "F" in var1 - var3
{space 8}lbl_list_matching_vars, pattern("^F") varlist(var1 - var3)
{text}
{dlgtab:Example 4: Return variables whose labels do not match}

{input}{space 8}* find variables whose labels do NOT start with a number
{space 8}lbl_list_matching_vars, pattern("^[0-9]") negate
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/labeller":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/labeller/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
