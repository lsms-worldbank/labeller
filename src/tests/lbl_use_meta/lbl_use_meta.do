
    cap which repkit
    if _rc == 111 {
        di as error `"{pstd}This test file use features from the package {browse "https://dime-worldbank.github.io/repkit/":repkit}. Click {stata ssc install repkit} to install it and run this file again.{p_end}"'
    }

    *************************************
    * Set root path
    * TODO: Update with reprun once published

    di "Your username: `c(username)'"
    * Set each user's root path
    if "`c(username)'" == "`c(username)'" {
        global root "C:/Users/wb462869/github/labeller"
    }
    * Set all other user's root paths on this format
    if "`c(username)'" == "WB393438" {
        global root "C:\Users\WB393438\stata_funs\labeller\labeller"
    }

    * Set global to the test folder
    global src   "${root}/src"
    global tests "${src}/tests"

    * Set up a dev environement for testing locally
    cap mkdir    "${tests}/dev-env"
    repado using "${tests}/dev-env"

    * If not already installed in dev-env, add repkit to the dev environment
    cap which repkit
    if _rc == 111 ssc install repkit

    /* TODO: Uncomment once adodown is published
    * If not already installed, add adodown to the dev environment
    cap which adodown
    if _rc == 111 ssc install adodown
    */

    * Install the latest version of labeller to the dev environment
    cap net uninstall labeller
    net install labeller, from("${src}") replace


    ***********************************************************
    * Set up test data

    clear

    gen region1 = .
    gen region2 = .
    gen region3 = .
    gen region4 = .

    char region1[region] "North"
    char region2[region] "East"
    char region3[region] "South"
    char region4[region] "West"

    char region2[other] "something"

    char list

    * Test basic case of the command lbl_use_meta
    lbl_use_meta, varlist(region2) from_meta(other)
    return list

    * Test basic case of the command lbl_use_meta
    lbl_use_meta, varlist(region2) from_meta(other) ///
    template("This meta value is {META}. Does it look correct?")
    return list

     * Test basic case of the command lbl_use_meta
    lbl_use_meta, varlist(region2) from_meta(other) ///
    template("This meta value is {META}. Does it look correct?") ///
    apply_to("varlabel")
    return list

    describe region2


    lbl_use_meta, varlist(region?) from_meta(region) ///
    template("Region: {META}.") apply_to("varlabel")
    return list

    describe region*

    describe

    * check that error issued if non-existent metadata provided in `from_meta`
    capture lbl_use_meta, varlist(region1) from_meta(foo)
    di as result "Error issued if non-existent metadata provided in from_meta"
    if _rc != 0 {
        di as result "✅ Test passed"
    }
    else {
        di as error "❌ Test failed"
        error 0
    }

