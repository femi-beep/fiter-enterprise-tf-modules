import os
import json
import logging
import pymysql.cursors
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def create_secret(client, secret_name, username):
    try:
        password = client.get_random_password(
            PasswordLength=16
        )
        secret = json.dumps({
            "username": username,
            "password": password["RandomPassword"]
        })
        client.create_secret(
            Name=secret_name,
            SecretString=secret,
            Tags=[
                {
                    'Key': 'OwnedBy',
                    'Value': 'Terraform' # should be dynamic
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



queries = {
    "CREATE_DB": "CREATE DATABASE IF NOT EXISTS `%s`;",
    "CREATE_USER": "CREATE USER %s@'%%' IDENTIFIED BY %s;",
    "GRANT_SERVICE": "GRANT ALL PRIVILEGES ON %s.* TO %s@'%%';",
    "FLUSH": "FLUSH PRIVILEGES;",
    "DROP_USER": "DROP USER IF EXISTS %s;",
    "USER_EXIST": "SELECT user FROM mysql.user WHERE user = %s;"
}

def createConnection(db_secret, host, db_name):
    conn = pymysql.connect(host=host,
                                user=db_secret["username"],
                                password=db_secret["password"],
                                database=db_name,
                                charset='utf8mb4',
                                cursorclass=pymysql.cursors.DictCursor)
    return conn

def lambda_handler(event, context):
    ACTION = event["tf"]["action"]
    USER_NAME = f'{event["USERNAME"]}-user' # fiter-dev-something
    SECRET_NAME = f'fineract-{USER_NAME}-secret' # fineract-default-service-user
    FINERACT_DEFAULT = "fineract_default"
    FINERACT_TENANT = "fineract_tenants"
    REGION_NAME = os.environ['AWS_REGION']
    ADMIN_SECRET_NAME = os.environ["ADMIN_SECRET_NAME"]
    DB_HOST = os.environ["DB_HOST"]
    ADMIN_DB_NAME = os.environ["ADMIN_DB_NAME"]

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=REGION_NAME
    )

    
    logger.info('Calculated result of Some action')

    db_secret = get_secret(client, ADMIN_SECRET_NAME)
    conn = createConnection(db_secret, DB_HOST, ADMIN_DB_NAME)
    
    try:
        cursor = conn.cursor()

        if ACTION == "create":
            CREATE_DB_SQL = queries["CREATE_DB"]
            cursor.execute(CREATE_DB_SQL, (FINERACT_DEFAULT,))
            cursor.execute(CREATE_DB_SQL, (FINERACT_TENANT,))

            cursor.execute(queries["USER_EXIST"], (USER_NAME,))
            user_exists = cursor.fetchone() is not None

            if user_exists:
                logger.info(f"User '{USER_NAME}' already exists.")
            else:
                # pass
                user_secret = create_secret(client, SECRET_NAME, USER_NAME)
                # Create a new user
                CREATE_USER_SQL = queries["CREATE_USER"]
                cursor.execute(CREATE_USER_SQL, (USER_NAME, user_secret))
                logger.info(f"User '{USER_NAME}' created.")

                # Grant all permissions on the database to the user
                GRANT_PRIVILEGE_SQL = queries["GRANT_SERVICE"]
                cursor.execute("GRANT ALL PRIVILEGES ON fineract_default.* TO %s@'%%';", (USER_NAME,))
                cursor.execute("GRANT ALL PRIVILEGES ON fineract_tenants.* TO %s@'%%';", (USER_NAME,))

                cursor.execute(queries["FLUSH"])
                logger.info(f"All privileges granted to user '{USER_NAME}'")
                
                # Commit the changes
                conn.commit()

        elif ACTION == "delete":
            delete_secret(client, SECRET_NAME)
            # Delete User
            DROP_USER_SQL = queries["DROP_USER"]
            cursor.execute(DROP_USER_SQL, (USER_NAME))
            conn.commit()
        else:
            logger.info(f"No Action to take'")

    except pymysql.MySQLError as e:
        logger.error(f"Error: {e}")
    finally:
        cursor.close()
        conn.close()
        
    return {
        "statusCode": 200
    }
