*! version 1.0 20240216 LSMS Team, World Bank lsms@worldbank.org

cap program drop   lbl_replace_pipe
    program define lbl_replace_pipe, rclass

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax, pipe(string) REPlacement(string) [TRUNcate(string) OUTput_level(string) missing_ok Varlist(varlist)]

    * Get all variables in varlist or get all variables
    ds `varlist'
    local varlist "`r(varlist)'"

    * Set defaults
    if missing("`truncate'")    local truncate    "error"
    if !(inlist("`truncate'","error","warning","prompt")) {
      noi di as error "{pstd}The value [`truncate'] in option {opt:truncate(`truncate')} is not a valid value. It may only be either error, warning, or prompt.{p_end}"
      error 198
    }

    * Set defaults
    if missing("`output_level'") local output_level "verbose"
    if !(inlist("`output_level'","minimal","verbose","veryverbose")) {
      noi di as error "{pstd}The value [`output_level'] in option {opt:output_level(`output_level')} is not a valid value. It may only be either minimal, verbose, or veryverbose.{p_end}"
      error 198
    }

    * Initiate local
    local truncate_yesall    "FALSE"

    **************************************************
    * Test valid pipe
    **************************************************

    * Remove % symbol if used in pipe
    local pipe = subinstr("`pipe'","%","",.)

    * Get the list of pipes used and the varlist they are used for
    qui lbl_list_pipes, output_level(minimal) varlist("`varlist'")
    local pipes_found "`r(pipes)'"
    local varlist     "`r(`pipe'_v)'"

    * Test that the pipe to be replaced was found
    if !(`: list pipe in pipes_found') {
      * Pipe not found - throw error unless missing_ok is used
      if missing("`missing_ok'") {
        noi di as error "{pstd}The pipe [`pipe'] was not used by any veraibles in the dataset. Use the option {opt:missing_ok} to surpress this error.{p_end}"
        error 198
      }
      else {
        noi di as text "{pstd}The pipe [`pipe'] was not used by any veraibles in the dataset. Nothing modified.{p_end}""
      }
    }

    **************************************************
    * Replace pipe
    **************************************************

    else {

      * Loop over each label this pipe is used for
      foreach var of local varlist {

        * Constructthe new label
        local lab : variable label `var'
        local newlab = subinstr("`lab'","%`pipe'%","`replacement'",.)

        * Handle too long variable label
        if (strlen("`newlab'")>80) {

          local newlab = substr("`newlab'",1,80)
          local lblstr "The new label for variable {it:`var'} will be longer than the max length of 80 characters when replacing the pipe {it:%`pipe'%} with value {it:`replacement'}."
          local oldlblstr "{pmore}Old label: {it:`lab'}{p_end}"
          local newlblstr "{pmore}New label (truncated): {it:`newlab'}{p_end}"

          if ("`truncate'"=="error") {
            noi di as error "{pstd}`lblstr' Either pick another shorter value for this pipe or see the options in option {opt truncate()}.{p_end}"
            noi di as res "`oldlblstr'"
            noi di as res "`newlblstr'"
            error 99
            exit
          }
          else if ("`truncate'"=="warning") {

            noi di as res "{pstd}{red:Warning:} `lblstr' The label will be truncated to 80 characters.{p_end}"
            noi di as res "`oldlblstr'"
            noi di as res "`newlblstr'"
          }
          else if ("`truncate'"=="prompt") {
            if ("`truncate_yesall'" == "FALSE") {

              noi di as res "{pstd}{red:Warning:} `lblstr' Please confirm that this is ok.{p_end}"
              noi di as res "`oldlblstr'"
              noi di as res "`newlblstr'"

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

      **************************************************
      * Output result
      **************************************************

      noi di ""
      if ("`output_level'" == "minimal") {
        noi di as text "{pstd}Pipes successfully replaced{p_end}"
      }
      else {
        local title "{ul:{bf:Pipe %`pipe'% replaced in variable(s):}}"
        if ("`output_level'" == "verbose") {
          noi labeller output_verbose title("`title'") values("`varlist'")
        }
        else if ("`output_level'" == "veryverbose") {
          noi labeller output_veryverbose title("`title'") ///
            varlist("`varlist'") ///
            ttitle1("Variable") ttitle2("New variable label")
          noi di as text "{p2line}" _n
        }
      }
      else if ("`output_level'" == "veryverbose") {

      }
    }
}
end
