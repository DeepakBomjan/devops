# MODULE 1
## Create an Organizational Structure 
In GitLab, projects and subgroups help you organize your codebases and effectively manage your projects. In this lab, you will learn how to create an organizational subgroup, how to create a project, and how to add a user to a project.

### Task A.  Create organizational subgroups
1. Create the group `My Test Group A`
2. Click the **New Subgroup** button in the top right corner.
3. In the **Subgroup name** field, type `Awesome Inc`.
4. The **Subgroup URL** shows which namespace hierarchy that this group will be created in.
5. The **Subgroup slug** will automatically populate based on the name. Rename `awesome-inc` to `awesome`.
6. Ensure that the **Visibility level** is set to `Private`.
7. Click the **Create subgroup** button.
8. **Congratulations!** You have created your first group and are ready to create additional groups on your own. Within the **Awesome Inc** group, create subgroups for each of these teams at your awesome company.

    * **Software**
      * **FinCore** (this is a subgroup of Software, not  Awesome Inc)
      * **MobileBanking**
      * **BPM**
    * **Infrastructure**
    * **Security**


## Task C. Create a new project

1. Navigate to the Awesome Inc > Software > Core subgroup that you just created.

2. Click the **Create new project** tile.

3. Click the **Create blank project** tile.

4. In the **Project name** field, enter `EMI Calculator`.
5. Set the **Visibility Level** to private.
6. Select **Create project**.

## Task D. Add a project member and set their role
1. In the `EMI Calculator` project, click **Manage** > **Members** in the left sidebar.

2. Click the **Invite members** button in the top right corner.

3. Search for and select your member as the user you are inviting. 

4. In the **Select a role** dropdown, select **Developer**. 

