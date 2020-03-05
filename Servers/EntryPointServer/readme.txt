** EntryPointServer ** 
This project runs an entry server.
The entry can connect to the AuthServer, and GameServer.
Can be called via either SOAP or REST.


This is a Java project with maven.
If you have not tried a similar project with maven, please do the following.

* IntelliJ:
- Open the project
- Right-click the pom.xml and click 'Add as Maven project'
- Import the dependencies
- You can now either:
	- Run a class with a main function
	- Produce a .jar with the maven-panel to the right
		- Run all the maven functions from 'clean' to 'package' (ignore errors)
		- Now a .jar is produced at /target/***.jar