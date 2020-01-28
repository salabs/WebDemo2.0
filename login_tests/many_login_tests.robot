*** Settings ***
Resource                            resources.robot
Test Setup                          Set Up Test Environment
Test Teardown                       Close All Browsers
Test Template                       Login Template

***Test Cases***                    Username                   Password                 Condition
Successfull Test                    ${VALID_USERNAME}          ${VALID_PASSWORD}        PASS
Unsuccessfull Test 1                ${INVALID_USERNAME}        ${INVALID_PASSWORD}      FAIL
Unsuccessfull Test 2                ${VALID_USERNAME}          ${INVALID_USERNAME}      FAIL

***Keywords***
Login Template
    [Arguments]                      ${username}  ${password}  ${condition}
    Input Credentials                ${username}  ${password}
    Run Keyword If                   '${condition}'=='PASS'        Verify Login
    Run Keyword If                   '${condition}'=='FAIL'        Verify Unsuccessfull Login