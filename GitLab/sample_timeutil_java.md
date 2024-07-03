To create the project using Maven (`mvn`), you'll follow these steps to set up a basic Java project with the `TimeUtil` class:

### Step 1: Install Maven (if not already installed)

Make sure Maven is installed on your system. You can check if Maven is installed by running:

```bash
mvn -v
```

If not installed, you can download it from [Maven's official website](https://maven.apache.org/download.cgi) and follow the installation instructions.

### Step 2: Create Project Structure

1. **Create Project Directory:**

   Choose or create a directory where you want your project to reside. Let's assume your project directory is `project-name`.

   ```bash
   mkdir project-name
   cd project-name
   ```

2. **Create `src` Directory:**

   Maven expects your source code to be in the `src/main/java` directory by default. Create the necessary directories:

   ```bash
   mkdir -p src/main/java/com/example/util
   ```

### Step 3: Create `pom.xml` File

The `pom.xml` file is the core of a Maven project. It contains configurations and dependencies for your project.

1. **Create `pom.xml`:**

   In your project directory (`project-name`), create a `pom.xml` file with the following content:

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       
       <modelVersion>4.0.0</modelVersion>
       <groupId>com.example</groupId>
       <artifactId>project-name</artifactId>
       <version>1.0-SNAPSHOT</version>
       <packaging>jar</packaging>
       
       <properties>
           <maven.compiler.source>1.8</maven.compiler.source>
           <maven.compiler.target>1.8</maven.compiler.target>
       </properties>
       
       <dependencies>
           <!-- Add any dependencies here -->
       </dependencies>
       
   </project>
   ```

   Adjust the `groupId`, `artifactId`, and `version` values according to your project specifications.

### Step 4: Create `TimeUtil` Class

1. **Create `TimeUtil.java`:**

   In your terminal, navigate to `src/main/java/com/example/util` directory and create `TimeUtil.java`:

   ```java
   package com.example.util;
   
   import java.time.LocalDateTime;
   import java.time.format.DateTimeFormatter;
   
   public class TimeUtil {
   
       public static String getCurrentTime() {
           LocalDateTime currentTime = LocalDateTime.now();
           DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
           return currentTime.format(formatter);
       }
   }
   ```

### Step 5: Build the Project

Now that you have your `TimeUtil` class and `pom.xml` set up, you can build the project using Maven:

```bash
mvn package
```

This command compiles your Java code, runs any tests (if present), and packages your project into a JAR file (or other specified format).

### Step 6: Run the Project (Optional)

Since this project doesn't have a main class for execution, you typically wouldn't run it directly. However, you can integrate this project into another Java application or web application by adding it as a dependency in your `pom.xml`.

### Summary

You've now created a basic Java project structure using Maven, including a `TimeUtil` class that provides a method to get the current time formatted as a string. Adjustments such as adding dependencies or testing frameworks can be made by modifying the `pom.xml` file accordingly.
In a Maven project structure, the convention is to place test classes under `src/test/java`. Here’s how you should organize your project to include the `TimeUtilTest` class for testing `TimeUtil.java`:

### Project Structure

Assuming your project structure is set up as follows:

```
project-name
├── pom.xml
└── src
    ├── main
    │   └── java
    │       └── com
    │           └── example
    │               └── util
    │                   └── TimeUtil.java
    └── test
        └── java
            └── com
                └── example
                    └── util
                        └── TimeUtilTest.java
```

### Step-by-Step Guide

1. **Create `TimeUtil.java`:**

   Your original `TimeUtil` class remains in `src/main/java/com/example/util/TimeUtil.java`.

   ```java
   package com.example.util;

   import java.time.LocalDateTime;
   import java.time.format.DateTimeFormatter;

   public class TimeUtil {

       public static String getCurrentTime() {
           LocalDateTime currentTime = LocalDateTime.now();
           DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
           return currentTime.format(formatter);
       }
   }
   ```

2. **Create `TimeUtilTest.java`:**

   In the `src/test/java/com/example/util/` directory, create `TimeUtilTest.java` for testing `TimeUtil.java`:

   ```java
   package com.example.util;

   import org.junit.Test;
   import static org.junit.Assert.assertEquals;

   public class TimeUtilTest {

       @Test
       public void testGetCurrentTime() {
           String currentTime = TimeUtil.getCurrentTime();
           assertEquals(19, currentTime.length()); // Length should match the format
           assertEquals(' ', currentTime.charAt(10)); // Check if the 11th character is a space
           assertEquals(':', currentTime.charAt(13)); // Check if the 14th character is a colon
       }
   }
   ```

3. **Update `pom.xml` for Dependencies:**

   Ensure JUnit dependency is included in your `pom.xml` for running tests:

   ```xml
   <dependencies>
       <dependency>
           <groupId>junit</groupId>
           <artifactId>junit</artifactId>
           <version>4.12</version>
           <scope>test</scope>
       </dependency>
   </dependencies>
   ```

4. **Build and Run Tests:**

   Compile your project and run the tests using Maven:

   ```bash
   mvn clean test
   ```

   Maven will compile your code, execute the tests in `TimeUtilTest`, and provide feedback on whether the tests passed or failed.

### Explanation

- **`src/main/java`:** This directory contains your main Java source files (`TimeUtil.java`).
- **`src/test/java`:** This directory is where your test classes reside (`TimeUtilTest.java`). Maven recognizes this structure and automatically runs tests during the `test` phase (`mvn test`).

By following this structure, you maintain separation between production and test code, adhering to best practices for software development and testing. Adjust package names (`com.example.util`) and other specifics as per your project requirements.
