import os
import json
import logging
import boto3
from botocore.exceptions import ClientError
import psycopg2
from psycopg2 import sql
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def create_secret(client, secret_name, username):
    try:
        randomPassword = client.get_random_password(
            PasswordLength=16,
            ExcludePunctuation=True
        )
        password = randomPassword["RandomPassword"]
        secret = json.dumps({
            "username": username,
            "password": password
        })
        client.create_secret(
            Name=secret_name,
            SecretString=secret,
            Tags=[
                {
                    'Key': 'OwnedBy',
                    'Value': 'Terraform'
                },
                {
                    'Key': 'Customer',
                    'Value': 'Fiter' # should be dynamic
                },
            ],
        )
    except ClientError as error:
        if error.response['Error']['Code'] == 'ResourceExistsException':
            secret = get_secret(client, secret_name)
            password = secret["password"]
        else:
            raise error

    return password

def get_secret(client, secret_name):
    print(f"attempting to get {secret_name}")
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        raise e
    
    secret = get_secret_value_response['SecretString']
    return json.loads(secret)

def delete_secret(client, secret_name):
    print(f"attempting to Delete {secret_name}")
    try:
        response = client.delete_secret(
            SecretId=secret_name,
            ForceDeleteWithoutRecovery=True
        )
    except ClientError as e:
        raise e
    return True

def lambda_handler(event, context):
    ACTION = event["tf"]["action"]
    DB_IDENTIFIER = os.environ["DB_IDENTIFIER"]
    USER_NAME = f'{event["USERNAME"]}'
    SECRET_NAME = f'{DB_IDENTIFIER}-{USER_NAME}-secret'
    DATABASES = event["DATABASES"]
    REGION_NAME = os.environ['AWS_REGION']
    ADMIN_SECRET_NAME = os.environ["ADMIN_SECRET_NAME"]
    DB_HOST = os.environ["DB_HOST"]
    ADMIN_DB_NAME = os.environ["ADMIN_DB_NAME"]
    DB_INIT = f'event["DB_INIT"]'

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=REGION_NAME
    )

    db_secret = get_secret(client, ADMIN_SECRET_NAME)

    db_params = {
        "host": DB_HOST,
        "database": ADMIN_DB_NAME,
        "user": db_secret["username"],
        "password": db_secret["password"],
        "port": "5432"
    }

    try:
        connection = psycopg2.connect(**db_params)
        connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        connection.autocommit = True
        # Creating a cursor object to interact with the database
        cursor = connection.cursor()
            

        IndentationError

        if DB_INIT == "True":
            cursor.execute("REVOKE CREATE ON SCHEMA public FROM PUBLIC;")
            cursor.execute("CREATE ROLE readwrite")
            cursor.execute("GRANT USAGE, CREATE ON SCHEMA public TO readwrite")
            cursor.execute("GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO readwrite")
            cursor.execute("ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite")
            cursor.execute("GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO readwrite")
            cursor.execute("GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO readwrite")
            cursor.execute("ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO readwrite")
        else:
            if ACTION == "create":
                for database_name in DATABASES:
                    cursor.execute("SELECT 1 FROM pg_catalog.pg_database WHERE datname = %s", (database_name,))
                    exists = cursor.fetchone()
                    if not exists:
                        cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(database_name)))
                        cursor.execute(f"REVOKE ALL ON DATABASE {database_name} FROM PUBLIC")
                        cursor.execute(f"GRANT CONNECT ON DATABASE {database_name} TO readwrite")
                        print(f"Database {database_name} created successfully.")
                    else:
                        print(f"Database {database_name} already exists.")

                cursor.execute("SELECT 1 FROM pg_roles WHERE rolname=%s", (USER_NAME,))
                user_exists = cursor.fetchone()

                if not user_exists:
                    user_secret = create_secret(client, SECRET_NAME, USER_NAME)
                    cursor.execute(
                        sql.SQL("CREATE USER {} WITH PASSWORD %s").format(
                            sql.Identifier(USER_NAME)
                        ),
                        (user_secret,)
                    )
                    cursor.execute(f"REVOKE ALL PRIVILEGES ON DATABASE postgres FROM {USER_NAME}")
                    cursor.execute(f"GRANT readwrite TO {USER_NAME}")
                    print(f"User {USER_NAME} created successfully.")
                else:
                    print(f"User {USER_NAME} already exists.")
            elif ACTION == "delete":
                cursor.execute(f"REVOKE readwrite FROM {USER_NAME}")
                cursor.execute(f"DROP USER IF EXISTS {USER_NAME}")
                delete_secret(client, SECRET_NAME)
            else:
                logger.info(f"No Action to take'")

    except (Exception, psycopg2.Error) as error:
        print(f"Error connecting to the database: {error}")

    finally:
        if connection:
            cursor.close()
            connection.close()
            print("Database connection closed.")
            
    return {
        "secretname": SECRET_NAME
    }
