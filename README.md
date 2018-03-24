# Instant Degree
Instant Degree web site for our cosc304 project

  This website was create by Zach, Spencer, Thomas and I for our cosc304 project. It was written before I knew how to use git properly so all the commits are to the master branch. Nobody else wanted to learn git so I am the only contributer and had to merge everbody elses code into mine. Most of the code in the Webdevelop folder is mine, but not the stuff in the root directories, some of the code is also based on what our professor provided. 
  
    If you are looking for my code here is some from this project that is almost all mine...
  https://github.com/ridleyjack/instant/blob/readmeupdate/WebContent/order.jsp
  https://github.com/ridleyjack/instant/blob/readmeupdate/WebContent/createdegree.jsp
  https://github.com/ridleyjack/instant/blob/readmeupdate/WebContent/imageview.jsp
  
  
  Below here I tried to write some instructions to help out my group members but, I was very tired when I wrote it, so it's hard to understand.  
<hr>

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
I have being doing this a bit by making a jsp file called somethingForm.jsp with the HTML stuff and another filed called 
something.jsp containing the logic. (but you can make web pages how ever you want).

2) If you want to avoid mixing html/java there is a library I have included called jstl.
To use it write this..
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
Look at listprod and listprodForm for an example.

**Other Notes**
If anybody doesn't like doing the coding stuff they can focus more on making the site look good. You would mostly just need
to play around with the .css and html and maybe make some graphics or something.
