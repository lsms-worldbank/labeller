cap program drop   lab_pipe
    program define lab_pipe

    * Update the syntax. This is only a placeholder to make the command run
    syntax , [ignorepipes(string) varignore(string) pipevalues(string)]

    * Initiate pipes local
    local pipes_used      ""
    local pipes_replaced  ""
    local pipes_remaining ""

    **************************************************
    * Identify pipes used

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
              local pipes_used : list pipes_used | this_pipe
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


    **************************************************
    * Handle ignorepipes poption

    * Warn is pipes in ignore pipes are not founds
    local miss_ignored_pipes : list ignorepipes - pipes_used
    if !missing("`miss_ignored_pipes'") {
      noi di as smcl "{pstd}{err:Warning}: The pipe(s) to ignore [`miss_ignored_pipes'] was/were not used in any variable label{p_end}"
    }

    * Ignore pipes
    local pipes_used : list pipes_used - ignorepipes



    **************************************************
    * Display pipes

    noi di as smcl "{dlgtab: Pipes found:}"
    noi di "{pmore}- `pipes_used'{p_end}" _n
    foreach pipe of local pipes {
      * Clean duplicates - happens when pipe occurs twice in a var label
      local p_`pipe' : list uniq p_`pipe'
    }


    **************************************************
    * Replace pipes with string values

    * Copy all pipes to pipes remaining
    local pipes_remaining "`pipes_used'"

    foreach pipevalue of local pipevalues {
      local pipe : word 1 of `pipevalue'
      local value = subinstr("`pipevalue'", "`pipe' ", "", 1)

      local missing_pipes : list pipe - pipes_used
      if !missing("`missing_pipes'") {
        noi di as error "{pstd}The pipe [`missing_pipes'] with value [`value'] was not used in any variable label.{p_end}"
        error 99
      }

      * Update variable label
      foreach var of local p_`pipe' {
        local lab : variable label `var'
        local newlab = subinstr("`lab'","`pipe'","`value'",.)
        label variable `var' "`newlab'"
        // TODO : handle too long label
      }

      * Update replaced and remaining locals
      local pipes_replaced  "`pipes_replaced' `pipe'"
      local pipes_remaining : list pipes_remaining - pipe
    }

    ******************************************
    * Output replaced pipes

    if !missing("`pipes_replaced'") {
      noi di as res "{dlgtab: Pipes where labels was updated with values}"
    }
    foreach pipe of local pipes_replaced {
      noi di as smcl "{hline}"
      noi di as smcl "Pipe [`pipe']:"
      noi di as smcl "{hline}"
      noi di "{pmore}- `p_`pipe''{p_end}" _n
      noi di as smcl "{hline}"
    }

    ******************************************
    * Output replaced pipes

    if !missing("`pipes_remaining'") {
      noi di as res "{dlgtab: Pipes where labels were not yet updated with values}"
      noi di as res "{pstd}{it:Use option }{cmd:pipevalues()}{it: to update pipes with values.}{p_end}"
    }
    foreach pipe of local pipes_remaining {
      noi di as smcl "{hline}" _n "Pipe [`pipe']:" _n "{hline}"
      noi di "{pmore}- `p_`pipe''{p_end}" _n
      noi di as smcl "{hline}"
    }


end

// cap program drop   pipeval_parse
//     program define pipeval_parse
//
//     args anything
//
//     noi di `"`0'"'
//     noi di `"`1'"'
//     noi di `"`2'"'
// end
