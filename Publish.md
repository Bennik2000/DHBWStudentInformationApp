# Steps to publish this app

- Follow the steps according to the specific platform
- Commit the current state in a publish commit (Message: `Publish version 1.0.1`) 
- Create a new release on GitHub and tag the commit
- Merge the new version into the master branch



## Android

- Open the app in the developer console

- Go to "App releases" and search for the latest version code

- Open `android\app\build.gradle` and increase the `flutterVersionCode ` (must be greater than the version code read from the developer console) and `flutterVersionName`:

  ```python
  def flutterVersionCode = 'x'
  def flutterVersionName = '1.x.y'
  ```

- Open `android\app\build.gradle` and change the signing configuration to release mode:

  ```java
  buildTypes {
  	release {
      	signingConfig signingConfigs.release
  		//signingConfig signingConfigs.debug
  	}
  }
  ```

- In Android Studio select the root folder and click Build -> Flutter -> Build App Bundle: 

  ![image-20200706093154007](https://raw.githubusercontent.com/Bennik2000/DHBWStudentInformationApp/develop/screenshots/AndroidStudioBuildAppBundle.png)


- In the app developer console create a new release
- Upload the built `app-release.aab` file
- Write the change log
- Save, verify and publish the release

## iOS

TBD