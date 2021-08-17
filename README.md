# movieRatingWebsite
This is a Y3S1 group project about applying JavaEE concept to develop a moving rating website.

# Abstract
The aim is to design a workable movie rating website that allow user to browse movie’s details, rate and review the movie. At the same time, all of the rating given will be used to calculate the score of the movie. In addition, admin can add and edit the movie’s details as well just like the conventional website in the market.

# Primary focus (what is to be addressed by the project)
* Users are able to give rating and write comment for every movie
* Users can only have one review per movie
* Users can edit their reviews
* System are able to show correct movie’s details and score dynamically

# Architecture
![image](https://user-images.githubusercontent.com/52621677/129656790-69fb2a7f-704e-4162-bdd6-971a4dbf2774.png)

# Screenshot & Description
## i. REGISTER
![image](https://user-images.githubusercontent.com/52621677/129657491-41eeb19a-4b62-4d64-a84f-013806dd5eb3.png)
1.	Fill in desired username
2.	Fill in desired password
3.	Fill in password again
4.	Click ‘sign up’ button
5.	If already have account, click link below to direct to login page.

Exceptional cases:
*	If input box is empty: remind message will pops up
*	If username already existed in database: alert box will pop up

## ii. LOGIN
![image](https://user-images.githubusercontent.com/52621677/129657542-e63c8cac-47e9-4654-b75e-b174effd6161.png)
1.	Fill in username
2.	Fill in password
3.	Click ‘submit’ button
4.	If no account yet, click the link below to create an account

Exceptional cases:
* If input box is empty: reminder message will pop up
* If user is forbidden: alert box will pop up and prevent user from entering the website
* If username or password incorrect: alert box pops up

## iii.	BROWSE HOME PAGE
![image](https://user-images.githubusercontent.com/52621677/129657614-15e0f480-508d-46c3-b21e-da94e563c8de.png)
![image](https://user-images.githubusercontent.com/52621677/129657670-807d200e-d863-426f-8c97-04b0c7c006aa.png)

## iv.	SEARCH MOVIE
![image](https://user-images.githubusercontent.com/52621677/129657691-04d6d0a0-d8ea-493a-9ff4-f083c61105f3.png)

![image](https://user-images.githubusercontent.com/52621677/129657696-183fe015-6d23-4d53-92b4-26209d9fbba5.png)

1.	Enter movie name (partially or fully) on the search bar
2.	Enter or click on the search icon
3.	It will show the results

Exceptional cases:
*	Lower and upper case are the same
*	If nothing is entered, all of the movies will be shown
*	If the movie does not exist, no movies will be shown.

## v.	BROWSE MOVIE
![image](https://user-images.githubusercontent.com/52621677/129657728-be4426f6-a76a-4a30-a0e8-2d00246fd192.png)
>	Browse director/actor page

![image](https://user-images.githubusercontent.com/52621677/129657739-ab50a5e5-0d1d-425c-9201-9dc4890a7e4c.png)
>	Add comment (Below the movie description)

![image](https://user-images.githubusercontent.com/52621677/129657757-3ed00737-142a-4f5c-be5e-63247bc8a9da.png)
> Edit comment

![image](https://user-images.githubusercontent.com/52621677/129657955-d0f27437-ce84-45a1-afec-9d17bda056ad.png)

## vi.	USER PROFILE PAGE
![image](https://user-images.githubusercontent.com/52621677/129657982-288564ed-e54a-49e1-a35f-498eba8fd19e.png)

![image](https://user-images.githubusercontent.com/52621677/129657990-497f2bba-b67a-4748-beb4-dbeeb34f647a.png)

## vii.	FILTER/SORT MOVIE
![image](https://user-images.githubusercontent.com/52621677/129658005-591cff96-0c18-4f9a-b13b-c772475af1d7.png)
1.	Choose any filtering combination you wish [Genre, Language, Sort by]
2.	The result will be display in a short while

## viii.	ADMIN
> Manage user privilege

![image](https://user-images.githubusercontent.com/52621677/129658039-9189af2b-365c-4a63-a127-a1b4abf83076.png)
1.	Free to choose between ‘Promote’, ‘Degrade’, and ‘Forbidden’
2.	The status of selected user will be updated immediately

> Add movie

![image](https://user-images.githubusercontent.com/52621677/129658064-c5b28cba-84d6-4a4d-9d15-c9d66c66fd05.png)

1.	Fill in the movie’s detail
2.	Press ‘Submit’ button when completed
3.	New movie will be added and display at the table below
4.	[Bonus] You may edit or delete any movie you want at the table below by clicking the ‘Edit’ or ‘Del’ operation

Exceptional cases:
*	If any input box is empty: reminder message will pop up
*	For genre: ‘Action’ will be the default option if nothing selected
*	If anything, other than ‘Chinese’, ‘English’, ‘Japanese’ was key in in the Language input box: the movie added will be classified as ‘Other’

> Edit Movie

![image](https://user-images.githubusercontent.com/52621677/129658112-bba4eb14-a28d-4e69-b537-6b9896d7db7d.png)
1.	The movie detail previously written will be shown
2.	Free to edit any content
3.	Press ‘Submit’ button to make the changes to the database
4.	[Bonus] You may click the ‘Reset’ button to reverse the content back to its original state

Exceptional cases:
*	If any input box is empty: reminder message will pop up



