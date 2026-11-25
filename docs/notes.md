\# Project Development Notes



\## 1. Biggest Docker Challenge and How I Solved It



The biggest challenge I faced during Docker deployment was the MariaDB authentication issue.



After changing the database credentials in the `.env` file, the database container still rejected the login attempts with an authentication error (Error 1045).



\### Cause



The MariaDB Docker volume had already been initialized with previously configured credentials. Changing the environment variables in `.env` did not automatically update the existing database users because the initialization variables are applied when the database is first created.



\### Solution



I followed these steps:



1\. Stopped the Docker Compose services.

2\. Created a backup of the existing MariaDB volume.

3\. Created a new database volume while preserving the original volume and backup.

4\. Updated the Docker Compose configuration to use the new volume.

5\. Started the services again.

6\. Verified that MariaDB initialized successfully and imported the SQL database.

7\. Tested the `hospital\_app` user and confirmed that it could access the `hospital\_system` database and its tables.



This experience taught me that Docker volumes preserve application data independently of container recreation, and that changing environment variables does not necessarily change credentials in an already initialized database.



\## 2. What I Learned About Git



During this project, I learned how Git tracks changes and how to connect a local project to GitHub.



The main lessons I learned were:



\- `git init` initializes a local Git repository.

\- `git status` shows which files are untracked or modified.

\- `.gitignore` prevents files such as `.env` and database backups from being tracked.

\- `git add` stages files for a commit.

\- `git commit` saves a snapshot of the staged changes.

\- `git remote add origin` connects the local repository to a GitHub repository.

\- `git push` uploads local commits to GitHub.



I also learned that Git requires a configured username and email address before creating commits.



Using meaningful commit messages makes project history easier to understand and maintain.


## 3. Additional Docker Challenge: Receipt File Storage

Another challenge appeared when testing payment receipt uploads after moving the application from XAMPP to Docker.

### Problem

The n8n workflow originally generated receipt paths using a Windows-style path:

`C:/n8n-data/receipts/`

However, n8n was running inside a Linux-based Docker container and could not access that path. The workflow displayed a file or directory does not exist error, preventing the receipt-processing flow from completing.

### Solution

I solved the issue using a Docker bind mount.

The host directory:

`./n8n-data/receipts/`

was mapped to the container directory:

`/home/node/.n8n-files/receipts/`

I then updated the receipt path in the n8n workflow to use the Linux container path.

The `.gitignore` file was also updated to exclude `n8n-data/`, preventing uploaded payment receipts from being committed to GitHub.

### Verification

I verified that:

1. The receipt directory was accessible from inside the n8n container.
2. The container could create and remove a test file.
3. A payment receipt was successfully saved in the mounted directory.
4. The Telegram notification was received.
5. The payment was successfully approved through Telegram.

This challenge taught me that file paths inside Docker containers are different from host operating system paths, and that bind mounts are useful for sharing persistent files between the host and containers.

\## 4. Final Reflection



This assignment helped me understand how to containerize a multi-service application, manage persistent database storage, configure services using Docker Compose, and maintain project history using Git and GitHub.



It also taught me the importance of creating backups before changing database configurations and keeping sensitive configuration files out of version control.





