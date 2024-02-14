*! version 1.0 20240212 LSMS Team, World Bank lsms@worldbank.org

cap program drop   lbl_drop_unused_lbls
    program define lbl_drop_unused_lbls

qui {

    version 14.1

  syntax , [Confirm]

    lbl_list_unused_lbls

    * capture and count the list of unused variables
    local unused_labels   "`r(names)'"
    local n_unused_labels "`r(count)'"

    * report on findings and drop unused labels, if needed
    if (`n_unused_labels' == 0) {
      noi di as text "{pstd}No unused value labels found.{p_end}"
    }
    else if (`n_unused_labels' > 0) {

      noi di as text "{pstd}Unused value labels found:{p_end}"

      * if user wants to confirm, issue confirmation prompt
      if mi("`confirm'") {
        * Add all labels to be removed
        local lbl_remove "`unused_labels'"
      }
      else {

        *list all unused labels to prompt about so user can answer "ALL"
        noi di as result "{phang}`unused_labels'{p_end}"

        * Initiate the prompt global to missing
        global lbl_unused_confirmation ""
        * Initial locals listing labels to remove or keep
        local lbl_keep   ""
        local lbl_remove ""

        * loop over each unused label and prompt for deletion
        foreach lbl of local unused_labels {

          * If all used for previous label, then apply ALL to all lables
          if "${lbl_unused_confirmation}" == "ALL" {
            global lbl_unused_confirmation "ALL"
          }
          else global lbl_unused_confirmation ""

          * Prompt until valid answer is given
          while (!inlist(upper("${lbl_unused_confirmation}"), "Y", "N", "ALL", "BREAK")) {
            noi di as result _n `"{pstd}Confirm removal of unused value label: {inp:`lbl'}{p_end}."'

            noi di as text `"{pstd}Enter "{inp:Y}" to confirm removal, "{inp:N}" to keep this label,  or "{inp:ALL}" to confirm removal of all remaining unused labels listed above not yet prompted about, or enter "{inp:BREAK}" to exit this command with no action taken.{p_end}"', _request(lbl_unused_confirmation)
          }

          if inlist(upper("${lbl_unused_confirmation}"), "Y", "ALL") {
              local lbl_remove "`lbl_remove' `lbl'"
          }
          else if inlist(upper("${lbl_unused_confirmation}"), "N") {
            local lbl_keep "`lbl_keep' `lbl'"
          }
          else if inlist(upper("${lbl_unused_confirmation}"), "BREAK") {
            noi di as text "{pstd}Command exited with no action taken.{p_end}"
            error 1
            exit
          }
          else {
            noi di as text "{pstd}Prompt error. This is a bug and should never happen.{p_end}"
            error 99
            exit
          }
      }
    }

    * Regardless of confirm or not, removing labels here
    if (`: list sizeof lbl_remove' > 0) {
      label drop `lbl_remove'
      noi di as text _n "{phang}These unused labels were dropped: {inp:`lbl_remove'}{p_end}"
    }

    if (`: list sizeof lbl_keep' > 0) {
      noi di as text _n "{phang}These unused labels are kept: {inp:`lbl_keep'}{p_end}"
    }

  }
}
end
