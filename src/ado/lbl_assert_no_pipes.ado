*! version 1.0 20240212 LSMS Team, World Bank lsms@worldbank.org

cap program drop   lbl_assert_no_pipes
    program define lbl_assert_no_pipes
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

    * Get the list of pipes used and the vars they are used for
    qui lbl_list_pipes, output_level(minimal) varlist("`varlist'")
    local pipes_found "`r(pipes)'"

    * Add the vars with remaining pipes for each pipe
    foreach pipe of local pipes_found {
      local `pipe'_v "`r(`pipe'_v)'"
    }

    * Ignore pipes
    local ignore_pipes = subinstr("`ignore_pipes'","%","",.)
    local pipes_found : list pipes_found - ignore_pipes

    if !missing("`pipes_found'") {
      noi di ""
      if ("`output_level'" == "minimal") {
        noi di as error "{pstd}There are still pipes in the dataset{p_end}"
      }
      else {
        foreach pipe of local pipes_found {
          local title "{err:Pipe %`pipe'% still in variable(s):}"
          if ("`output_level'" == "verbose") {
            //noi di `"output_verbose, title("`title'") values("``pipe'_v'")"'
            noi labeller output_verbose title("`title'") values("``pipe'_v'")
          }
          else if ("`output_level'" == "veryverbose") {
            noi labeller output_veryverbose title("`title'") varlist("``pipe'_v'") ///
              ttitle1("Variable") ttitle2("Variable label")
            noi di as text "{p2line}" _n
          }
        }
      }
      error 9
      exit
    }
    else {
      noi di as result _n "{pstd}No more pipes in dataset{p_end}"
    }
}
end
