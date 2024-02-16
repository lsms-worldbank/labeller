*! version 1.0 20240216 LSMS Team, World Bank lsms@worldbank.org

cap program drop   labeller
    program define labeller, rclass

qui {
    version 14.1

    * UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
  	local version "1.0"
    local versionDate "20240216" 

  	syntax [anything]

    * Command is used used to return version info
    if missing("`anything'") {
      * Prepare returned locals
      return local versiondate     "`versionDate'"
      return local version		      = `version'

      * Display output
      noi di ""
      local cmd    "labeller"
      local vtitle "This version of {inp:`cmd'} installed is version:"
      local btitle "This version of {inp:`cmd'} was released on:"
      local col2 = max(strlen("`vtitle'"),strlen("`btitle'"))
      noi di as text _col(4) "`vtitle'" _col(`col2')"`version'"
      noi di as text _col(4) "`btitle'" _col(`col2')"`versionDate'"
    }

    else {

      local allowed_commands "output_verbose output_veryverbose"

      gettoken subcommand parameters : anything

      if !(`: list subcommand in allowed_commands') {
        noi di as error "{pstd}The command labeller does not allow any options or parameters.{p_end}"
        error 198
        exit
      }
      * Run the subcommand
      noi `subcommand', `parameters'
    }
}
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

    syntax, title(string) ttitle1(string) ttitle2(string) [varlist(varlist)]

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
    foreach varname of local varlist {
       local varlab : variable label `varname'
       noi di as text "{p2col `p2_all':{bf:`varname'}} {text:`varlab'}" _n
    }

end
