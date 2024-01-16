* Kristoffer's root path
if "`c(username)'" == "wb462869" {
    global clone "C:\Users\wb462869\github\labeller"
}
else if "`c(username)'" == "wb393438" {
    global clone "C:\Users\wb393438\stata_funs\labeller\labeller"
}

* Set global to ado_fldr
global src_fldr  "${clone}/src"
global test_fldr "${src_fldr}/tests"
global data_fldr "${test_fldr}/testdata"

* Install the version of this package in
* the plus-ado folder in the test folder
cap mkdir "${test_fldr}/plus-ado"
repado , adopath("${test_fldr}/plus-ado") mode(strict)

cap net uninstall labeller
net install labeller, from("${src_fldr}") replace

* output version of this package
labeller

* ==============================================================================
* Setup
* ==============================================================================

* create set of variables
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .

* apply variable labels to only some variables
label variable var1 "Some label"
label variable var4 "Another label"

* ==============================================================================
* List
* ==============================================================================

* ------------------------------------------------------------------------------
* Lists variables without labels globally
* ------------------------------------------------------------------------------

* list variables without variable labels globally
lbl_list_no_varlbl

local vars_wo_lbl = r(varlist)
local vars_wo_lbl : list clean vars_wo_lbl

* test
capture assert "`vars_wo_lbl'" == "var2 var3"
di as result "lbl_list_no_varlbl lists variables without labels globally"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* lists variables with without labels in varlist
* ------------------------------------------------------------------------------

* list variables without a label in the varlist
lbl_list_no_varlbl, varlist(var3 - var4)
local vars_wo_lbl_in_varlist = r(varlist)
local vars_wo_lbl_in_varlist : list clean vars_wo_lbl_in_varlist

* test
capture assert "`vars_wo_lbl_in_varlist'" == "var3"
di as result "vars_wo_lbl_in_varlist lists variables with without labels in varlist"
if _rc != 0 {
    di as error "❌ test failed"
    error 0
}
else {
    di as result "✅ test passed"
}

* ==============================================================================
* Assert
* ==============================================================================

* ------------------------------------------------------------------------------
* Assertion fails if violations present
* ------------------------------------------------------------------------------

* assert that all variables have a label
capture lbl_assert_var_have_lbl

* test
di as result "lbl_assert_var_have_lbl errors if any var is without a label"
if _rc == 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Teardown
* ==============================================================================

drop var1 - var4
