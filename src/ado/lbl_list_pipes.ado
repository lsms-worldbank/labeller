*! version 1.0 20231109 LSMS Worldbank lsms@worldbank.org

cap program drop   lbl_list_pipes
    program define lbl_list_pipes, rclass

qui {

version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax, [IGnore_pipes(string) OUTput_level(string) Varlist(varlist)]

    * Get all variables in varlist or get all variables
    ds `varlist'
    local varlist "`r(varlist)'"

    * Set defaults
    if missing("`output_level'") local output_level "verbose"
    if !(inlist("`output_level'","minimal","verbose","veryverbose")) {
      noi di as error "{pstd}The value [`output_level'] in option {opt:output_level(`output_level')} is not a valid value. It may only be either minimal, verbose, or veryverbose.{p_end}"
      error 198
    }

    * Initiate locals
    local pipes_found     ""

    **************************************************
    * Search for pipes
    **************************************************

    * Loop over all variables to list all pipes and all vars each are used for
    foreach var of local varlist {

      * Reset locals used in serach
      local is_pipe 0
      local this_pipe ""

      * Get this var's var label and its length
      local lab : variable label `var'
      local lablen = strlen("`lab'")

      * Parse the label
      forvalues i = 1/`lablen' {
        *Get first charachter
        local c = substr("`lab'",`i',1)
        * Test if beginning or end of pipe
        if ("`c'"=="%") {
          *Swithc is_pipe bool
          local is_pipe = !`is_pipe'
          *If no longer pipe, save this pipe and rest
          if !(`is_pipe') {
            * Test that pipe is a valid pipe - otherwise it is likely not a pipe
            * pipes, as variable names, must:
            * - start with a letter
            * - contain letters, numbers, and underscore
            * See more here: https://docs.mysurvey.solutions/questionnaire-designer/components/variable-names/
            local valid_pipe = regexm("`this_pipe'","^([A-Za-z])([A-Za-z0-9_]+)$")
            if (`valid_pipe') {
              local pipes_found : list pipes_found | this_pipe
              local `this_pipe'_v "``this_pipe'_v' `var'"
            }
            * Rest this_pipe
            local this_pipe ""
          }
        }
        * Space means its never a pipe as in "what is 20% of 20%?"
        else if ("`c'" == " ") {
          local is_pipe   = 0
          local this_pipe ""
        }
        * Add letter to this pipe
        else if (`is_pipe') local this_pipe = "`this_pipe'`c'"
      }
    }

    * Ignore pipes
    local ignore_pipes = subinstr("`ignore_pipes'","%","",.)
    local pipes_found : list pipes_found - ignore_pipes

    **************************************************
    * Output results
    **************************************************

    * Add % % to pipes to always display the pipes as %pipe%
    local formatted_pipes = ""
    foreach pipe of local pipes_found {
      local formatted_pipes "`formatted_pipes' %`pipe'%"
    }

    * Display pipes
    noi di ""
    labeller output_verbose ///
      title("{ul:{bf:Pipes found in dataset:}}") ///
      values("`formatted_pipes'")

    if ("`output_level'" != "minimal") & !missing("`pipes_found'") {

      noi di as text "{p2line}" _n

      foreach pipe of local pipes_found {
        local title "{ul:{bf:Pipe %`pipe'% used in variable(s):}}"

        if ("`output_level'" == "verbose") {
          //noi di `"output_verbose, title("`title'") values("``pipe'_v'")"'
          noi labeller output_verbose title("`title'") values("``pipe'_v'")
        }
        else if ("`output_level'" == "veryverbose") {
          noi labeller output_veryverbose title("`title'") varlist("``pipe'_v'") ///
            ttitle1("Variable") ttitle2("Variable label")
          noi di as text "{p2line}" _n
        }
        else error 98
      }
    }

    **************************************************
    * Return locals with pip information
    **************************************************

    * Output the variables used for each pipe
    foreach pipe of local pipes_found {
      return local `pipe'_v =trim("``pipe'_v'")
    }

    * Output the pipes found
    return local pipes "`pipes_found'"
}
end
