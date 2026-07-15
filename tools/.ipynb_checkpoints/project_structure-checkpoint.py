from pathlib import Path

# ==========================================================
# On Time Financial Analytics
# Wealth Management Analytics Dashboard
#
# Project Structure Generator
#
# This script creates only missing folders/files.
# Existing files are NEVER overwritten.
# ==========================================================

PROJECT_NAME = "wealth-management-analytics-dashboard"

ROOT = Path(__file__).resolve().parent.parent

# ==========================================================
# FOLDERS
# ==========================================================

FOLDERS = [

    # Root
    "",

    # Documentation
    "docs",
    "docs/architecture",
    "docs/architecture/diagrams",
    "docs/images",

    # Database
    "database",
    "database/ddl",
    "database/dml",
    "database/views",
    "database/procedures",
    "database/functions",
    "database/indexes",
    "database/seeds",
    "database/backups",

    # Python
    "python",
    "python/generators",
    "python/etl",
    "python/analytics",
    "python/validation",
    "python/api",
    "python/utils",
    "python/config",

    # Data
    "data",
    "data/raw",
    "data/bronze",
    "data/silver",
    "data/gold",
    "data/exports",

    # Power BI
    "powerbi",
    "powerbi/dashboards",
    "powerbi/themes",
    "powerbi/assets",

    # Notebooks
    "notebooks",

    # Tests
    "tests",

    # Logs
    "logs",

    # Images
    "images",

    # Tools
    "tools"
]

# ==========================================================
# FILES
# ==========================================================

FILES = {

    # Root

    "README.md": "# Wealth Management Analytics Dashboard\n",

    "LICENSE": "",

    ".gitignore": """__pycache__/
*.pyc
.vscode/
.env
.ipynb_checkpoints/
logs/
""",

    "requirements.txt": """pandas
numpy
faker
sqlalchemy
psycopg2
jupyter
matplotlib
powerbiclient
""",

    # Documentation

    "docs/00_project_overview.md": "",

    "docs/01_business_problem.md": "",

    "docs/02_business_requirements.md": "",

    "docs/03_data_dictionary.md": "",

    "docs/04_database_model.md": "",

    "docs/05_kpis.md": "",

    # Architecture

    "docs/architecture/01_solution_architecture.md": "",

    "docs/architecture/02_data_pipeline.md": "",

    "docs/architecture/03_application_architecture.md": "",

    "docs/architecture/04_api_architecture.md": "",

    # SVG placeholders

    "docs/architecture/diagrams/solution_architecture.svg": "",

    "docs/architecture/diagrams/star_schema.svg": "",

    "docs/architecture/diagrams/medallion_architecture.svg": "",

    "docs/architecture/diagrams/application_architecture.svg": "",

    "docs/architecture/diagrams/deployment_architecture.svg": "",
}

# ==========================================================
# CREATE FOLDERS
# ==========================================================

created_folders = []
existing_folders = []

for folder in FOLDERS:

    path = ROOT / folder

    if not path.exists():

        path.mkdir(parents=True, exist_ok=True)
        created_folders.append(path)

    else:

        existing_folders.append(path)

# ==========================================================
# CREATE FILES
# ==========================================================

created_files = []
existing_files = []

for filename, content in FILES.items():

    path = ROOT / filename

    if not path.exists():

        path.write_text(content, encoding="utf-8")
        created_files.append(path)

    else:

        existing_files.append(path)

# ==========================================================
# CREATE .gitkeep
# ==========================================================

for folder in ROOT.rglob("*"):

    if folder.is_dir():

        if not any(folder.iterdir()):

            gitkeep = folder / ".gitkeep"

            if not gitkeep.exists():

                gitkeep.touch()

# ==========================================================
# SUMMARY
# ==========================================================

print("=" * 60)
print("On Time Financial Analytics")
print("Project Structure Generator")
print("=" * 60)

print(f"\nProject: {PROJECT_NAME}")

print("\nFolders created:")

for folder in created_folders:

    print(" +", folder.relative_to(ROOT))

print("\nFiles created:")

for file in created_files:

    print(" +", file.relative_to(ROOT))

print("\nExisting folders:", len(existing_folders))
print("Existing files:", len(existing_files))

print("\nDone!")
print("=" * 60)