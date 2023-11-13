cap program drop   lab_pipe
    program define lab_pipe

    * Update the syntax. This is only a placeholder to make the command run
    syntax , [pipeignore(string) varignore(string) pipevalues(string)]

    * Initiate pipes local
    local pipes ""

    * Loop over all variables to list all pipes and all vars each are used for
    foreach var of varlist _all {

      * Reset locals used in serach
      local is_pipe 0
      local this_pipe ""

      * Get this var's var labal and its length
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
              local pipes         : list pipes         | this_pipe
              local p_`this_pipe' "`p_`this_pipe'' `var'"
            }
            * Rest this_pipe
            local this_pipe ""
          }
        }

        * Space means its nver a pipe as in "what is 20% of 20%?"
        else if ("`c'" == " ") {
          local is_pipe   = 0
          local this_pipe ""
        }

        * Add letter to this pipe
        else if (`is_pipe') local this_pipe = "`this_pipe'`c'"
      }
    }


    * Pipe local cleanup and display

    noi di "pipes: [`pipes']"
    foreach pipe of local pipes {
      * Clean duplicates - happens when pipe occurs twice in a var label
      local p_`pipe' : list uniq p_`pipe'
      noi di "`pipe' : `p_`pipe''"
    }





end
