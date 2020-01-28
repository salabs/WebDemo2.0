*** Settings ***
Resource                                            resources.robot
Test Setup                                          Set Up Test Environment
Test Teardown                                       Close All Browsers
                                         
*** Variables ***
${USER_NAME_INPUT_FIELD}=                           username_field
${PASSWORD_INPUT_FIELD}=                            id:password_field
${LOGIN_INPUT_BUTTON}=                              xpath://*[@id="login_button"]
${BROWSER_URL}=                                     localhost:7272
${BROWSER}=                                         chrome
${VALID_USERNAME}=                                  demo
${VALID_PASSWORD}=                                  mode
${INVALID_USERNAME}=                                foo
${INVALID_PASSWORD}=                                bar
${INDICATOR_OF_LOGIN_PAGE}                          Welcome Page

***Test Cases ***
Test That Login Works
    Verify That Login Page And Elements Are Ready
    Login                                           ${VALID_USERNAME}                    ${VALID_PASSWORD}                  

Test Login Without arguments
    Verify That Login Page And Elements Are Ready
    Login

*** Keywords ***

Verify That Login Page And Elements Are Ready
    Wait Until Element Is Enabled                   ${USER_NAME_INPUT_FIELD}      
    Wait Until Element Is Enabled                   ${PASSWORD_INPUT_FIELD}
    Wait Until Element Is Enabled                   ${LOGIN_INPUT_BUTTON}

Login To The App
    Input Text                                      ${USER_NAME_INPUT_FIELD}             ${VALID_USERNAME}
    Input Password                                  ${PASSWORD_INPUT_FIELD}              ${VALID_PASSWORD}
    Validate That Values Are Correct
    Click Element                                   ${LOGIN_INPUT_BUTTON}

Login With Credentials 
    [arguments]                                     ${username}                          ${password}
    Input Text                                      ${USER_NAME_INPUT_FIELD}             ${username} 
    Input Password                                  ${PASSWORD_INPUT_FIELD}              ${password}
    Validate That Values Are Correct
    Click Element                                   ${LOGIN_INPUT_BUTTON}

Login
    [arguments]                                     @{login_credentials}  
    ${condition}                                    Catenate                             @{login_credentials}
    ${length}=                                      Get Length                           ${condition}
    Run Keyword If                                  '${length}'>'0'                 
    ...                                             Login With Credentials               @{login_credentials}
    ...                                             ELSE                                 Login To The App

Validate That Values Are Correct
    ${username}=                                    Get Value                            ${USER_NAME_INPUT_FIELD}
    Should Be Equal                                 ${username}                          ${VALID_USERNAME}

Verify Login
    Wait Until Page Contains                        ${INDICATOR_OF_LOGIN_PAGE}              

Set Up Test Environment
    Set Tags                                        smokey
    Open Browser                                    ${BROWSER_URL}                       ${BROWSER}        
    Set Selenium Timeout                            10 seconds