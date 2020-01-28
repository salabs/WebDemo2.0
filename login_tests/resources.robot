*** Settings ***
Library        SeleniumLibrary
Resource       variables.robot



*** Keywords ***
Verify That Login Page And Elements Are Ready
    Wait Until Element Is Enabled    ${USER_NAME_INPUT_FIELD}      
    Wait Until Element Is Enabled    ${PASSWORD_INPUT_FIELD}
    Wait Until Element Is Enabled    ${LOGIN_INPUT_BUTTON}
Try To Login
    Input Text                       ${USER_NAME_INPUT_FIELD}             ${VALID_USERNAME}
    Input Password                   ${PASSWORD_INPUT_FIELD}              ${VALID_PASSWORD}
    Validate That Values Are Correct
    Click Element                    ${LOGIN_INPUT_BUTTON}
Try Invalid Login
    Input Text                       ${USER_NAME_INPUT_FIELD}             ${INVALID_USERNAME}
    Input Password                   ${PASSWORD_INPUT_FIELD}              $${INVALID_PASSWORD}
    Click Element                    ${LOGIN_INPUT_BUTTON}
Validate That Values Are Correct
    ${username}=                     Get Value                            ${USER_NAME_INPUT_FIELD}
    Should Be Equal                  ${username}                          ${VALID_USERNAME}

#########################################################

Verify Login
    Wait Until Page Contains         ${INDICATOR_OF_LOGIN_PAGE}       

Verify Unsuccessfull Login
    Wait Until Page Contains         ${INDICATOR_OF_INVALID_LOGIN}

Set Up Test Environment
    Open Browser                     ${BROWSER_URL}                       ${BROWSER} 
    Verify That Login Page And Elements Are Ready
Input Credentials
    [Arguments]                      ${username}  ${password}
    Input Text                       ${USER_NAME_INPUT_FIELD}             ${username}
    Input Password                   ${PASSWORD_INPUT_FIELD}              ${password}
    Click Element                    ${LOGIN_INPUT_BUTTON}

Login Template
    [Arguments]                      ${username}  ${password}  ${condition}
    Verify That Login Page And Elements Are Ready
    Input Credentials                ${username}  ${password}
    Run Keyword If                   '${condition}'=='PASS'        Verify Login
    Run Keyword If                   '${condition}'=='FAIL'        Verify Unsuccessfull Login