*! version 1.0 20240216 LSMS Team, World Bank lsms@worldbank.org

cap program drop   lbl_use_meta
    program define lbl_use_meta, rclass

qui {

    version 14.1

  * Update the syntax. This is only a placeholder to make the command run
  syntax, ///
  Varlist(varlist)    ///
  FROM_meta(string)   ///
  [                   ///
    TEMplate(string)  ///
    APPly_to(string)  ///
    MISSing_ok    ///
  ]

  * Create a dummy that is one if multiple vars was passed in varlist()
  local multi_varlist = (`: list sizeof varlist' > 1)


  ****************************
  * Check whether any char is loaded

  * check whether SuSo selectors attached to data set
  * by looking for data-level char
  local list_selector_chars : char _dta[selector_chars]
  ds, has(char)
  local vars_with_chars "`r(varlist)'"

  * issue error if this no chars attached
  * NOTE: this only actuall checks for SuSo selector chars added by `selector`
  if missing("`vars_with_chars'") {
    noi di as text "{pstd}{red: Error}: No metadata found {p_end}"
    noi di as text `"{pstd}Add metadata to your data with {help char} or sel_add_metadata from {browse "https://lsms-worldbank.github.io/selector/":selector} package. {p_end}"'
    error 99
    exit
  }


  ****************************
  * Check char on varlist

  * Test which variables that has the char
  ds `varlist', has(char `from_meta')
  local varlist_with_char "`r(varlist)'"

  * if target metadata does not exist
  if missing("`varlist_with_char'") {
    noi di as text "{pstd}{red: Error}: No metadata named `from_meta' found for `varlist' {p_end}"
    error 99
    exit
  }

  * List variables in varlist that did not have the char
  local varlist_without_char : list varlist - varlist_with_char
  * Out put a warning for variables that did not have
  if !missing("`varlist_without_char'") {
    noi di as text "{pstd}{red: Warning}: No action will be taken on these variables included in {inp:varlist()} as they did not have the meta data {inp:`from_meta'} stored in a {help char}:{p_end}"
    noi di as text "{phang}- `varlist_without_char'{p_end}"
  }


  * Test that at least one variable had the char
  if (missing("`varlist_with_char'") & missing("`missing_ok'")) {
    noi di as error "{pstd}No variable in {inp:varlist()} had the meta data {inp:`from_meta'} stored in a {help char}.{p_end}"
    error 99
    exit
  }

  ****************************
  * Exectue command on single-var varlist

  ****************************
  * Use meta char for each var

  foreach var of local varlist_with_char {
    * Get the char
    local value : char `var'[`from_meta']
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
    return local varlist_with_meta    "`varlist_with_char'"
    return local varlist_without_meta "`varlist_without_char'"
  }
}
end

cap program drop   apply_template
    program define apply_template, rclass

  syntax , template(string) value(string)

  if (ustrpos(`"`template'"', "{META}") == 0) {
    noi di as error `"{pstd}The template in "{inp:`template'}" does not include the placeholder "{META}".{p_end}"'
    error 99
    exit
  }

  * Populate template and return it
  local template = usubinstr(`"`template'"',"{META}",`"`value'"', .)
  return local template `"`template'"'

end
