Project Health
===================================================

**Student Name(s)**: Joseph Gaza 
**Degree and Major**: B.S. in Computer Science
**Project Advisor Name**: Dr. Hayes
**Expected Graduation Date**: August 2027


Problem Statement
-----------------

The ability to track your overall health, especially calories, would be effective in helping us to live healthy lives. Unfortunately, everybody’s body works differently, we all have different eating habits, etc.., So it’s hard to track if you’re getting the right nutrition, calories, and exercise. Everyone has their own height, weight, metabolism, and daily habits. Thus, having an app that tracks your health can eliminate the need to wonder where you stand in health. This benefits the user by tracking what they eat or what to do in terms of exercising to achieve their goals. Tracking this data can lead to a better understanding of how our body responds to exercising and what food is eaten.


Project Description
-------------------

An app that tracks user's calories and monitors how many calories consumed and burned through exercise and diet. The user will first create their account with an email and password. Clerk, which is an authentication service, will be used to ensure a secure login. and when the user is done signing up, it will ask for their age, height, and weight. Then it will ask for the user's goals including  The app will contain many features including a future weight loss plan by predicting how much weight the user will gain or lose based on the food consumed. The user interface will be user friendly and easy to navigate. There can be an option to customize the background.
Another feature is the implementation of BMR calculations. BMR or Basal Metabolic Rate is the minimum amount of calories needed to function properly at a basic level. This piece of information will be useful to show to get the user an idea of their calories. For food it will be pulled from the USDA FoodData Central API. In addition to that users have the ability to generate a meal plan from using AI. 
Users will be able to use their smart watch to track how many calories are burned through exercise or movement in general. There will be progress shown for goals. For example, since the app is already tracking their calories, the user can enter their weight again for a more accurate progress while including charts. For data security, HTTPS or Hypertext Transfer Protocol Secure which is needed for data security, will be implemented as well. For gamification, there will be a rank system included. Typically in gaming there are ranked modes in competitive games including games like Call of Duty, Rainbow Six siege, Valorant, etc.. The ranks will consist of bronze, silver, gold, platinum, emerald, diamond, and champion. They will be tailored to your goals to make it fair. Points will be included in order to know what rank you are in. Points will be earned by hitting set goals every week.


Proposed Implementation Language(s) 
-----------------------------------

Html
CSS
Javascript


Libraries, Packages, Development Kits, etc., to be used in the proposed implementation language(s)
--------------------------------------------------------------------------------------------------

The supporting libraries go here.


Additional Software/Equipment Needed
------------------------------------

VS Codium/ Apache NetBeans
Fitness Device
Clerk

Alternative Solutions and Rationale 🔍
--------------------------------------

> **Purpose**: Describe at least two alternative solutions or approaches to your project. Compare these with your chosen solution based on relevant criteria (e.g., feasibility, scalability, cost, performance, usability). Explain why you selected your final approach.

### Alternative 1
- **Description**:  
  The app would be produced strictly with Java. The ui would be designed with JFrame
- **Pros**:  
  - Everything would be Java related in terms of code
  - Familiar with the basics of JFrame 
- **Cons**:  
   - The design would look very old-fashioned and "retro"
    - JFrame wouldn't work on mobile

### Chosen Solution and Rationale
- **Chosen Solution**:  
 Health app created with HTML, CSS, and Javasript. And make it work with a fitness device.
- **Rationale**:  
  - This solution would fully utilize the health app in tracking calories.
  - UI would look modern and user friendly

> 💡 *Tip: Consider using a comparison table to evaluate trade-offs across multiple criteria such as feasibility, performance, scalability, cost, and usability.*


Personal Motivation
-------------------

My personal motivation for this project is to track my own fitness journey to gain weight and build muscle. 

Outline of Future Research Efforts
----------------------------------

- Need to learn how to make the app work with a fitness device
- Learn more in depth about html and css to fully utilize the ui design
- Learn how to use implement data security and privacy (HTTPS)
- Learning how to use and implement Clerk
- Learn how to implement AI to generate meal plan

Schedule 📅
-----------


*   Spring 2026 - CSCI 497
    -   January 26 - 
    -   February 9 - 
    -   February 23 -  
    -   March 2 - Send First-Draft of the Requirements Document to advisor for feedback
    -   April 5 - 

*   Fall 2026 - CSCI 498
    -   October 20 - Design
    -   October 27 - 
    -   November 3 - 
    -   November 10 - Implement 
    -   November 17 - 
    -   November 20 - 

*   Spring 2040 - CSCI 499 (more details will be added here once you are closer)
    -   Weeks 1-4 - Implement test plan
    -   Week 5 - Evaluate test results
    -   Week 6-10 - Apply updates and bug fixes based on the results
    -   Week 8 - Complete the first 4 chapters of the defense documentation.
    -   Add the rest…


References 📚
-------------

> List any references you cited in this proposal.

https://my.clevelandclinic.org/health/body/basal-metabolic-rate-bmr

https://www.cloudflare.com/learning/ssl/what-is-https/

https://fdc.nal.usda.gov/api-guide

https://clerk.com/user-authentication