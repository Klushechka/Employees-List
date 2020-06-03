# EmployeesList

Employees List is a test application with two screens. The first one shows the list of employees from two offices who are grouped by their positions. Positions are sorted alphabetically. Employees inside groups are sorted by last name. The list of employees is refreshable. Swiping down the table triggers updating the list.

After tapping an employee cell a user sees a details screen with additional information about an employee: name, surname, position, phone, email and projects.

### Local Contacts

Right after starting the app an alert with Contacts permission request is shown. If a user allows the access, then in employees list and on details screen a button for opening local Contacts page is shown. It is enabled for employees from the list whose name + surname match with local contacts full names. After tapping the button user sees the page of selected employee in the Contacts page.

If a user doesn’t allow the app to fetch local contacts, then the button is hidden in both places. The access state can be changed on system preferences -> Employees -> Contacts page. Then while coming back to the app the button will be shown again on both screens. 

While reinstalling the app an alert with Contacts permission request is now shown. As the state of Employees List access to Contacts gets saved in the system. 

### Caching

The list of employees gets cached into a file after being received from server. Cached data is shown while starting the app in the offline. When a new data is received, cached data gets updated with it. 

### Errors

In case of errors a general error alert is shown saying that something went wrong and suggestion to try again later.

Errors descriptions are printed in Xcode console.

### Search

User can perform search over the list of employees. It finds matches by all employees data: name, surname, position, phone, email, projects. If no matching results are found, then a userfriendly placeholder is shown instead. 

### Unit Tests

Unit tests for caching functionality are placed in EmployeesTests folder inside of the project. 

If you have any questions or suggestions, please reach me via klyushkina.olga@gmail.com.