>[**Roles**](https://docs.gitlab.com/ee/user/permissions.html#roles)  
[**Project members permissions**](https://docs.gitlab.com/17.0/ee/user/permissions.html#project-members-permissions)  
[**Group members permissions**](https://docs.gitlab.com/17.0/ee/user/permissions.html#group-members-permissions)


5. Click the **Invite** button.


6. Refresh the page to see the user invited as a _Direct Member_.
> Users will inherit permissions from the parent group hierarchy that this project exists in. If a user already has a higher level of access in a parent group (ex. `Maintainer`), that access level supersedes a lower level of permission assigned at the project level (ex. `Developer`).


## TASK E: Add Boilerplates

1. Project Directory structure

```bash
├── .gitignore
├── .gitlab-ci.yml
├── ci_settings.xml
├── pom.xml
└── src
    ├── main
    │   └── java
    │       └── com
    │           └── example
    │               └── util
    │                   └── TimeUtil.java
    └── test
        └── java
            └── com
                └── example
                    └── util
                        └── TimeUtilTest.java
```

2. Add following source code
  * `TimeUtil.java`
    ```java
    package com.example.util;

    import java.time.LocalDateTime;
    import java.time.format.DateTimeFormatter;

    public class TimeUtil {
    
        public static String getCurrentTime() {
            LocalDateTime currentTime =     LocalDateTime.now();
            DateTimeFormatter formatter =     DateTimeFormatter.ofPattern   ("yyyy-MM-dd HH:mm:ss");
            return currentTime.format (formatter);
        }
    }
    ```
    * `TimeUtilTest.java`
      ```java
      package com.example.util;

      import org.junit.Test;
      import static org.junit.Assert.assertEquals;

      public class TimeUtilTest {
      
          @Test
          public void testGetCurrentTime() {
              String currentTime = TimeUtil.      getCurrentTime();
              assertEquals(19, currentTime.length     ()); // Length should match the     format
              assertEquals(' ', currentTime.charAt      (10)); // Check if the 11th       character is a space
              assertEquals(':', currentTime.charAt      (13)); // Check if the 14th       character is a colon
          }
      }
      ```
## TASK F: Publish to the GitLab package registry
[Publish Maven packages in the package registry](https://docs.gitlab.com/ee/user/packages/maven_repository/)
1. Create Maven Setting and Add the following section to your [`ci_settings.xml`](https://maven.apache.org/settings.html) file.
    ```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.    1.0" xmlns:xsi="http://www.w3.org/2001/   XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/    SETTINGS/1.1.0 http://maven.apache.org/xsd/   settings-1.1.0.xsd">
      <servers>
        <server>
          <id>gitlab-maven</id>
          <configuration>
            <httpHeaders>
              <property>
                <name>Job-Token</name>
                <value>${CI_JOB_TOKEN}</value>
              </property>
            </httpHeaders>
          </configuration>
        </server>
      </servers>
    </settings>
    ```

2. Edit the configuration file [`pom.xml`](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html) for publishing
    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/   XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.   org/POM/4.0.0 http://maven.apache.org/xsd/  maven-4.0.0.xsd">

        <modelVersion>4.0.0</modelVersion>
        <groupId>com.example</groupId>
        <artifactId>timeutil-java</artifactId>
        <version>1.0-SNAPSHOT</version>
        <packaging>jar</packaging>

        <properties>
            <maven.compiler.source>1.8</maven.compiler.   source>
            <maven.compiler.target>1.8</maven.compiler.   target>
        </properties>

        <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
        </dependencies>
        <repositories>
            <repository>
              <id>gitlab-maven</id>
              <url>${CI_API_V4_URL}/projects/$    {CI_PROJECT_ID}/packages/maven</url>
            </repository>
        </repositories>
        <distributionManagement>
            <repository>
              <id>gitlab-maven</id>
              <url>${CI_API_V4_URL}/projects/$    {CI_PROJECT_ID}/packages/maven</url>
            </repository>
            <snapshotRepository>
              <id>gitlab-maven</id>
              <url>${CI_API_V4_URL}/projects/$    {CI_PROJECT_ID}/packages/maven</url>
            </snapshotRepository>
        </distributionManagement>


    </project>
    ```

## TASK G: Create CICD
1. Create `.gitlab-ci.yml` file in project root
    ```yaml
    image: maven:latest


    stages:
      - test
      - build
      - deploy

    test:
      stage: test
      script:
        - mvn clean test

    build:
      stage: build
      script:
        - mvn clean package
      artifacts:
        paths:
          - target/*.jar
        expire_in: 1 week

    deploy_to_registry:
      stage: deploy
      dependencies:
        - build
      script:
        - echo "Deploying to GitLab Container     Registry..."
        - echo "$CI_JOB_TOKEN"
        - ls target/*.jar
        - mvn deploy -s ci_settings.xml
    ```

## TASK H: Push the changes and check the pipeline

# MODULE 2:

## TASK A: Create project `EMI Notification`
1. Project structure
```bash
├── .gitlab-ci.yml
├── ci_settings.xml
├── pom.xml
└── src
    └── main
        ├── java
        │   └── com
        │       └── example
        │           └── showtime
        │               └── TimeServlet.java
        └── webapp
            ├── WEB-INF
            │   └── web.xml
            └── index.html
```
2. Source codes
  * `TimeServlet.java`
  ```java
    package com.example;

    import com.example.util.TimeUtil;

    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import java.io.IOException;
    import java.io.PrintWriter;

    @WebServlet("/hello")
    public class TimeServlet extends HttpServlet {
    
        protected void doGet(HttpServletRequest     request, HttpServletResponse response) throws     IOException {
            response.setContentType("text/html");

            PrintWriter out = response.getWriter();
            out.println("<html><body>");
            out.println("<h2>Hello, World!</h2>");

            // Display current time using TimeUtil from     external-library
            out.println("<p>Current Time: " + TimeUtil.   getCurrentTime() + "</p>");

            out.println("</body></html>");
        }
    }
  ```
  * `ci_settings.xml`
    ```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/  1.0.0"
            xmlns:xsi="http://www.w3.org/2001/  XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.  org/SETTINGS/1.0.0 http://maven.apache. org/xsd/settings-1.0.0.xsd">
      <servers>
          <server>
              <id>gitlab-maven</id>
              <configuration>
                  <httpHeaders>
                      <property>
                          <name>Job-Token</name>
                          <value>${CI_JOB_TOKEN}</  value>
                      </property>
                  </httpHeaders>
              </configuration>
          </server>
      </servers>
    </settings>
    ```
  * `pom.xml`. Update the `PROJECT_ID`
  ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0"
           xmlns:xsi="http://www.w3.org/2001/ XMLSchema-instance"
           xsi:schemaLocation="http://maven.apache. org/POM/4.0.0 http://maven.apache.org/xsd/ maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>

      <groupId>com.example</groupId>
      <artifactId>show-time-servlet</artifactId>
      <version>1.0-SNAPSHOT</version>
      <packaging>war</packaging>

      <name>show-time-servlet</name>

      <properties>
          <maven.compiler.source>11</maven.compiler.  source>
          <maven.compiler.target>11</maven.compiler.  target>
      </properties>

      <repositories>
      <repository>
        <id>gitlab-maven</id>
        <url>https://git.nnine.training/api/v4/projects/PROJECT_ID/packages/maven</url>
      </repository>
      </repositories>

      <distributionManagement>
        <repository>
          <id>gitlab-maven</id>
          <url>https://git.nnine.training/api/v4/projects/PROJECT_ID/packages/maven</url>
        </repository>

        <snapshotRepository>
          <id>gitlab-maven</id>
          <url>https://git.nnine.training/api/v4/projects/PROJECT_ID/packages/maven</url>
        </snapshotRepository>
      </distributionManagement>

      <dependencies>
          <dependency>
              <groupId>javax.servlet</groupId>
              <artifactId>javax.servlet-api</ artifactId>
              <version>4.0.1</version>
              <scope>provided</scope>
          </dependency>
          <dependency>
              <groupId>com.example</groupId>
              <artifactId>timeutil-java</artifactId>
              <version>1.0-SNAPSHOT</version>
          </dependency>
          <dependency>
              <groupId>org.apache.commons</groupId>
              <artifactId>commons-lang3</artifactId>
              <version>3.12.0</version>
          </dependency>
      </dependencies>

      <build>
          <finalName>show-time-servlet</finalName>
          <plugins>
              <plugin>
                  <groupId>org.apache.maven.plugins</ groupId>
                  <artifactId>maven-war-plugin</  artifactId>
                  <version>3.3.1</version>
              </plugin>
          </plugins>
      </build>
    </project>
  ```
  * `.gitlab-ci.yml`
    ```yaml
    stages:
      - build

    variables:
      MAVEN_IMAGE: maven:3.8.1-jdk-11  # Use the    official Maven image with JDK 11

    cache:
      paths:
        - .m2/repository

    build:
      stage: build
      image: $MAVEN_IMAGE
      script:
        - mvn -s ci_settings.xml clean package
      artifacts:
        paths:
          - target/show-time-servlet.war
        expire_in: 1 hour
    ```

## References

[GitLab CI/CD variables](https://docs.gitlab.com/ee/ci/variables/)  
[Predefined CI/CD variables reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)  
[CI/CD YAML syntax reference](https://docs.gitlab.com/ee/ci/yaml/)  
[GitLab CI parallel test automation example](https://gitlab.com/testmoapp/example-gitlab-parallel)  
[Specify when jobs run with rules](https://docs.gitlab.com/ee/ci/jobs/job_rules.html)  
[Example](https://gitlab.com/lian.duan.training/gitlabcicd/-/tree/main/1-22%20GitLab%20CI%20CD%20Workflow/Pipeline?ref_type=heads)



