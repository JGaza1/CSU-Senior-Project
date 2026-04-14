# Software Requirements Specification

## Project Name
**Project Health**

## Requirement Author
**Joseph Gaza**

## Version
 **v1.0**

## Date
**2026-04-07**

---

## Requirement: <ID>

**ID:**  
HTF-01

**Type:**  
**Functional**

**Description:**  
Users will create an account using their email and password.

**Rationale:**  
To keep track of their account and health data

**Fit Criterion:**  
In order to not lose your data, create an account to save it

**Priority:**  

|**High**|

**Dependencies:**  

None

---

## Requirement: <ID>

**ID:**  
HTF-02

**Type:**  
**Functional**

**Description:**  
Users will be asked for their age, weight, height, and their goals

**Rationale:**  
To log in physical stats of the user

**Fit Criterion:**  
Upon logging in the app will ask to enter their body metrics

**Priority:**  

|**High**|

**Dependencies:**  
<List the ID(s) of any requirement(s) that must be implemented or satisfied before this one, or write “None”.>

- HTF-01

---

**ID:**  
HTF-02a

**Type:**  
**Functional**

**Description:**  
A future weight/loss plan will be asked to the user. Additionally the user will be asked the deadline in which they want to achieve ther goal whether that is in days, months, or years.

**Rationale:**  
To acquire the user's goal in terms of weight

**Fit Criterion:**  
If the user wants to lose weight by going from 230 to 180 in 6 months, they can type that in to log the goal

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-09

---

**ID:**  
HTF-02b

**Type:**  
**Functional**

**Description:**  
Based on the weight plan/goal, the app will calculate how many pounds required to lose/gain in a month, week, or year

**Rationale:**  
Acurrately show whats needed to go through with the weight plan/goal

**Fit Criterion:**  
If the user wants to gain weight by going from 130 to 150 in 6 months, the app would show how many pounds they would need to gain in a month, week, or year depending on the time length of that certain goal.

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02

---

## Requirement: <ID>

**ID:**  
HT-03

**Type:**  
**Functional**

**Description:**  
Once an apple watch is connected the user's bmr will be acquired thanks to Apple HealthKit

**Rationale:**  
To get the range at which your calories burn when performing basic functions

**Fit Criterion:**  
Asking the user for permission to track their basal metabolic rate. If the user says yes, the bmr will be logged to that user. Should the user say no then inaccurate readings may occur.

**Priority:**  
|**High**|

**Dependencies:**  
- HTF-01
- HTF-02
- HTF-09

---

## Requirement: <ID>

**ID:**  
HTF-04

**Type:**  
**Functional**

**Description:**  
The app must pull accurate food data from the USDA FoodData Central API

**Rationale:**  
Storing true and accurate nutritional facts

**Fit Criterion:**  
Instead of users manually entering how much calories a certain food is, the app will have the correct calories for a certain item thanks to the USDA FoodData Central API

**Priority:**  

|**Medium**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03

---

## Requirement: <ID>

**ID:**  
HTF-05

**Type:**  
**Functional**

**Description:**  
If the user cannot find a specific food item or they have made a home-cooked meal, manually logging in the calories is required

**Rationale:**  
To stil have calories tracked regardless of what food item it is

**Fit Criterion:**  
The user made home-made spaghetti, but the user can't find spaghetti or the calories aren't aligned with what she put on the food, ate, etc., so the option to manual insert calories is selected.

**Priority:**  

|**Medium**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03


---

## Requirement: <ID>

**ID:**  
HTF-06

**Type:**  
**Functional**

**Description:**  
The app will calculate net calories to get an overview of their progression. This is done by calculating the calories consumed - (BMR + calories burned)

**Rationale:**  
To accurately get the calories to add in to their daily caloric intake

**Fit Criterion:**  
The user logged in that they ate eggs, bacon, and toast for breakfast after running a mile, so the app will calculate to get their net calories

**Priority:**  

|**High**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03 
- HTF-04 or HTF-05
- HTF-09

---

## Requirement: <ID>

**ID:**  
HTF-07

**Type:**  
**Functional**

**Description:**  
Allows the user to customize their background or theme of the user interface

**Rationale:**  
To create a unique feel to the user as they look at the user interface

**Fit Criterion:**  
Creating a gold color background with navy blue accents (CSU colors)

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01

---

## Requirement: <ID>

**ID:**  
HTF-08

**Type:**  
**Functional**

**Description:**  
Show charts to display progression related to calories, weight, etc..

**Rationale:**  
To show a different form of progression visualized through charts

**Fit Criterion:**  
If calorie intake today was greater than the calorie intake from yesterday, the chart will show an increase in calories consumed

**Priority:**  

|**Medium**|

**Dependencies:**  

- HTF-01
- HTF-09

---

## Requirement: <ID>

**ID:**  
HTF-09

**Type:**  
**Functional**

**Description:**  
The app will automatically track the calories burned with apple healthkit

**Rationale:**  
In order for the app to function to its purpose, the calories must be tracked with the apple watch

