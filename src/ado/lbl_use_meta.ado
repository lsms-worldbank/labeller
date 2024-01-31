*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_use_meta
    program define lbl_use_meta, rclass

qui {

  version 14.1

  * Update the syntax. This is only a placeholder to make the command run
  syntax, ///
  varlist(varlist)    ///
  from_char(string)   ///
  [                   ///
    template(string)  ///
    apply_to(string)  ///
    all_missing_ok    ///
  ]

  * Create a dummy that is one if multiple vars was passed in varlist()
  local multi_varlist = (`: list sizeof varlist' > 1)

  ****************************
  * Check char on varlist

  * Test which variables that has the char
  ds `varlist', has(char `from_char')
  local varlist_with_char "`r(varlist)'"

  * List variables in varlist that did not have the char
  local varlist_without_char : list varlist - varlist_with_char
  * Out put a warning for variables that did not have
  if !missing("`varlist_without_char'") {
    noi di as text "{pstd}{red: Warning}: No action will be taken on these variables included in {inp:varlist()} as they did not have the char {inp:`from_char'}:{p_end}"
    noi di as text "{phang}- `varlist_without_char'{p_end}"
  }


  * Test that at least one variable had the char
  if (missing("`varlist_with_char'") & missing("`all_missing_ok'")) {
    noi di as error "{pstd}No variable in {inp:varlist()} had the char {inp:`from_char'}.{p_end}"
    error 99
    exit
  }

  ****************************
  * Exectue command on single-var varlist

  ****************************
  * Use meta char for each var

  foreach var of local varlist_with_char {
    * Get the char
    local value : char `var'[`from_char']
    * Call returned value different if one or several var in varlist
    if (`multi_varlist' == 0) return local char_value `"`value'"'
    else return local c_`var' `"`value'"'

    * If template is used apply it
    if !missing(`"`template'"') {
      * Populate the template
      apply_template , template(`"`template'"') value(`"`value'"')
      *Overwrite value with template
      local value `"`r(template)'"'

      * Call returned value different if one or several var in varlist
      if (`multi_varlist' == 0) return local template `"`value'"'
      else return local t_`var' `"`value'"'
    }

    ****************************
    * If apply_to is used, then apply the meta value

    if ("`apply_to'" == "varlabel") {
      label variable `var' `"`value'"'
    }
    // Add more apply_to here if applicable in future
  }

  if (`multi_varlist' != 0) {
    return local varlist_with_char    "`varlist_with_char'"
    return local varlist_without_char "`varlist_without_char'"
  }
}
end

cap program drop   apply_template
    program define apply_template, rclass

  syntax , template(string) value(string)

  if (strpos(`"`template'"', "{META}") == 0) {
    noi di as error `"{pstd}The template in "{inp:`template'}" does not include the placeholder "{META}".{p_end}"'
    error 99
    exit
  }

  * Populate template and return it
  local template = subinstr(`"`template'"',"{META}",`"`value'"', .)
  return local template `"`template'"'

end
