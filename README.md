# capstone

This is my Capstone project implemented for the Udacity course Cloud DevOps Engineer.

The project is really simple and I've decided to implement a red/blue deployment using a simple index.html file backed by nginix.

Those are the steps I've followed to create and deploy this project.

1. Creation of a user with minimum privileges
2. Creation of a EC2 instance called JenkinsMachine
3. SSH login into JenkinsMachine and install Jenkins with all the plugins described in the course
4. SSH login into JenkinsMachine and install Docker, kubectl, aws-iam-authenticator, eksctl, tidy
5. Connect Jenkins with my GitHub repository
6. Define my blue-green pipeline in my Jenkinsfile
7. Push the code on my GitHub repository
8. Wait for the pipeline to start
9. Confirm that we want switch traffic on the new instance

