# Milestone 2

Proposed level of achievement: **Artemis** <br>
Current level of achievement: **Apollo**

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
To be filled up.

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

<https://user-images.githubusercontent.com/60974969/120209975-da004880-c261-11eb-80b6-487144f7b00e.mp4>

<p align="center">
  Demonstration video
</p>


<p align="center">
  <a href="https://github.com/Superbestron/Orbital_2021_FriendZone/blob/master/assets/docs/milestone_2/poster.png">
    <img src="https://github.com/Superbestron/Orbital_2021_FriendZone/blob/master/assets/docs/milestone_2/poster.png" width="50%" height=auto>
</p>
  
<p align="center">
  Promotional poster
</p>

## About
FriendZone is an interactive and user-friendly platform for users to find like-minded people and meet up for various events.

## Features

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

## Built with
* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [Google Maps Platform](https://developers.google.com/maps)
