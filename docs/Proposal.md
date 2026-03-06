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

This app will track the user's calories and monitor how many calories are consumed and burned through exercise and diet. The user will first create their account with an email and password. Clerk, an authentication service, will be used to ensure a secure login. When the user is done signing up, the app will ask for their age, height, and weight. Then, it will ask for the user's goals, including a future weight loss plan by predicting how much weight the user will gain or lose based on the food consumed. The user interface will be user-friendly and easy to navigate, with an option to customize the background.

Another feature is the implementation of BMR calculations. BMR, or Basal Metabolic Rate, is the minimum amount of calories needed to function properly at a basic level. This piece of information will be useful to get the user an idea of their caloric needs. For logging in food, it will be pulled from the USDA FoodData Central API. In addition to that, users will have the ability to generate a meal plan using AI. 

Users will be able to use their smart watch to track how many calories are burned through exercise or general movement. Since the app is already tracking their calories, the user can regularly update their weight to view their progress through visual charts. For data security, HTTPS (Hypertext Transfer Protocol Secure) will be implemented as well. Finally, for gamification, there will be a rank system included. Typically in gaming, there are ranked modes in competitive games like Call of Duty, Rainbow Six Siege, Valorant, etc. The ranks will consist of Bronze, Silver, Gold, Platinum, Emerald, Diamond, and Champion. Ranks will be tailored to their goals to make it fair, and users can earn points by hitting set goals every week.


Proposed Implementation Language(s) 
-----------------------------------

- Html
- CSS
- Javascript


Libraries, Packages, Development Kits, etc., to be used in the proposed implementation language(s)
--------------------------------------------------------------------------------------------------

- Terra.js
- Clerk 


Additional Software/Equipment Needed
------------------------------------

- VS Codium/ Apache NetBeans
- Fitness Device
- Node.js with express
- Terra 
- Xcode
- Capacitor

Alternative Solutions and Rationale 🔍
--------------------------------------

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


|**Criteria** | **Alternative Solution 1: Java** | **Chosen Solution: Webstack** |
|:------------| :------------------------------: | :---------------------------: |
| **Feasibility** | Challenging to connect APIs. Would have to go through more obstacles to get it to run with both android and apple | Built to work with the internet and APIs. Less challenging to work with both android and ios
| **Performance** | Faster than the webstack but not lightweight | Slightly slower but lightweight |
| **Scalabiity** | Lots of work to maintain two separate codes for android and ios | Much better to update as android studio and xcode share the same code | 
**Cost** | Free but requires a mac to run xcode for ios development | Free but requires a mac to run xcode for ios development | 
| **Usability** | Customizable but outdated feel to the user | Highly customizable thanks to HTML and CSS. Can look modern and user-friendly



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
- Implement Terra API for fitness devices
- Learn more about Android Studio and Xcode
- Learn more about capacitor

Schedule 📅
-----------


*   Spring 2026 - CSCI 497
    -   January 26 - Come up with project idea
    -   February 9 - Research what's needed
    -   February 23 - Think of ways to implement project idea
    -   March 2 - Send first-draft of the proposal to advisor for feedback
    -   April 5 - Send draft of required documents and receive feedback
    -   April 13 - Send completed proposal and requirements document

* Summer 2026
    - Get a macbook as Xcode requires macos
    - Research

*   Fall 2026 - CSCI 498
    -   October 20 - Research (**Ask for advice and feedback**)
    -   October 27 - Review what's required for designing the project (**Ask for advice and feedback**)
    -   November 3 - Research (**Ask for advice and feedback**)
    -   November 10 - Implement design (**Ask for advice and feedback**)
    -   November 17 - Implement design (**Ask for advice and feedback**)
    -   November 20 - Turn in final design (**Ask for advice and feedback**)

*   Spring 2040 - CSCI 499 (more details will be added here once you are closer)
    -   Weeks 1-4 - Implement test plan
    -   Week 5 - Evaluate test results
    -   Week 6-10 - Apply updates and bug fixes based on the results
    -   Week 8 - Complete the first 4 chapters of the defense documentation.


References 📚
-------------

https://my.clevelandclinic.org/health/body/basal-metabolic-rate-bmr

https://www.cloudflare.com/learning/ssl/what-is-https/

https://fdc.nal.usda.gov/api-guide

https://clerk.com/user-authentication

https://docs.tryterra.co/

https://clerk.com/docs/reference/javascript/overview

https://nodejs.org/en

https://expressjs.com/

https://terra-money.github.io/terra.js/

https://twentyideas.com/blog/health-web-app-vs-mobile-app

https://capacitorjs.com/

https://www.codenameone.com/blog/how-to-build-ios-apps-with-java/#:~:text=Before%20we%20delve%20any%20further,React%20Native%20and%20Codename%20One.

https://developer.apple.com/documentation/xcode 

https://developer.android.com/

https://www.iubenda.com/en/blog/android-studio-vs-xcode-pros-and-cons-of-each-application-development-platform/#:~:text=While%20Android%20Studio%20is%20better,seamless%20integration%20with%20Apple%20services.