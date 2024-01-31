*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_drop_unused_lbls
    program define lbl_drop_unused_lbls

qui {

  version /* ADD VERSION NUMBER HERE */

  syntax , [Confirm]

    lbl_list_unused_lbls
    
    * capture and count the list of unused variables
    local unused_labels "`r(names)'"
    local n_unused_labels : list sizeof unused_labels

    * report on findings and drop unused labels, if needed
    if (`n_unused_labels' == 0) {     
      noi: di as result "{pstd}No unused value labels found.{p_end}"
    }
    else if (`n_unused_labels' > 0) {
      * if user wants to confirm, issue confirmation prompt
      if (!mi("`confirm'")) {
        noi: di as result "{pstd}Unused value labels found:{p_end}"
        noi: di as result "{phang}`unused_labels'{p_end}"
        noi: di as result "{phang}Would you like to drop these labels?{p_end}"
        noi: di as result "{phang}Type y or no to record your choice.{p_end}" _request(to_drop)
      }
      * if want to drop or did not request to confirm dropping, drop
      local want_to_drop = regexm("`to_drop'", "^[Yy]")
      if ((`want_to_drop' == 1)  | mi("`confirm'")) {
        noi: di as result "{pstd}Unused value labels dropped:{p_end}"
        noi: di as result "{phang}`unused_labels'{p_end}"
        label drop `unused_labels'
      }
      else if (`want_to_drop' == 0) {
        noi: di as result "{pstd}No unused value labels were dropped.{p_end}"
        noi: di as result "{pstd}However, these unused labels were found:{p_end}"
        noi: di as result "{phang}`unused_labels'{p_end}"
      }
    }

  }

end
