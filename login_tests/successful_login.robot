*** Settings ***
#Here we are importing the library since we are not using any resources for this file.
#It would be easier to manage these resources by using own files for variables and keyword resoucres.
#Test Setup keyword is defined in the bottom of this file, These kind of setup keywords could be defined in other resources.
#once again if there are a lot of them, put them into smaller files in a way that they make more sense. 
Library        SeleniumLibrary
Test Setup     Set Up Test Environment
Test Teardown  Close All Browsers

*** Variables ***
#Here are three examples of using ID for Locator with Selenium Locator syntax.
#Naming of elements is allways important, make sure your variable names are easy to understand.
#Tip: Sometimes I use the html element tag of the element on the variable name so it's easier to understand what kind of elements
#I'm interacting with.
${USER_NAME_INPUT_FIELD}=            username_field
${PASSWORD_INPUT_FIELD}=             id:password_field
${LOGIN_INPUT_BUTTON}=               xpath://*[@id="login_button"]

#These are things that are good to have as variables. 
    #It enables us to re-use test logic with different variables
    #Also these variables can now be written over either when the robot test script is called or from ENV variables.
    #When separating variables to resource files, keep in mind that might want to have some variables that are specifig
    #to your testcase/suite on the same file. In a case where they are not used anywhere else and most likely will not be used anywhere
    #else, the correct place for them would me inside the test file.  
${BROWSER_URL}=                      localhost:7272
${BROWSER}=                          chrome
${VALID_USERNAME}=                   demo
${VALID_PASSWORD}=                   mode
${INVALID_USERNAME}=                 foo
${INVALID_PASSWORD}=                 bar
${INDICATOR_OF_LOGIN_PAGE}           Welcome Page

***Test Cases ***
Test That Login Works
    Verify That Login Page And Elements Are Ready
    Login                            ${VALID_USERNAME}                    ${VALID_PASSWORD}                  
    
Test Login Without arguments
    Verify That Login Page And Elements Are Ready
    Login

*** Keywords ***
#These keywords could be more general and stored on their own file so they could be used everywhere in the tests.

Verify That Login Page And Elements Are Ready
    Wait Until Element Is Enabled    ${USER_NAME_INPUT_FIELD}      
    Wait Until Element Is Enabled    ${PASSWORD_INPUT_FIELD}
    Wait Until Element Is Enabled    ${LOGIN_INPUT_BUTTON}

Login To The App
#Login to an app is something that you most likely will need to do a lot. Most likely most of your test scenarios start from a situation where
#you have opened the browser and logged in to your application. This could be done with one keyword on the resource files or if there is a lot of variation
#on the logins, then it could even be done in a dedicated "login_keywords.robot" file to make it even more easier to understand and maintain. 
#This could be one of the keywords if the tests are mostly executed with the same user so the username and password are not needed as arguments. 
    Input Text                       ${USER_NAME_INPUT_FIELD}             ${VALID_USERNAME}
    Input Password                   ${PASSWORD_INPUT_FIELD}              ${VALID_PASSWORD}
    #This Validation keyword is not really nesessacry in this context since the app is so simple. 
    Validate That Values Are Correct
    Click Element                    ${LOGIN_INPUT_BUTTON}

Login With Credentials
    #Example of a login keyword that takes username and password as arguments. 
    [arguments]                      ${username}                          ${password}
    Input Text                       ${USER_NAME_INPUT_FIELD}             ${username} 
    Input Password                   ${PASSWORD_INPUT_FIELD}              ${password}
    Validate That Values Are Correct
    Click Element                    ${LOGIN_INPUT_BUTTON}

Login
#Okey here let's make an even more advanced login keyword. This keyword will login with default credentials unless it is given them as arguments.
    #Notice that here I'm using a list variable with the @syntax, this way we can pass two arguments in to the login function. 
    [arguments]                      @{login_credentials}  
    ${condition}                     Catenate                             @{login_credentials}
    ${length}=                       Get Length                           ${condition}
    Run Keyword If                   '${length}'>'0'                 
    ...                              Login With Credentials               @{login_credentials}
    ...                              ELSE                                 Login To The App

Validate That Values Are Correct
    #This keyword is just an example of using a gettter keyword and storing it's value to a variable. 
    ${username}=                     Get Value                            ${USER_NAME_INPUT_FIELD}
    Should Be Equal                  ${username}                          ${VALID_USERNAME}

Verify Login
    #In this context once again very simple, in your applications try to indentify the indicator that shows the login has been successfull and use it 
    #to test that your login has indeed happened before proceeding to other steps. 
    Wait Until Page Contains         ${INDICATOR_OF_LOGIN_PAGE}              

Set Up Test Environment
    #Example for a test setup keyword. 
    Set Tags                         smokey
    Open Browser                     ${BROWSER_URL}                       ${BROWSER}        
    Set Selenium Timeout             10 seconds