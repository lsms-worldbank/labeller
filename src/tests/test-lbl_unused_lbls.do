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
cap mkdir    "${test_fldr}/dev-env"
repado using "${test_fldr}/dev-env"

cap net uninstall labeller
net install labeller, from("${src_fldr}") replace

* output version of this package
labeller

* ==============================================================================
* Setup
* ==============================================================================

clear

* create one variable
gen v1 = .

* define more than one value label set
label define v1 1 "yes" 2 "no", modify
label define v3 1 "oui" 2 "non", modify
label define v4 1 "evet" 2 "hayır", modify

* attach one value label, but not the others
label values v1 v1

label list

tempfile lbl_data
save    `lbl_data', orphans


* ==============================================================================
* Base case
* ==============================================================================

use `lbl_data', clear

* Show unused labels with and without verbose
lbl_list_unused_lbls
return list

lbl_list_unused_lbls, verbose

* drop the value labels not attached (aka unused)
lbl_drop_unused_lbls
label list


* ==============================================================================
* List
* ==============================================================================

use `lbl_data', clear

* expected result
local unused_expected "v4 v3"

* capture result
lbl_list_unused_lbls
local unused_returned = r(names)
local unused_returned : list clean unused_returned

capture assert "`unused_returned'" == "`unused_expected'"
di as result "lbl_list_unused_lbls finds unused variable labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Drop
* ==============================================================================

use `lbl_data', clear

* expected list of remaining labels
local lbls_expected "v1"

* drop unused labels
lbl_drop_unused_lbls

* get remaining labels
qui: label dir
local lbls_found = r(names)

capture assert "`lbls_found'" == "`lbls_expected'"
di as result "lbl_drop_unused_lbls removes all unattached value labels"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}
