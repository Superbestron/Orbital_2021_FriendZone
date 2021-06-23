# Milestone 2

Proposed level of achievement: **Artemis** <br>
Current level of achievement: **Apollo 11**

# What's new?
![WhatsApp Image 2021-06-22 at 11 48 32 PM](https://user-images.githubusercontent.com/65549665/122957322-66f77700-d3b4-11eb-923f-f2c8bb5d666b.jpeg)
<p align='center'>
  <i>Click</i>
  <a href="https://www.youtube.com/watch?v=OnY5jBn64zk&ab_channel=NgTzeHenn">
    <i>here</i>
  </a>
  <i>to watch it on YouTube</i>
</p>

Milestone 2 brought about many fundamental features and enabled the core functionality of FriendZone, i.e. to allow users to create and initiate events. There are hundreds of bug fixes and performance improvements too, but here are some of the big features in Milestone 2.

## Authorisation
Users can now create an account with their full name and email address. Afterwards, they can log in to browse, join and create events. Currently, we have only enabled signing in with email and password but we plan to have a feature to verify that the user creating an account on our app is a legitimate NUS student. This can be done via verification emails where the users will be required to verify their email address before doing anything on the app.

## Maps
Users are now able to find events near them. When clicking on the maps tab, the application would request for the permissions required to access the user's location. If access is granted, the map would be rendered with the user's location, along with events near the user as indicated by markers on the map. The markers are determined by the location field of the events when the events are created. The user can then click on the markers of the events for further details and actions. Events with no location specified or that are past would not show up on the maps as markers.

## Joining/Creating/Editing Events
Users can now confirm their attendance and their name will be registered in the database. They can even see their friends that are attending the event. If the current time is more than 48 hours away from the event, revoking of their attendance is made possible, to provide flexibility for users. This also gives other interested users a chance to attend instead of wasting a slot. Confirming attendance is disallowed if the event pax limit has been reached. In milestone 3, we would be looking to give the event initiator extra privileges such as seeing the attendee list for their event.

For the creation of events, users need to perform additional steps. Firstly, they need to choose the location from the list of locations given so that their event can be seen by other users on the Map Page. If the desired location cannot be found from the given list, users can choose “other” as the location but consequently their event will not be shown on map. However, we are planning to add more locations to the list in the future.

Users who are also event initiators can make changes to their event (name, date, time, etc.) as long as it is more than 48 hours away from the event. This provides flexibility to event initiators as well in case of last-minute plans. In the extreme case, deletion of the event is also possible.

## Notification Page
A notification system has been implemented to notify users of any important events. For example, a user is notified if there are any changes to the events that they have signed up with, regardless if it is due to a change in event details or a deletion of the event. Users will also be notified of any friend requests that they receive. Upcoming events and past events are also shown on the page for their reference. These provide 2 benefits. 

Firstly, in order to remind users of their impending event, a countdown timer is shown on each upcoming signed up event. Secondly, for past events that users attended, users will be able to view the list of all event attendees which will be the primary medium that users use to add each other as friends. This will be explained further in the section below. To illustrate the friend notification system briefly, let’s say user A adds user B as a friend, this action will send a friend request notification to user B. User B has the option to accept the friend request or to ignore it. If user B accepts it, a friend accepted notification will be sent back to user A to notify him that both are friends. 

However, all these notifications are in-app, i.e. users will not know that they receive a notification till they view the Notification Page. We may try to integrate with Android and IOS to push phone notifications additionally.

## Profile Page with Add Friend Feature
Each user will have their very own profile page filled with their own details like name and biography which will give a chance for other users to know people better. They are able to edit their profile to change or add in details, and they can even add a profile picture to make themselves more identifiable among the FriendZone community. In the future, we will also allow users to view their own friends list via their profile page.

Adding friends in FriendZone is a little different however because the ways to view other users’ profiles are more limited. Currently, users can only view other users who are planning to attend the same event if both of them are friends. So, the easiest way to add each other as friends is for both users to attend the same event together. Only after the event has ended when users can view all attendees of the event, then can they view attendees which are not their friends. Finally, users can then choose which of these people they want to add as friends. Currently, there is not a delete friend function implemented yet but we hope to do so in the future.

<p align="center">
  <a href="https://github.com/Superbestron/Orbital_2021_FriendZone/blob/master/assets/docs/milestone_2/poster.png">
    <img src="https://github.com/Superbestron/Orbital_2021_FriendZone/blob/master/assets/docs/milestone_2/poster.png" width="50%" height=auto>
</p>
  
<p align="center">
  Promotional poster
</p>

# About
FriendZone is an interactive and user-friendly platform for users to find like-minded people and meet up for various events.

# Key Features

<img align="right" src="assets/docs/milestone_2/events_near_you_demo.gif" height="400">

* **Find events around you**
  * **Search event by event name:** Users are able to use the search bar at the home page to find events base on event title, event description or event date.
  * **Indicate your interest:** Users can indicate interest in an event to mark their attendance before event becomes full. Initiators of events are not allowed to revoke their interests.
  * **Confirm your attendance:** After users confirm their attendance, they are not able to revoke their attendance 2 days before event starts.
  * **Join the telegram group:** Users can join the telegram group that is provided by the initiator by clicking on the "Join Telegram" button beside the attendance confirmation button to stay in touch with the organisers and other participants.
</br></br></br></br></br></br></br>


<img align="right" src="assets/docs/milestone_2/create_event_demo.gif" height="400">

* **Create a new event**
  * **Create an event you love:** Users can create an event if they do not find an event that they want to join.
  * **Choose the date:** Users have to choose a date and time for the event. Event will not show up on the event list in the home page after event has passed.
  * **Choose the location:** Initiators have the choice to choose a location from a set of locations in NUS. This will make their events visible on the maps section. Choosing others as location will only make the event visible in the event list and not on the maps.
  * **Set the maximum number of people:** Users can set the maximum number of people in the case where the event requires a fixed number of people. An example of such a case could happen when the initiator is looking for a total of 4 players to play card games.

</br></br></br></br></br></br></br>
* **Get points and level up**
  * Join events to get points
  * Create events to gain points
  * Show off your levels in your profile page


</br></br></br></br></br></br></br>
* **Let others know you better**
  * Add profile picture
  * Display your faculty
  * Showcase events attended

# User's Guide
In this guide, we will walk through the activities that you can do with FriendZone, as well as some of its core functionalities.

## Creating an account
In order to view, join and create events, you need to have a FriendZone account. Register for an account using your email and password. By creating an account, you also get the following benefits:
  * Ability to add friends
  * Notifications of event changes and friend requests
  * History of past events attended and a display of upcoming signed up events
  * Have your own profile page to display to other users

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123063857-5987ce80-d440-11eb-9d02-09f6cc396d66.png' width=350/>
</p>

Provide your **full name**, **email address** and **password** to create a new account. Your name and email address cannot be empty, and your password must be at least 6-characters long. Ensure that both passwords entered are the same. Tap on “Register” to create your account. If you want to return to the Sign In page, tap on "Back to Sign In".

## Logging into your account
If you already have an account, you can simply log into your account with your email and password. Tap “Sign In” to continue.
<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123066599-c8febd80-d442-11eb-8676-6288bb47efdb.png' width=350/>
</p>

## Navigating the Home screen
This is the main “Home screen” of FriendZone where all the upcoming events available for sign up are displayed. The user can swipe further up to see more events below. 
   * There is a search bar at the top of the page for you to search for a particular event based on **Name**, **Date**, **Time** and **Description**. 
   * Each event card shows various details of the event such as **Name**, **Date**, **Time**, **Current** number of users attending, **Maximum** number of attendees and an event **Icon**.
   * Each event card is tappable and tapping it will bring users to the Event Details screen.
At the bottom of the screen is the Navigation Bar. There are 5 possible main pages for you to navigate to: Home, Maps, Create Event, Notifications and Profile Page. Tapping on these buttons will bring you to the respective screens.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123069206-285dcd00-d445-11eb-8eac-567240907343.png' width=350/>
</p>

# Joining (or Un-Joining) an Event
After you have tapped on an event that you are interested to attend, you will be brought to the Event Details screen. Here, even more event details are shown, like the event **Initiator** and **Description**. If you have friends that have already signed up for this event, it will be displayed as a tappable card with their name, level and profile picture. Tapping on the card will bring you to that particular user’s profile page.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123069705-9bffda00-d445-11eb-9a71-4cdfcd67ae6f.png' width=350/>
</p>

There are 2 buttons shown on the screen, “Join Telegram” and “Confirm Attendance”. Tapping on “Join Telegram” will pop up a web link that brings you to the event telegram group chat, where you can chat with the event initiator and/or with other potential attendees. Tapping on “Confirm Attendance” will pop up a dialog box, asking you if you want to confirm your attendance for the event. 

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123070662-86d77b00-d446-11eb-9651-db3a0d9be21f.png' width=300/>
</p>

If you click on “Confirm”, the event pax will be updated with your attendance and it will be immediately reflected on the event page. Consequently, the button will change colour to a lighter orange and the button text will change to “Revoke Attendance”.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123070803-abcbee00-d446-11eb-9d00-1fee8ab04043.png' width=300/>
</p>

In the case where you have any last-minute plans and you cannot participate in the event that you have signed up for, simply click on the “Revoke Attendance” button and a dialog box will pop up, asking you if you want to revoke your attendance for the event. If you click on “Confirm”, the event pax will be updated with your withdrawal and it will be immediately reflected on the event page. Take note that withdrawals are only possible if the current time is more than 48 hours away from the event to give others sufficient time to indicate their attendance.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123071610-63610000-d447-11eb-81ce-8a74a91fc60d.png' width=300/>
</p>

If maximum capacity for a particular event is reached, you will not be able to join the event and the button is greyed out. If there is no telegram link provided by the initiator, the button will also be greyed out. Tapping on either of these button will have no effect.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123073854-60ffa580-d449-11eb-984d-eff31d3fbe00.png' width=300/>
</p>

## Maps
The Maps screen can be accessed via tapping on the “Maps” tab. Upon clicking the tab, the user would have to authorise tha application to use their location. If access is granted, a google-maps widget would be rendered and the user's location shown. The user would be able to see events near them as indicated by markers on the map. When the markers are clicked, a detailed view of the event is shown where the user can confirm their attendnace.

<p align="center">
  <img src='https://github.com/Superbestron/Orbital_2021_FriendZone/blob/maps/readme/assets/docs/milestone_2/user_guide/maps.jpg' width=300>
</p>

## Create Event
The Create Event screen can be accessed via tapping on the “Create Event” tab. You can create a new event by simply filling up the details of the event with its **Name**, **Date**, **Time**, **Description**, **Telegram Link** (optional), **Pax**, **Faculty**, and **Icon**. The default date, time, pax and icon are listed below respectively if you do not decide to change it. 
  * **Date**: 7 days away from the date now
  * **Time**: Time now
  * **Pax**: 2
  * **Location**: Others (Note that this option would mean that your event will not show up on Maps)
  * **Icon**: First Icon from the left

<p align="center">
  <img src='https://user-images.githubusercontent.com/65549665/123074001-855b8200-d449-11eb-821e-e3c9ace9f290.png' width=300/>
  <img src='https://user-images.githubusercontent.com/65549665/123074336-c6ec2d00-d449-11eb-9ff4-5661d1f835aa.png' width=300/>
</p>

For the rest of the other fields, it cannot be left blank except for the telegram link. Simply leave the telegram link field blank if you do not wish to create a Telegram group for this event. Any other text that you input into the field will be interpreted as a link and a potentially broken link could be sent to the user if it is not a valid Telegram Link. Once you are done entering the event details, tap on the "Plus" button to create an event and a snackbar will pop up from the bottom of the screen, indicating success. However, if you realised that you had made a mistake in entering the event details, quickly press the “undo” button on the snackbar to delete the event immediately. The snackbar will disappear automatically after 4 seconds.

## Edit Event
If you are the initiator of a particular event, a pencil button will appear at the bottom right hand corner of the screen on the Event Details screen. Tapping that button will bring you to a page where you can edit the details of the event. Take note that only certain fields are changeable. For example, you will not be allowed to change the event pax to a number smaller than the current pax. After you have made your changes, tap on the check button to save your changes. You can even delete the event by tapping on the trash button. Changing the event details or deleting the event completely will automatically send a notification to all signed up attendees so please do so sparingly. The changes will be automatically reflected. You may double-check in the Event List page by tapping on the “Home” tab.

<p align="center">
  <img src='https://user-images.githubusercontent.com/65549665/123074986-60b3da00-d44a-11eb-9f73-4a5e879673c8.png' width=300/>
  <img src='https://user-images.githubusercontent.com/65549665/123078014-24ce4400-d44d-11eb-8c88-cdbd1e9a2eaa.png' width=300/>
</p>

## Notifications
The Notifications screen can be accessed via tapping on the “Notifications” tab. You can see your notifications on the top of the screen (if you have any). There are generally 2 types of notifications: Event Changes and Friends-related requests. For event changes, you can tap on the notification to view the updated event details. For friend-related requests, tapping on it will bring you to the user’s profile page. To delete notifications, simply swipe the notification card to the left or right of the screen.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123078890-00269c00-d44e-11eb-8b12-a6a53f62160e.png' width=300/>
</p>

Upcoming events are also shown with a countdown timer to remind you of your impending signed up events. Tapping on the event card will bring you to the Event Details screen.

Past events that you have attended are shown below as well. You will be able to see the list of all attendees if you tap on the event card. Here you can choose to add them as friends.

<p align="center">
 <img src='https://user-images.githubusercontent.com/65549665/123079056-264c3c00-d44e-11eb-82bb-98d8b3beca67.png' width=300/>
 <img src='https://user-images.githubusercontent.com/65549665/123079118-36641b80-d44e-11eb-82af-be43265ce0bf.png' width=300/>
</p>

## Personal Profile
The Profile screen can be accessed via tapping on the “Profile” tab. You can see your own profile details here. You may edit your profile details by tapping on the pencil icon near your profile picture, which will bring you to the “Edit Profile” page. 

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123079396-7c20e400-d44e-11eb-8d6f-8e53f23f8d4a.png' width=300/>
</p>

Here, you can upload a new profile picture, change your **name**, **faculty** and **biography**. Tapping on the “Remove Profile Image” button will remove your current saved profile picture if you want to use the default profile picture (a greyed body). After you are done editing your profile details, tap on the “Save” button to save your changes.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123079574-a83c6500-d44e-11eb-980b-0db2baf48856.png' width=300/>
  <img src='https://user-images.githubusercontent.com/65549665/123079639-b5f1ea80-d44e-11eb-8d9c-443ef0ca5c97.png' width=300/>
</p>

## Friends’ Profiles
This has a similar layout to your personal profile but depending on whether you are friends with the user, there will be different buttons shown below the user’s name. 

If you are not friends with that user yet, you have the option to add him as a friend by tapping the “Add Friend” button. A friend request notification will be sent to him. If you have received a friend request from that user, you have the option to accept his friend request by tapping the “Accept Friend Request” button.

<p align="center">
  <img src='https://user-images.githubusercontent.com/65549665/123080154-36185000-d44f-11eb-8a77-f8a29ab5f77e.png' width=300/>
  <img src='https://user-images.githubusercontent.com/65549665/123080269-534d1e80-d44f-11eb-85ec-dfb373c79ce8.png' width=300/>
</p>

 After tapping the button, both of you will become friends and you will be able to see each other's profiles appear in the “Friends Attending” section of the Event Details screen if both of you have signed up for the same event.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123080523-97402380-d44f-11eb-8de7-2d3fab35ded1.png' width=300/>
</p>

## Logout
If you want to log out of your account, tap the “Logout” button on the top right corner located at every main page (Home, Maps, Create Event, Notifications, Profile). You will be brought back to the login page.

<p align="center">
   <img src='https://user-images.githubusercontent.com/65549665/123080887-faca5100-d44f-11eb-9af1-331a55bf1dbb.png' width=300/>
</p>

# Built with
* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [Google Maps Platform](https://developers.google.com/maps)
