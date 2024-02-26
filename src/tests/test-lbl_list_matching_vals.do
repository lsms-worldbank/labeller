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

* Set up a dev environement for testing locally
cap mkdir    "${tests}/dev-env"
repado using "${tests}/dev-env"

cap net uninstall labeller
net install labeller, from("${src_fldr}") replace

* output version of this package
labeller

* ==============================================================================
* Setup
* ==============================================================================

clear

* create set of variables
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .

* create some value labels
label define var1_lbl 1 "Yes" 2 "No"
label define var2_lbl 1 "Oui" 2 "Non" 3 "Oui, oui"
label define var4_lbl 1 "Oui" 2 "Non"

* apply labels
label values var1 var1_lbl
label values var2 var2_lbl
label values var4 var4_lbl

* ==============================================================================
* Test
* ==============================================================================

* ------------------------------------------------------------------------------
* Lists matching value labels and variables
* ------------------------------------------------------------------------------

* expect vars: var2 var4
* expect val lbls: var2_lbl var4_lbl
lbl_list_matching_vals, pattern("[Oo]ui")
local vars_matched = r(varlist)
local vars_matched : list clean vars_matched
local val_lbls_matched = r(val_lbl_list)
local val_lbls_matched : list clean val_lbls_matched

* test variables
capture assert "`vars_matched'" == "var2 var4"
di as result "Lists matching variables"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* test value labels
capture assert "`val_lbls_matched'" == "var2_lbl var4_lbl"
di as result "Lists matching value labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* Lists matching value labels and variables in varlist
* ------------------------------------------------------------------------------

* expect vars: var2
* expect val lbls: var2_lbl
lbl_list_matching_vals, pattern("[Oo]ui") varlist(var1 - var2)
local vars_matched_in_varlist = r(varlist)
local vars_matched_in_varlist : list clean vars_matched_in_varlist
local val_lbls_matched = r(val_lbl_list)
local val_lbls_matched : list clean val_lbls_matched

* test variables
capture assert "`vars_matched_in_varlist'" == "var2"
di as result "Lists matching variables"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* test value labels
capture assert "`val_lbls_matched'" == "var2_lbl"
di as result "Lists matching value labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* Lists no matches when no matches found
* ------------------------------------------------------------------------------

* expect: no vars
* informs no matches
lbl_list_matching_vals, pattern("Evet")
local var_count = r(var_count)
local lbl_count = r(lbl_count)

capture assert "`var_count'" == "0"
di as result "Lists no variables"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

capture assert "`lbl_count'" == "0"
di as result "Lists no value labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* Provides verbose output
* ------------------------------------------------------------------------------

* expect output equivalent to: label list var2_lbl var4_lbl
lbl_list_matching_vals, pattern("[Oo]ui") verbose


* ------------------------------------------------------------------------------
* Inverts list when negate specified
* ------------------------------------------------------------------------------

* expect variables: var1
* expect values: var1_lbl
lbl_list_matching_vals, pattern("[Oo]ui") negate
local vars_matched = r(varlist)
local vars_matched : list clean vars_matched
local val_lbls_matched = r(val_lbl_list)
local val_lbls_matched : list clean val_lbls_matched

* test variables
capture assert "`vars_matched'" == "var1"
di as result "Lists matching variables"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* test value labels
capture assert "`val_lbls_matched'" == "var1_lbl"
di as result "Lists matching value labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* Inverts list of matches in varlist when negate specified
* ------------------------------------------------------------------------------

* add a variable with labels
gen var5 = .
label values var5 var1_lbl

* expect variables: var1
* expect values: var1_lbl
lbl_list_matching_vals, pattern("[Oo]ui") negate varlist(var2 - var5)
local vars_matched = r(varlist)
local vars_matched : list clean vars_matched
local val_lbls_matched = r(val_lbl_list)
local val_lbls_matched : list clean val_lbls_matched

* test variables
capture assert "`vars_matched'" == "var5"
di as result "Lists matching variables"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* test value labels
capture assert "`val_lbls_matched'" == "var1_lbl"
di as result "Lists matching value labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* Test that the command can handle all characters in a pattern
* ------------------------------------------------------------------------------

lbl_list_matching_vals, pattern(`"[Oo]"ui"')

* ==============================================================================
* Teardown
* ==============================================================================

drop var1 - var5
label drop var1_lbl var2_lbl var4_lbl
