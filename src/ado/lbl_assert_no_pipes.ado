*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_assert_no_pipes
    program define lbl_assert_no_pipes

    * Update the syntax. This is only a placeholder to make the command run
    syntax, [ignorepipes(string) outputlevel(string)]

    * Set defaults
    if missing("`outputlevel'") local outputlevel "verbose"
    if !(inlist("`outputlevel'","minimal","verbose","veryverbose")) {
      noi di as error "{pstd}The value [`outputlevel'] in option {opt:outputlevel(`outputlevel')} is not a valid value. It may only be either minimal, verbose, or veryverbose.{p_end}"
      error 198
    }

    * Get the list of pipes used and the vars they are used for
    qui lbl_list_pipes, outputlevel(minimal)
    local pipes_found "`r(pipes)'"

    * Add the vars with remaining pipes for each pipe
    foreach pipe of local pipes_found {
      local `pipe'_v "`r(`pipe'_v)'"
    }

    * Ignore pipes
    local pipes_found : list pipes_found - ignorepipes

    if !missing("`pipes_found'") {
      noi di ""
      if ("`outputlevel'" == "minimal") {
        noi di as error "{pstd}There are still pipes in the dataset{p_end}"
      }
      else {
        foreach pipe of local pipes_found {
          local title "{err:Pipe %`pipe'% still in variable(s):}"
          if ("`outputlevel'" == "verbose") {
            //noi di `"output_verbose, title("`title'") values("``pipe'_v'")"'
            labeller output_verbose title("`title'") values("``pipe'_v'")
          }
          else if ("`outputlevel'" == "veryverbose") {
            labeller output_veryverbose title("`title'") vars("``pipe'_v'") ///
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

end
