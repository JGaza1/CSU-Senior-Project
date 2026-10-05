Test Plan Document
==================

- [IDENTIFICATION INFORMATION](#identification-information)
  - [Product](#product)
  - [Project Description](#project-description)
  - [Testing Objectives](#testing-objectives)
  - [Features to be Tested](#features-to-be-tested)
  - [Features Not to Be Tested](#features-not-to-be-tested)
- [UNIT TEST](#unit-test)
  - [UNIT TEST STRATEGY / EXTENT OF UNIT TESTING:](#unit-test-strategy--extent-of-unit-testing)
  - [UNIT TEST CASES](#unit-test-cases)
- [REGRESSION TEST](#regression-test)
  - [Regression Test Strategy](#regression-test-strategy)
  - [Regression Test Cases](#regression-test-cases)
- [INTEGRATION TEST](#integration-test)
  - [Integration Test Strategy and Extent of Integration Testing](#integration-test-strategy-and-extent-of-integration-testing)
  - [Integration Test Cases](#integration-test-cases)
- [USER-ACCEPTANCE TEST (To be completed by the business office)](#user-acceptance-test-to-be-completed-by-the-business-office)
  - [User-Acceptance Test Strategy](#user-acceptance-test-strategy)
  - [User-Acceptance Test Cases](#user-acceptance-test-cases)
- [Test Deliverables](#test-deliverables)
- [Schedule](#schedule)
- [Risks](#risks)
- [Appendix](#appendix)


IDENTIFICATION INFORMATION
--------------------------

### Product

- Project Health

### Project Description

A health app that helps users with their health and fitness goals.

### Testing Objectives

Lay out test plans for Unit Test, Regression Test, Integration Test, and User Acceptance Test

### Features to be Tested

(List the features of the software/product to be tested with references to the 
Requirements and/or Design specifications of the features to be tested.)


### Features Not to Be Tested

(List the features of the software/product which will not be tested. Specify the
reasons these features won’t be tested.)


UNIT TEST
---------

### UNIT TEST STRATEGY / EXTENT OF UNIT TESTING:

Evaluate new features and bug fixes introduced in this release. 
(Specify the properties of test environment: hardware, software, network etc.)

### UNIT TEST 
**Account Validation**
**(HTF-01, HTU-02)**
| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  | Checking Username         | Username is empty       | When "Create Account" button pressed, error will occur to enter a username                |                   |
|  2  | Checking Email          | Email is empty      | When "Create Account" button pressed, error will occur to enter an email                 |                   |
|  3  | Check password          | Password is empty      |  When "Create Account" button pressed, error with message will pop up to fill the fields necessary                |          |
|  4  | Confirm Password Check          | Confirm Password does not match password    |  When "Create Account" button pressed, error with "The passwords do not match"                |          |
|  5  | Account Creation Input          | Username, Email, and password are entered. As well as confirm password matches password      | When user hits "Create Account" button, account is successfully created                 |          |


**Onboard Validation**
**(HTF-02, HTF-02a, HTF-02b)**
| \#  | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  | Age Validation   (Empty)        | Age field is empty        | When user hits "Save and Continue" Error with message to fill necessary fields will occur                 |                   |
|  2  | Weight Validation  (Empty)         | Weight field is empty      | When user hits "Save and Continue" Error with message to fill necessary fields will occur                 |                   |
|  3  | Height Validation (Empty)         | Height field is empty       | When user hits "Save and Continue" Error with message to fill necessary fields will occur                 |          |
|  4  | Onboarding Validation  (Empty fields)        | Multiple fields are empty      |  When user hits "Save and Continue" Error will occur to "Please fill in all fields"                |          |
|  5  | Check for non-numeric for age (Non-numeric)          | Age contains non-numeric input      |  When user hits "Save and Continue" "Enter a valid Age"                |          |
|  6  | Check for valid age input  (Negative or 0)        | User enters a 0 or negative number      |  When user hits "Save and Continue" "Please enter a valid age."                |          |
|  7  | Check for positive weight input (Negative or 0)         | User enters a 0 or negative number      |   When user hits "Save and Continue" "Please enter a valid weight."                |          |
|  8  | Checks if weight is a number (Non-numeric)        | User enters a non-numeric input for weight      | When user hits "Save and Continue" "Please enter a valid weight"                 |          |
|  9  |  Height Validation   (Non-numeric)      | User enters a non-numeric input for height      | When user hits "Save and Continue" "Please enter a valid height"                  |          |
|  10  |  Height Validation (Negative or 0)        | User enters is 0 or negative      | When user hits "Save and Continue" "Please enter a valid height"                 |          |
|  11  | Lose Weight Validation  (Empty)        | The lose weight field is blank if chosen       |  When user hits "Save and Continue" "Please enter a valid target loss"                |          |
|  12  |  Lose Weight Validation (Non-numeric)        | When the lose weight option is chosen, the user enters a non-numeric input      | When user hits "Save and Continue" "Please enter a valid target loss"                 |          |
|  13  | Lose Weight Validation (Higher weight target)          | Lose weight target is higher than current weight      | When user hits "Save and continue" "Target weight must be greater than 0"                 |          |
|  14  | Gain Weight Validation (Empty)          | When Gain weight option is chosen, the field is empty      | When user hits "Save and Continue" "Please enter a valid target gain"                 |          |
|  15  | Gain Weight Validation (Negative or 0)          | When Gain Weight option is chosen, the user enters a negative number or 0      |   When user hits "Save and Continue" "Please enter a valid target gain"               |          |
|  16  | Maintain Weight Selected          | When user hits maintain weight, no weight field should be available to type      | No extra fields pop up to enter input                 |          |
|  17  |  Onboarding Success         | All valid fields have been entered with the correct goals as well     |  When user hits "Save and Continue", the screen should go to the dashboard                |          |
|  18  | Steps Validation          | Under Health Goal, the user hits total steps and types in a numeric input      | No errors should be shown                 |          |
|  19  | Steps Validation (Empty)          | User leaves steps field blank      | "Please fill in the steps field                 |          |
|  20  | Steps Validation (Non-numeric)          | User types in non-numeric input      | "Please enter a valid number for steps"                 |          |
|  21  | Steps Validation (Negative or 0)          | User types in a negative number or a 0      | "Please enter a valid number for steps"                 |          |

**Dashboard Validation** 
**(HTF-02)**
| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | -------- |
|  1  |  Username         | After logging in or onboarding, the user is taken to the dashboard      | User name is shown at the "Welcome back, <i>**username"**                 |          |
|  2  |  Weight Display         | After logging in or onboarding, the weight is shown in the dashboard      | Weight should be displayed in the top left box under **"Your Stats"**                 |          |
|  3  | Height Display          | After logging in or onboarding, the height is shown in the dashboard       | Height should be displayed on the top left box under **"Your Stats"**                 |          |
|  4  | Age Display          | After logging in or onboarding, the age is shown in the dashboard      | Age should be displayed in the bottom left box under **"Your Stats"**                 |          |
|  5  | Goal Display           | After logging in or onboarding, the goal name is shown in the dashboard       |  Goal type should be displayed in the bottom right box under **"Your Stats"**                 |          |
|  6  | Goal Type Display (Lose Weight)          | After logging in or onboarding, the goal type is shown      | The goal should be Lose Weight on the bottom right box under **"Your Stats"**                 |          |
|  7  |  Goal Type Display (Gain Weight)         | After logging in or onboarding, the goal type is shown      | Gain weight is the goal name displayed in the bottom right box under **"Your Stats"**                 |          |
|  8  |  Goal Type Display (Maintain Weight)         | After logging in or onboarding, the goal type is shown      | Maintain weight is the goal name displayed in the bottom right box under **"Your Stats"**                 |          |
|  9  | Current Goal Display (Gain Weight)         | After logging in or onboarding, the current goal will be displayed in the dashboard      | Under **"Current Goal""** Gain weight should be displayed                  |          |
|  10 | Current Goal Display (Lose Weight)         | After logging in or onboarding, the current goal will be displayed in the dashboard      | Under **"Current Goal""** Lose weight should be displayed                  |          |
|  11  | Current Goal Display (Maintain Weight)         | After logging in or onboarding, the current goal will be displayed in the dashboard      | Under **"Current Goal""** Maintain weight should be displayed                  |          |
|  12  | Current Goal Display (Steps)         | After logging in or onboarding, the current goal will be displayed in the dashboard      | Under **"Current Goal""** Steps should be displayed                  |          |
|  13  | Current Goal Display Progess bar calculation         | After logging in or onboarding, the current goal will have a progress bar     | Under **"Current Goal""** Progess bar will progress from 0% to 100%                 |          |
|  14  | Current Goal Display Progess bar calculation         | After logging in or onboarding, the current goal will have a progress bar     | Under **"Current Goal""** Progess bar will not go below 0% or above 100%                 |          |
|  15  | Steps Display          | User is shown the dashboard       | On dashboard under **"Apple Health"**, Steps should be shown                 |           |
|  16  | Active Calories Display          | User is in the dashboard      | Under **"Apple Health"**, Active calories should be in the right box                 |          |
|  17  | Resting Calories Display          | User is in the dashboard      | Under **"Apple Health"**, Resting calories should be in the bottom middle box                 |          |
|  18  | Target Weight Calculation  (Lose Weight)        | When on onboarding, when lose weight is chosen, the dashboard correctly shows calculated target weight       | When user is on the Dashboard, the weight shown is less than current weight                 |          |
|  19  | Target weight Calculation (Gain Weight)          | When gain weight goal option is chosen, the dashboard shows the correct target weight      | On the dashboard the weight is correctly calculated based on user input                 |          |



REGRESSION TEST
---------------

Ensure that previously developed and tested software still performs after change.

### Regression Test Strategy

Evaluate all reports introduced in previous releases.

### Regression Test Cases

| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | OBSERVED |
| --: | --------- | ----- | ---------------- | -------- |
|  1  |           |       |                  |          |
|  2  |           |       |                  |          |


INTEGRATION TEST
----------------

Combine individual software modules and test as a group.

### Integration Test Strategy and Extent of Integration Testing

Evaluate all integrations with locally developed shared libraries, with consumed services, and other touch points.

### Integration Test Cases


**Supabase Authentication**
**(HTS-02)**
| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  | Supabase Authentication         | When the user creates a new account and goes through onboarding, new AUTH_USER is created in supabase      | Upon logging in to supabase there is a new row in every table relating to the user                 |                   |
|  2  | Supabase Authentication (Login)          | User enters login credentials stored in supabase      | Successful login and user is taken to the dashboard                  |                   |
|  3  | Supabase Authentication (Login failed)          | User creates an account and enter an existing account info                 | Message should appear that "Account already Exists"               |      |


**Supabase Database**
**(HTS-03)**
| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  |  Supabase Database (health_profile)         | User hits "Save and Continue" on the onboarding      | New row is inserted in table: health_profiles                  |                   |
|  2  | Supabase Database (weight_logs)          | User's weight related info is saved in table: weight_logs      |  New or updated row is in weight_logs upon account creation                |                   |
|  3  | Supabase Database (goals)          | User's goals are saved in table: goals       | New or updated row is  in goals                  |                   |
|  4 | Supabase Database (Correct User)           | User's goals, health profile, and goals are set      |  The right user data is shown for the correct user                |                   |

**Apple HealthKit**
**(HTF-09)**
| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  | HealthKit Authorization          | After user goes through onboarding      | Message will pop up requesting user to accept health data tracking and displaying                 |                   |
|  2  |  HealthKit Steps      | User is in dashboard      | Under "**Apple Health"**, app should retrieve today's steps                 |                   |
|  3  | HealthKit Active Calories          | User is in dashboard                 | Under "**Apple Health"**, app should retrieve today's active calories               |      |
|  4  | HealthKit Resting Calories          | User is in dashboard                 | Under "**Apple Health"**, app should retrieve today's resting calories               |      |
|  5  | HealthKit Functionality         | User is in dashboard                 | Unavailable health data doesn't make the app crash               |      |

**USDA FoodData Central""
| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  | Food searching          | User types in a food      |  Search results show matching user input                |                   |
|  2  | Search Result Data          | When user searches a food      | The data shown is decoded correctly (USDAFoodModels.swift)                 |                   |
|  3  | Full food details          |  When user hits a search food result                |  The next view shows the correct food details               |      |
|  4  | Branded foods          | When user is browsing through food results                 | The search view shows correct brands for that food the user searched for               |      |
|  5  | No search          | When the user searches with an empty search bar                 | User is not able to press search                |      |
|  6  | USDA failure           | User is within the search food section                | Failed USDA request doesn't crash the app and displays a message instead             |      |
|  7  | Invalid search input          |  User types random characters in the search bar               |  Search results end up blank, or try to get the closest related result              |      |

**HealthKit <--> Supabase (health_daily_stats)**
| #   | OBJECTIVE | INPUT | EXPECTED RESULTS | TEST DELIVERABLES |
| --: | --------- | ----- | ---------------- | ----------------- |
|  1  | Health data fetch for correct user          | The logged in user fetches their steps, active, and resting calories       |  The steps, active, and resting calories are connected to the user's ID in supabase                |                   |
|  2  | HealthKit data updates to the existing user in supabase(No duplicate rows for the same user)          |       |                  |                   |
|  3  | Different users in the same device         | User 1 logs out and User 2 signs in      |  In supabase there should be separate health_profiles                |                   |


USER-ACCEPTANCE TEST
--------------------

Verify that the solution works for potential user. Include the method (e.g.,
heuristic, performance measures, thinking aloud, observation, questionnaire, 
interviews, etc.), the number of participants and demographics, the concent
form, *scenarios*, scripts to read, and data collection methods.

### User-Acceptance Test Strategy

(Explain how user acceptance testing will be accomplished.)

### User-Acceptance Test Cases

| #   | TEST ITEM | EXPECTED RESULTS | ACTUAL RESULTS | DATE |
| --: | --------- | ---------------- | -------------- | ---- |
|  1  |           |                  |                |      |
|  2  |           |                  |                |      |


Test Deliverables
-----------------

(List test deliverables, and links to them if available, including the following.)

-   Test Plan (this document itself)
-   Test Scripts
-   Defect/Enhancement Logs
-   Test Result Reports


Schedule
--------

(Provide a summary of the testing schedule, specifying key test milestones, 
and/or provide a link to the detailed schedule.)

Risks
-----

-   (If any risks have been identified, list them here.)
-   (Specify the mitigation plan and the contingency plan for each risk.)


Appendix
--------

(Include any information that is helpful to reference.)
