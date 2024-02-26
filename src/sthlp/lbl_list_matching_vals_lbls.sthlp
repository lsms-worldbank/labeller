{smcl}
{* *! version 1.0 20240216}{...}
{hline}
{pstd}help file for {hi:lbl_list_matching_vals_lbls}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_list_matching_val_lbls} - List value labels whose labels match a pattern.
{p_end}

{title:Syntax}

{phang}{bf:lbl_list_matching_val_lbls}, {bf:pattern}({it:string}) [{bf:{ul:neg}ate} {bf:{ul:ver}bose} {bf:{ul:v}arlist}({it:varlist})]
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:pattern}({it:string})}Pattern to find in an answer option. Provide either a substring or a regular expression.{p_end}
{synopt: {bf:{ul:neg}ate}}Inverts the search, returning value labels that do {bf:not}match the pattern.{p_end}
{synopt: {bf:{ul:ver}bose}}Print out labels that match query. Output corresponds to {inp:label list lblnames}.{p_end}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}While Stata offers some tools for searching the content of variable labels (e.g. {inp:lookfor}), it does not have any methods for similarly searching the contents of value labels. 
{p_end}

{pstd}This command aims fill this gap by:
{p_end}

{pstd}- Searching labels in value labels for a pattern
- Identifying variable labels that contain labels of interest
- Compiling variables that have these labels of interest attached
{p_end}

{pstd}This command can be particularly useful for checking that variable do (not) contain patterns of interest. Consider for example:
{p_end}

{pstd}- Confirming that value labels contain (e.g., no)
- Identifying value labels that deviate from standards
{p_end}

{title:Options}

{pstd}{bf:pattern}({it:string}) provides the text pattern to find in the contents of value labels. Rather be the traitional Stata glob pattern, this pattern is a sub-string or a regular expression.
{p_end}

{pstd}{bf:{ul:neg}ate} inverts the search, returning value labels that do {bf:not}match the pattern. In isolation, {inp:pattern({c 34}my_text{c 34})} looks for value labels containing {inp:{c 34}my_text{c 34}}. With {inp:negate}, {inp:pattern({c 34}my_search{c 34})} search looks instead for value labels that do not contain {inp:{c 34}my_text{c 34}}. 
{p_end}

{pstd}{bf:{ul:ver}bose} manages the how much output is printed. If the {inp:verbose} option is not provided, {inp:lbl_list_matching_val_lbls} reports on whether any matches were found--and, if so, how many value labels match and how many variables the matching value labels describe. If the {inp:verbose} option is specified, the command will additionally print the contents of the matching value labels as a convenience. 
{p_end}

{pstd}{bf:{ul:v}arlist}({it:varlist}) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With {bf:varlist}(), the scope of the search can be narrowed.
{p_end}

{title:Examples}

{dlgtab:Example 1: contain a pattern}

{input}{space 8}* create some fake data
{space 8}gen var1 = .
{space 8}gen var2 = .
{space 8}gen var3 = .
{space 8}gen var4 = .
{space 8}
{space 8}* create some value labels
{space 8}label define var1_lbl 1 "Yes" 2 "No"
{space 8}label define var2_lbl 1 "Oui" 2 "Non" 3 "Oui, oui"
{space 8}label define var4_lbl 1 "Oui" 2 "Non"
{space 8}
{space 8}* apply those labels to some, but not all, variables
{space 8}label values var1 var1_lbl
{space 8}label values var2 var2_lbl
{space 8}label values var4 var4_lbl
{space 8}
{space 8}* find value labels with "Oui" and/or "oui" in at least one constituent label
{space 8}lbl_list_matching_val_lbls, pattern("[Oo]ui")
{space 8}
{space 8}* find value labels and print out the contents of the label, for convenience
{space 8}* i.e., to avoid the next step that many users might logically make:
{space 8}* [label list matching_lbl]
{space 8}lbl_list_matching_val_lbls, pattern("[Oo]ui") verbose
{text}
{dlgtab:Example 2: do not contain a pattern}

{input}{space 8}* find value labels that do not contain a certain pattern
{space 8}* for example, no "Oui"/"oui" in yes/no labels from a French-language survey
{space 8}lbl_list_matching_val_lbls, pattern("[Oo]ui") negate
{text}
{dlgtab:Example 3: contain only a certain set of characters}

{input}{space 8}* create some value labels
{space 8}label drop _all
{space 8}* var1_lbl var2_lbl var4_lbl
{space 8}label define var1_lbl 1 "YES" 2 "NO"
{space 8}label define var2_lbl 1 "Yes" 2 "No"
{space 8}label define var3_lbl 1 "yes" 2 "no"
{space 8}label define var4_lbl 1 "Où" 2 "Là"
{space 8}
{space 8}* attach them to variables created above
{space 8}label values var1 var1_lbl
{space 8}label values var2 var2_lbl
{space 8}label values var3 var3_lbl
{space 8}label values var4 var4_lbl
{space 8}
{space 8}* contains no lower-case characters
{space 8}lbl_list_matching_val_lbls, pattern("[:lower:]") negate
{space 8}
{space 8}* contains no French characters
{space 8}lbl_list_matching_val_lbls, pattern("[àâäÀÂÄéèêëÉÈÊËîïôöÔÖùûüçÇ]") negate
{space 8}
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/lsms-worldbank/labeller":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/lsms-worldbank/labeller/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
