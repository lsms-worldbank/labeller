cap program drop   lab_pipe
    program define lab_pipe

    * Update the syntax. This is only a placeholder to make the command run
    syntax , [ ///
      PIPEValues(string) ignorepipes(string)  ///
      outputlevel(string) truncate(string)   ///
      ]

    * Set defaults
    if missing("`outputlevel'") local outputlevel "verbose"
    if missing("`truncate'")    local truncate    "error"

    if !(inlist("`outputlevel'","minimal","verbose","veryverbose")) {
      noi di as error "{pstd}The value [`outputlevel'] in option {opt:outputlevel(`outputlevel')} is not a valid value. It may only be either minimal, verbose, or veryverbose.{p_end}"
      error 198
    }

    if !(inlist("`truncate'","error","warning","prompt")) {
      noi di as error "{pstd}The value [`truncate'] in option {opt:truncate(`truncate')} is not a valid value. It may only be either error, warning, or prompt.{p_end}"
      error 198
    }

    * Initiate locals
    local pipes_found     ""
    local pipes_replaced  ""
    local pipes_remaining ""
    local truncate_all    "FALSE"

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
            * Test that pipe is a valid pipe - otherwise it is liekly not a pipe
            local valid_pipe = regexm("`this_pipe'","^([a-z])([a-z0-9_]+)$")
            if (`valid_pipe') {
              local pipes_found : list pipes_found | this_pipe
              local p_`this_pipe' "`p_`this_pipe'' `var'"
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


    **************************************************
    * Handle ignorepipes poption

    * Warn is pipes in ignore pipes are not founds
    local miss_ignored_pipes : list ignorepipes - pipes_found
    if !missing("`miss_ignored_pipes'") {
      noi di as smcl "{pstd}{err:Warning}: The pipe(s) to ignore [`miss_ignored_pipes'] was/were not used in any variable label{p_end}"
    }

    * Ignore pipes
    local pipes_used : list pipes_found - ignorepipes

    **************************************************
    * Replace pipes
    **************************************************

    * Handle case of no outputs found
    if missing("`pipes_found'") noi di as res _n "{pstd}No pipes were found in this dataset.{p_end}"
    else {

      **************************************************
      * Replace pipes with string values
      foreach pipe of local pipes {
        * Clean duplicates - happens when pipe occurs twice in a var label
        local p_`pipe' : list uniq p_`pipe'
      }

      * Copy all pipes to pipes remaining
      local pipes_remaining "`pipes_used'"

      foreach pipevalue of local pipevalues {
        local pipe : word 1 of `pipevalue'
        local v_`pipe' = subinstr("`pipevalue'", "`pipe' ", "", 1)

        local missing_pipes : list pipe - pipes_used
        if !missing("`missing_pipes'") {
          noi di as error "{pstd}The pipe [`missing_pipes'] with value [`v_`pipe''] was not used in any variable label.{p_end}"
          error 99
        }

        * Update variable label
        foreach var of local p_`pipe' {
          local lab : variable label `var'
          local newlab = subinstr("`lab'","%`pipe'%","`v_`pipe''",.)

          * Handle too long variable label
          if (strlen("`newlab'")>80) {

            local newlab = substr("`newlab'",1,80)
            local lblstr "The new label for variable {opt `var'} will be longer than the max length of 80 characters when replacing the pipe {opt %`pipe'%} with value {opt `v_`pipe''}."
            local oldlblstr "{pmore}Old label: {it:`lab'}{p_end}"
            local newlblstr "{pmore}New label: {it:`newlab'}{p_end}"

            if ("`truncate'"=="error") {
              noi di as error "{pstd}`lblstr' Either pick another shorter value for this pipe or see the options in option {opt truncate()}.{p_end}"
              noi di as res "`oldlblstr'"
              noi di as res "`oldlblstr'"
              error 99
            }
            else if ("`truncate'"=="warning") {

              noi di as res "{pstd}{red:Warning:} `lblstr' The label will be truncated to 80 characters.{p_end}"
              noi di as res "`oldlblstr'"
              noi di as res "`oldlblstr'"
            }
            else if ("`truncate'"=="prompt") {
              if ("`truncate_all'" == "FALSE") {

                noi di as res "{pstd}{red:Warning:} `lblstr' Please confirm that this is ok.{p_end}"
                noi di as res "`oldlblstr'"
                noi di as res "`oldlblstr'"

                global adinp_confirmation ""
                while (!inlist(upper("${adinp_confirmation}"),"YES","YESALL", "BREAK")) {
                  noi di as txt `"{pstd}Enter "Yes" to confirm that the label can be truncated, enter "Yesall" to answer yes for all cases, or enter "BREAK" to abort."', _request(adinp_confirmation)
                }
                if upper("${adinp_confirmation}") == "YESALL" {
                  local truncate_all    "TRUE"
                }
                if upper("${adinp_confirmation}") == "BREAK" {
                  noi di as txt "{pstd}Package template creation aborted - nothing was created.{p_end}"
                  error 1
                  exit
                }
              }
            }
            * Error to catch incorrect truncate option
            else error 98
          }
          * Apply the new label
          label variable `var' "`newlab'"

        }

        * Update replaced and remaining locals
        local pipes_replaced  "`pipes_replaced' `pipe'"
        local pipes_remaining : list pipes_remaining - pipe
      }

      **************************************************
      * Outputs
      **************************************************

      **************************************************
      * Display pipes
      noi di as res _n "{pstd}{ul:{bf:Pipes found:}}{p_end}" _n
      output_verbose, ///
        title("{ul:Pipes to be replaced:}") ///
        values("`pipes_used'")

      if ("`outputlevel'" != "minimal") {
        output_verbose, ///
          title("{ul:Pipes found but ignored in ignorepipes():}") ///
          values("`ignorepipes'")
      }



      ******************************************
      * Output replaced pipes

      if !missing("`pipes_replaced'") {
        noi di as res "{pstd}{ul:{bf:Pipes where labels was updated with values:}}{p_end}" _n

        foreach pipe of local pipes_replaced {
          local title "{it:Pipe {bf:%`pipe'%} replaced with: {bf:`v_`pipe''} in variable(s):}"
          if ("`outputlevel'" == "minimal") {
            output_minimal, title("`title'")
          }
          else if ("`outputlevel'" == "verbose") {
            output_verbose, title("`title'") values("`p_`pipe''")
          }
          else if ("`outputlevel'" == "veryverbose") {
            output_veryverbose, title("`title'") vars("`p_`pipe''") ///
              ttitle1("Variable") ttitle2("Variable label")
          }
          else error 98
        }
        * Add spacing between sections if minimal output level where
        * spaces are not added withing the sub-commands
        if ("`outputlevel'" == "minimal") noi di as text ""
      }

      ******************************************
      * Output replaced pipes

      if !missing("`pipes_remaining'") {

        noi di as res "{pstd}{ul:{bf:Pipes where labels were not replaced with values:}}{p_end}"
        noi di as text "{pstd}{it:Use option }{cmd:pipevalues()}{it: to replace these pipes with values.}{p_end}" _n

        //noi di as text "{hline}" _n

        foreach pipe of local pipes_remaining {

          local title "{it:Pipe {bf:%`pipe'%} left as is in variable(s):}"

          if ("`outputlevel'" == "minimal") {
            output_minimal, title("`title'")
          }
          else if ("`outputlevel'" == "verbose") {
            output_verbose, title("`title'") values("`p_`pipe''")
          }
          else if ("`outputlevel'" == "veryverbose") {
            output_veryverbose, title("`title'") vars("`p_`pipe''") ///
              ttitle1("Variable") ttitle2("Variable label")
          }
          else error 98
        }
      }
  }


end

cap program drop   output_minimal
    program define output_minimal

    syntax, title(string)

    noi di as text "{phang}`title'{p_end}"
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

    noi di as text "{p2line}" _n

end
