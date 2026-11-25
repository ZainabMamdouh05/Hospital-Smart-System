\# Smart Hospital Management System



A Dockerized Smart Hospital Management System that combines a web-based frontend, workflow automation, and a MariaDB database.



\## Project Overview



The Smart Hospital Management System is designed to organize hospital-related operations through a web interface and automated workflows.



The project includes frontend pages and database structures for:



\- Patient management

\- Doctor and clinic management

\- Clinic bookings and schedules

\- Laboratory services

\- Radiology services

\- Pharmacy services

\- Invoices and payments



n8n is used to manage automation workflows and integrate the frontend with the database and external services such as Telegram.



\## Technology Stack



| Technology | Purpose |

|---|---|

| HTML, CSS, JavaScript | Frontend |

| Apache HTTP Server 2.4 | Frontend web server |

| Docker | Containerization |

| Docker Compose | Multi-container management |

| MariaDB 11.4 | Relational database |

| n8n 2.36.9 | Workflow automation |

| Telegram Bot API | Notifications and interactions |



\## System Architecture



The application uses three main Docker services:



| Service | Container | Port |

|---|---|---|

| Frontend | hospital-frontend | 8080 |

| n8n | hospital-n8n | 5678 |

| MariaDB | hospital-database | 3306 (internal Docker network) |



The frontend communicates with n8n through API endpoints and webhooks. n8n connects to MariaDB using the Docker service hostname `database`.



\## Project Structure



```text

Hospital-Smart-System/

├── docs/

│   ├── screenshots/

│   └── notes.md

├── src/

│   ├── database/

│   │   └── hospital\_system (2).sql

│   ├── frontend/

│   │   ├── assets/

│   │   ├── doctor.html

│   │   ├── index.html

│   │   ├── laboratory.html

│   │   ├── patient.html

│   │   ├── pharmacy.html

│   │   └── radiology.html

│   └── workflows/

│       └── Hospital System workflow export

├── .dockerignore

├── .env.example

├── .gitignore

├── Dockerfile

├── docker-compose.yml

└── README.md

```



\## Prerequisites



Install the following tools:



\- Docker Desktop

\- Git

\- A modern web browser



Docker Desktop must be running before executing Docker Compose commands.



\## Environment Configuration



Create a `.env` file from the example:



```cmd

copy .env.example .env

```



Edit `.env` and set your own database passwords:



```env

DB\_ROOT\_PASSWORD=your\_root\_password

DB\_PASSWORD=your\_database\_password

```



Do not upload `.env` or expose database passwords, API tokens, or Telegram credentials.



\## Running the Project



Open a terminal in the project root directory.



Validate the Docker Compose configuration:



```bash

docker compose config

```



Build and start all services:



```bash

docker compose up -d --build

```



Check the running containers:



```bash

docker compose ps

```



\## Accessing the Services



\- Frontend: http://localhost:8080

\- n8n: http://localhost:5678

\- MariaDB: Port 3306 inside the Docker network



The database is not exposed as a host port in the current Compose configuration.



\## Database Configuration



The MariaDB database is named:



`hospital\_system`



The application database user is:



`hospital\_app`



Within the Docker network, n8n connects to MariaDB using:



| Setting | Value |

|---|---|

| Host | `database` |

| Port | `3306` |

| Database | `hospital\_system` |

| User | `hospital\_app` |

| Password | `DB\_PASSWORD` from `.env` |



The SQL initialization file is imported when MariaDB starts with an empty data volume. Existing initialized volumes are not automatically re-imported.



To access the database from the terminal:



```bash

docker compose exec database mariadb -u hospital\_app -p hospital\_system

```



\## Useful Docker Commands



View container status:



```bash

docker compose ps

```



View service logs:



```bash

docker compose logs -f

```



View a specific service:



```bash

docker compose logs -f n8n

```



Stop the containers:



```bash

docker compose stop

```



Stop and remove containers and the Compose network:



```bash

docker compose down

```



Named volumes are retained when using the commands above.



\*\*Warning:\*\* `docker compose down -v` removes the named volumes and can permanently delete the database and n8n persistent data. Do not use it unless you intentionally want to remove that data.



\## Configuration and Security



\- Keep `.env` out of Git.

\- Use `.env.example` for placeholder configuration.

\- Keep Telegram Bot Tokens and other credentials private.

\- Do not use real patient information in development or public demonstrations.

\- A public HTTPS URL is required for Telegram webhooks to reach a locally hosted n8n instance.

\- The ngrok URL used during development may change between sessions.



\## Testing and Current Status



The following deployment checks have been completed:



\- Docker containers start successfully.

\- The frontend is served by Apache.

\- The MariaDB database is initialized.

\- The database contains the expected tables.

\- The `hospital\_app` user can connect to the database.

\- n8n is running and its MariaDB credential was successfully tested.

\- The workflow export was imported into n8n.



The following integration checks still require completion:



\- End-to-end frontend API requests.

\- Frontend-to-n8n CORS configuration.

\- Full Telegram callback workflow validation.



These items are being reviewed after the Docker deployment.



\## Notes



Additional Docker and Git learning notes are available in `docs/notes.md`.



\## License



No open-source license has been added to this project yet.