**Fit Criterion:**  
As long as the watch is on the user, calories will be tracked whether their exercising or not

**Priority:**  

|**High**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03
- HTF-09

---

## Requirement: <ID>

**ID:**  
HTF-09a

**Type:**  
**Functional**

**Description:**  
The app will track the user's daily steps

**Rationale:**  
To show how many steps have been taken to do a certain task or just basic functions

**Fit Criterion:**  
The user took 1000 steps walking in New York City as a tourist

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-09
---

## Requirement: <ID>

**ID:**  
HTF-10

**Type:**  
**Functional**

**Description:**  
Google gemini can be used to generate meal plans for the user to help achieve the user's goals

**Rationale:**  
If the user is unsure what to eat in order to lose or gain weight, AI can be used to generate a meal plan.

**Fit Criterion:**  
Ai is being asked to generate a meal plan to go from 130 to 150 in 6 months. Gemini will have a list on what food to eat for breakfast, lunch, dinner, and any snacks to progress further into weight goal.

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03
- HTF-06
- HTF-09
---

## Requirement: <ID>

**ID:**  
HTF-11

**Type:**  
**Functional**

**Description:**  
Google gemini can be used to generate meal plans for the user to help achieve the user's goals

**Rationale:**  
If the user is unsure what to eat in order to lose or gain weight, AI can be used to generate a meal plan.

**Fit Criterion:**  
Ai is being asked to generate a meal plan to go from 130 to 150 in 6 months. Gemini will have a list on what food to eat for breakfast, lunch, dinner, and any snacks to progress further into weight goal.

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03
- HTF-06
- HTF-09
---

## Requirement: <ID>

**ID:**  
HTF-12

**Type:**  
**Functional**

**Description:**  
For gamification, the user can earn in game resources from staying consistent with their goals or daily login and be able to "craft" unique cosmetics provided
**Rationale:**  
To create a fun experience and to make the users work towards something else besides their fitness goals

**Fit Criterion:**  
The user has hit their weekly requirement related to their goal. A congratulations message will pop and will reward them with a random item. They have earned a titan crystal. One titan crystal is needed to craft an Attack On Titan themed UI with an Attack On Titan profile picture

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03
- HTF-06
- HTF-09
---

## Requirement: <ID>

**ID:**  
HTF-12a

**Type:**  
**Functional**

**Description:**  
Have a resource system for gamification

**Rationale:**  
To store certain in game resources for the gamification

**Fit Criterion:**  
There will be a certain amount of resources in the game to craft a specific UI. Each UI will require specific resources to make. For example, a star wars UI will need to have star wars related resources in order to make it

**Priority:**  

|**Low**|

**Dependencies:**  

- HTF-01
- HTF-02
- HTF-03
- HTF-06
- HTF-09
---

## Requirement: <ID>

**ID:**  
HTU-1

**Type:**  
**Usability**

**Description:**  
This app will motivate users to meet their fitness goals

**Rationale:**  
To store certain in game resources for the gamification

**Fit Criterion:**  
There will be a certain amount of resources in the game to craft a specific UI. Each UI will require specific resources to make. For example, a star wars UI will need to have star wars related resources in order to make it

**Priority:**  

|**High**|

**Dependencies:**  

---

## Requirement: <ID>

**ID:**  
HTA-01

**Type:**  
**Appearance & Style**

**Description:**  
The user interface will have a modern theme to it similar to apple's theme. The menu will be well organized and simple

**Rationale:**  
To not overwhelm users

**Fit Criterion:**  
If the user wants to log in their calorie intake there will be a tab to get there instead of going through multiple tabs

**Priority:**  

|**High**|

**Dependencies:**  

None

---

## Requirement: <ID>

**ID:**  
HTU-02

**Type:**  
**Usability**

**Description:**  
On average this app will be suitable for ages 14 and up to use.

**Rationale:**  
To not make it overly complicated for all ages

**Fit Criterion:**  
in the main menu there will be a question mark. Upon clicking it, there will be a page explaining what calories are and how they affect your body.

**Priority:**  

|**High**|

**Dependencies:**  
None

---

## Requirement: <ID>

**ID:**  
HTP-01

**Type:**  
**Performance**

**Description:**  
All of the UI animations and charts will show at a consistent rate of 60 fps or 120 fps depending on the apple device

**Rationale:**  
To make it smooth and consistent for users

**Fit Criterion:**  
Swiping from the main menu to the charts will be smooth with little to no stuttering

**Priority:**  

|**High**|

**Dependencies:**  
None

---

## Requirement: <ID>

**ID:**  
HTP-02

**Type:**  
**Performance**

**Description:**  
All of the UI animations and charts will show at a consistent rate of 60 fps or 120 fps depending on the apple device

**Rationale:**  
To make it smooth and consistent for users

**Fit Criterion:**  
Swiping from the main menu to the charts will be smooth with little to no stuttering

**Priority:**  

|**High**|

**Dependencies:**  
None

---
