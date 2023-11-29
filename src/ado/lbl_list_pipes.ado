*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_list_pipes
    program define lbl_list_pipes, rclass

    * Update the syntax. This is only a placeholder to make the command run
    syntax , [ignorepipes(string) outputlevel(string)]

    * Set defaults
    if missing("`outputlevel'") local outputlevel "verbose"

    if !(inlist("`outputlevel'","minimal","verbose","veryverbose")) {
      noi di as error "{pstd}The value [`outputlevel'] in option {opt:outputlevel(`outputlevel')} is not a valid value. It may only be either minimal, verbose, or veryverbose.{p_end}"
      error 198
    }

    local pipes_found     ""

    **************************************************
    * Search for pipes
    **************************************************

    * Loop over all variables to list all pipes and all vars each are used for
    foreach var of varlist _all {

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
    local pipes_found : list pipes_found - ignorepipes

    **************************************************
    * Output results
    **************************************************

    * Display pipes
    noi di ""
    output_verbose, ///
      title("{ul:{bf:Pipes found in dataset:}}") ///
      values("`pipes_found'")

    if ("`outputlevel'" != "minimal") & !missing("`pipes_found'") {

      noi di as text "{p2line}" _n

      foreach pipe of local pipes_found {
        local title "{ul:{bf:Pipe %`pipe'% used in variable(s):}}"

        if ("`outputlevel'" == "verbose") {
          //noi di `"output_verbose, title("`title'") values("``pipe'_v'")"'
          output_verbose, title("`title'") values("``pipe'_v'")
        }
        else if ("`outputlevel'" == "veryverbose") {
          output_veryverbose, title("`title'") vars("``pipe'_v'") ///
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

end





cap program drop   output_verbose
    program define output_verbose

    syntax, title(string) [values(string)]

    * Prepare output list
    if missing("`values'") local vlist "{it:N/A}"
    else {
      * Comma seperate the list
      local vcount : word count `values'
      local vlist  = "{bf:`: word 1 of `values''}"
      forvalues i = 2/`vcount' {
          local vlist "`vlist', {bf:`: word `i' of `values''}"
      }
    }

    * Output the list
    noi di as text "{phang}`title'{p_end}"
    noi di as text "{phang} - `vlist'{p_end}" _n

end

cap program drop   output_veryverbose
    program define output_veryverbose

    syntax, title(string) ttitle1(string) ttitle2(string) [vars(varlist)]

    noi di as text "{pstd}`title'{p_end}"

    * Calculate longest string in col 1
    local maxvarlen = strlen("`ttitle1'")
    foreach varname of local vars {
        local maxvarlen = max(`maxvarlen',strlen("`varname'"))
    }

    * Set column locals
    local lind 5
    local rind `lind'
    local col2 = `maxvarlen' + `lind' + 1
    local col2_hang = `col2' + 4
    local p2_all  "`lind' `col2' `col2_hang' `rind'"

    * Write table title
    noi di as smcl "{p2colset `p2_all'}"
    noi di as text "{p2col `p2_all':{it:{ul:`ttitle1'}}} {it:{ul:`ttitle2'}}" _n

    * Write each label
    foreach varname of local vars {
       local varlab : variable label `varname'
       noi di as text "{p2col `p2_all':{bf:`varname'}} {text:`varlab'}" _n
    }

end
