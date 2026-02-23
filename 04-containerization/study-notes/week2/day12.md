Day 12: Environment Configuration
I. Technical Theory: Decoupling Config from Code

In professional DevOps, we follow the Twelve-Factor App methodology, which states that configuration should be stored in the environment.

    Why use .env? It allows you to use the same docker-compose.yml file across different stages (Development, Staging, Production) without changing the code. You simply swap the .env file.

    Variable Interpolation: This is the process where Docker Compose replaces placeholders like ${DB_PASSWORD} in your YAML file with actual values from your .env file or shell.

    Precedence: Docker follows a specific hierarchy if a variable is defined in multiple places:

        environment: key in the Compose file.

        Shell environment variables.

        The .env file.

II. Deep Dive: Key Learning Points

    From Video: The video explains that .env files should be placed in the project root. It also warns against hardcoding sensitive data directly in the Compose file, as this creates a security vulnerability if pushed to GitHub.

    From Docs: * env_file: You can use the env_file: key to pull in a list of variables from a specific file, which keeps your Compose file much cleaner.

        Default Values: You can set defaults using ${VAR:-default_value}. This ensures the stack starts even if someone forgets to set a variable.

III. Professional Hands-on: Environment Hardening

Let's apply this to your three-tier-app-configuration.

1. Create a Professional .env File:
Plaintext

# Database Credentials
DB_USER=admin
DB_PASSWORD=choose_a_strong_password
DATABASE_URL=database_connection_string
DB_NAME=name of the database to use

# App Settings
PORT_FRONTEND=port number for frontend
PORT_BACKEND=port number for backend
PORT=port number for the application
BUILD_NUMBER=version or build number of the application

2. Update docker-compose.yml for Cleanliness:
Instead of listing every variable under environment:, use env_file.
YAML

services:
  backend:
    image: nikkytechies/fiddly-backend:${BUILD_NUMBER:-latest}
    env_file:
      - .env
    networks:
      - backend-nw
      - frontend-nw

IV. How to Understand it Perfectly

To master Day 12, you must understand Visibility.

    Host Visibility: Run echo $DB_USER. If it's empty, your shell doesn't know the variable.

    Compose Visibility: Run docker compose config. This is the most important command—it shows you exactly how Docker interpreted your variables before it starts the containers.

    Container Visibility: Run docker compose exec backend env. This proves the variables successfully "crossed the border" into the running application.

V. Compiled Troubleshooting Log
Problem	Root Cause	Professional Fix
Variables are blank	.env file is not in the same directory as docker-compose.yml.	Move .env to the project root or use --env-file flag.
Passwords leaked to Git	.env was tracked by Git.	Add .env to .gitignore and create a .env.example template.
Changes not reflecting	Container was not recreated.	Run docker compose up -d to trigger a recreate with new env values.

Day 12: Environment Configuration (Project Audit)
I. Technical Theory: The Lifecycle of a Variable

You just witnessed the three stages of an environment variable:

    The Source (Host): echo $DB_USER returned nothing. This proves the variable isn't "leaking" into your EliteBook's global environment; it stays contained within the project.

    The Interpolation (Compose Config): docker compose config showed MONGO_INITDB_ROOT_USERNAME: <value>. This proves Docker successfully read your .env file and "injected" the values into the YAML template.

    The Runtime (Container): docker compose exec backend env showed the DATABASE_URL with the actual password. This proves the variable survived the journey from a text file on your laptop into the running Linux process inside the container.

II. Deep Dive: Key Learning Points from your Audit

    Success: Your DATABASE_URL is perfectly constructed. It uses the dynamic credentials (<user name>:<password>) and the service discovery name (db).

    Security Observation: In your exec env output, notice that only DATABASE_URL is present in the backend, while MONGO_INITDB_ROOT_PASSWORD is only in the DB. This is Principle of Least Privilege—only give a service the secrets it absolutely needs.

    Version Control: Your image is tagged v1.0.2. Using variables for versioning allows you to roll back to v1.0.1 just by changing one line in your .env file.

III. Professional Hands-on: Summary of Commands Used
Command	DevOps Purpose	Your Result
echo $DB_USER	Check Host Environment	Clean (Variable is isolated to Docker)
docker compose config	Dry Run / Validation	Interpolation Success (Values rendered)
docker compose exec backend env	Runtime Verification	Injection Success (App sees the URL)
IV. Troubleshooting Log (Day 12)
Issue	Observation	Professional Fix
Empty Values	If config showed ${DB_USER} instead of <user name>.	Ensure .env is in the same folder as docker-compose.yml.
Old Values Persisting	Changing .env but env command shows old password.	Run docker compose up -d to force a container recreate.
Secret Leakage	Seeing real passwords in the docker-compose.yml on GitHub.	Add .env to .gitignore immediately.
V. How to Understand it Perfectly

Think of the .env file as the Identity Card and the docker-compose.yml as the Job Description.

    The Job Description says: "The worker needs a username."

    The Identity Card provides: "The username is nikky_dev."

    The result: You can change the "worker" (the Identity Card) without ever rewriting the "Job Description." This makes your infrastructure reusable.