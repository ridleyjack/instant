# Instant Degree
Instant Degree web site for our cosc304 project

**Configuring the project to use your database!**
1) go to Java_Resources/ridleyjack.insta.data/LoadData.java and change the username, password, database fields like in lab 7, except
  use your mysql db not use the microsoft sql one.
2) go to WebContent/META-INF/context.xml The connection pool is configured in there. Open the xml with a text editor or something and change
the username, password and url fields.

**Using The Thread Pool!**

Import the Database servlet I  made like so..
<%@ page import="ridleyjack.insta.data.Database" %> 

Then simply write..
Connection con = Database.getConnection()
Remember to close it though, preferably using try(Connection con = Database.getConnection()){} catch(SQLException ex){}

**Html And Java Code Organizationn!**
1) Apparently it makes the code easier to read if you try and keep java / html code in seperate files.
I have being doing this a bit by making a servlet called somethingForm.jsp with the HTML stuff and another filed called 
something.jsp containing the logic. (but you can make web pages how ever you want)

2) If you want to avoid mixing html/java there is a library I have included called jstl.
To use it write this..
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
Look at listprod and listprodForm for an example.

**Other Notes**
If anybody doesn't like doing the coding stuff they can focus more on making the site look good. You would mostly just need
to play around with the .css and html and maybe make some graphics or something.
