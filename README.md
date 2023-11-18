###############################

Name-Diptangshu Chattopadhyay

2022mt93547

###############################

Steps to host the App

1) Download the Github repository
2) Download, unzip and install Flutter 
3) Open Environment Variable, and create a new full path to flutter\bin under Path variable
4) Run flutter doctor to check all system dependencies to run the app are properly installed or not .
5) Enter the downloaded repository directory and do flutter pub get 
6) Run the command flutter run
7) Select any of the connected devices from the list

BONUS FEATURE IMPLEMENTED-
Task Deletion Feature

APP STRUCTURE EXPLANATION
################################

Dependencies-The Todo app depends on the parse_server_sdk_flutter package, which provides functionalities to interact with Parse Server.


################################

Main Function- The main() function initializes the Parse SDK using our Parse Server credentials which are available at back4app dashboard. After initialization, it runs the Flutter app with a MaterialApp.

################################

Home Page-The Home class is a stateful widget representing the main screen of the app. It contains two mandatory TextField to input new to-do items and description along with a 'ADD' button to add. The list of to-do items and description are displayed below using a ListView.builder inside a FutureBuilder

#################################

Functions-

addToDo(): Adds a new to-do item and description. If the input of either field is empty, it displays a an "Cannot be Empty" message.

saveTodo(): Simulates saving a to-do item. It makes new instance of the Parse Todo class with the command final todo = ParseObject('Todo')
      ..set('title', title)
      ..set('description', description)
      ..set('done', false);
and use set function to set the parameters(title and description) for this object. Finally it calls the save function to save the task in our back4app database.

getTodo(): Simulates fetching a list of to-do items. The function creates an instance of Parse’s Query class. Performs a query search using query() method and returns a list of Todo objects if search is successful. If object is not found, the value success is false, and results are displayed null.

updateTodo(): Simulates updating the completion status of a to-do item. This function is creating a new instance of Parse Todo class with the command var todo = ParseObject('Todo').
After that it is setting the objectId of ParseObject that is to be be updated. It then Uses the set function to modify the parameters done when our task is done. Finally it Calls the save function, which will push the changes to database.

deleteTodo(): Simulates deleting a to-do item. The function makes a new instance of Parse Todo class with command ParseObject('Todo').
Using the objectId property it sets objectId of ParseObject which is to be removed. Finally it calls the delete function, which will remove the task from Parse Dashboard database.

################################

UI Components
Every to-do item and its description in the list is displayed in the form of a  ListTile.
The title of the to-do, the description of to-do, a checkbox to mark completion status, and a delete button are displayed in each ListTile.
Completion status of the to-do item is marked by the ticking of checkbox and the color of the leading CircleAvatar turning from yellow to green.

##################################






