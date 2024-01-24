
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
    global run_fldr  "${test_fldr}/lab_pipe"

    * Set up a dev environement for testing locally
    cap mkdir    "${tests}/dev-env"
    repado using "${tests}/dev-env"

    cap net uninstall labeller
    net install labeller, from("${src_fldr}") replace

    * Create example data
    sysuse auto, clear
    label variable mpg "Mileage (%unit%)"

    label variable price "Cost of car (%unit%)"

    label variable foreign "Is (%country%)"

    * List pipes
    lbl_list_pipes, output_level(veryverbose)

    * Replace a pipe
    lbl_replace_pipe, pipe("%unit%") truncate(warning) ///
        replacement("miles per gallon") output_level(veryverbose)

    lbl_assert_no_pipes, output_level(veryverbose) ///
        ignore_pipes(country)
