import boto3
from boto3.dynamodb.conditions import Key, Attr
import json

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table_name = 'Users'
table = dynamodb.Table(table_name)

def create_table():
    """Create DynamoDB table"""
    try:
        table = dynamodb.create_table(
            TableName=table_name,
            KeySchema=[
                {
                    'AttributeName': 'UserId',
                    'KeyType': 'HASH'  # Partition key
                },
                {
                    'AttributeName': 'Email',
                    'KeyType': 'RANGE'  # Sort key
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'UserId',
                    'AttributeType': 'S'  # String
                },
                {
                    'AttributeName': 'Email',
                    'AttributeType': 'S'
                }
            ],
            BillingMode='PAY_PER_REQUEST'  # On-demand capacity
        )
        
        # Wait for table to be created
        table.meta.client.get_waiter('table_exists').wait(TableName=table_name)
        print(f"Table {table_name} created successfully!")
        return table
    except Exception as e:
        print(f"Error creating table: {e}")
        return None

def put_item(user_id, email, name, age, country):
    """Insert or update an item"""
    try:
        response = table.put_item(
            Item={
                'UserId': user_id,
                'Email': email,
                'Name': name,
                'Age': age,
                'Country': country,
                'AccountStatus': 'Active',
                'JoinDate': '2024-01-15'
            },
            ReturnValues='ALL_OLD'
        )
        print(f"Item added/updated: {user_id}")
        return response
    except Exception as e:
        print(f"Error putting item: {e}")
        return None

def get_item(user_id, email):
    """Retrieve an item by primary key"""
    try:
        response = table.get_item(
            Key={
                'UserId': user_id,
                'Email': email
            }
        )
        item = response.get('Item')
        if item:
            print(f"Retrieved item: {json.dumps(item, indent=2)}")
        else:
            print("Item not found")
        return item
    except Exception as e:
        print(f"Error getting item: {e}")
        return None

def query_items(user_id):
    """Query items by partition key"""
    try:
        response = table.query(
            KeyConditionExpression=Key('UserId').eq(user_id)
        )
        items = response['Items']
        print(f"Query returned {len(items)} items:")
        for item in items:
            print(json.dumps(item, indent=2))
        return items
    except Exception as e:
        print(f"Error querying items: {e}")
        return []

def scan_items():
    """Scan all items in table (use cautiously on large tables)"""
    try:
        response = table.scan()
        items = response['Items']
        
        # Handle pagination
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            items.extend(response['Items'])
        
        print(f"Scan returned {len(items)} items")
        return items
    except Exception as e:
        print(f"Error scanning items: {e}")
        return []

def update_item(user_id, email, age=None, account_status=None):
    """Update specific attributes of an item"""
    try:
        update_expression = "SET "
        expression_attribute_values = {}
        expression_attribute_names = {}
        
        updates = []
        if age is not None:
            updates.append("#A = :age")
            expression_attribute_names["#A"] = "Age"
            expression_attribute_values[":age"] = age
        
        if account_status is not None:
            updates.append("AccountStatus = :status")
            expression_attribute_values[":status"] = account_status
        
        update_expression += ", ".join(updates)
        
        response = table.update_item(
            Key={
                'UserId': user_id,
                'Email': email
            },
            UpdateExpression=update_expression,
            ExpressionAttributeNames=expression_attribute_names if expression_attribute_names else None,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues="UPDATED_NEW"
        )
        print(f"Item updated: {response['Attributes']}")
        return response
    except Exception as e:
        print(f"Error updating item: {e}")
        return None

def delete_item(user_id, email):
    """Delete an item"""
    try:
        response = table.delete_item(
            Key={
                'UserId': user_id,
                'Email': email
            },
            ReturnValues='ALL_OLD'
        )
        if 'Attributes' in response:
            print(f"Item deleted: {response['Attributes']}")
        else:
            print("Item not found or already deleted")
        return response
    except Exception as e:
        print(f"Error deleting item: {e}")
        return None

def batch_operations():
    """Demonstrate batch write operations"""
    try:
        # Batch write items
        with table.batch_writer() as batch:
            batch.put_item(Item={
                'UserId': '101',
                'Email': 'alice@example.com',
                'Name': 'Alice',
                'Age': 30
            })
            batch.put_item(Item={
                'UserId': '102',
                'Email': 'bob@example.com',
                'Name': 'Bob',
                'Age': 25
            })
            batch.delete_item(Key={
                'UserId': '103',
                'Email': 'charlie@example.com'
            })
        print("Batch operations completed")
    except Exception as e:
        print(f"Error in batch operations: {e}")

def conditional_operations():
    """Demonstrate conditional writes"""
    try:
        # Only update if age is less than 30
        response = table.update_item(
            Key={
                'UserId': '101',
                'Email': 'alice@example.com'
            },
            UpdateExpression="SET #A = :age",
            ConditionExpression="Age < :max_age",
            ExpressionAttributeNames={"#A": "Age"},
            ExpressionAttributeValues={
                ":age": 31,
                ":max_age": 30
            },
            ReturnValues="UPDATED_NEW"
        )
        print("Conditional update successful")
        return response
    except Exception as e:
        print(f"Conditional update failed: {e}")
        return None

def main():
    """Main function to demonstrate all operations"""
    print("=== DynamoDB CRUD Operations ===\n")
    
    # Create table (comment out if table already exists)
    # create_table()
    
    # CRUD Operations
    print("1. Creating items...")
    put_item('101', 'alice@example.com', 'Alice Smith', 30, 'USA')
    put_item('102', 'bob@example.com', 'Bob Johnson', 25, 'Canada')
    put_item('103', 'charlie@example.com', 'Charlie Brown', 35, 'UK')
    
    print("\n2. Reading item...")
    get_item('101', 'alice@example.com')
    
    print("\n3. Querying items by UserId...")
    query_items('101')
    
    print("\n4. Updating item...")
    update_item('101', 'alice@example.com', age=31, account_status='Premium')
    
    print("\n5. Scanning all items...")
    scan_items()
    
    print("\n6. Batch operations...")
    batch_operations()
    
    print("\n7. Conditional operations...")
    conditional_operations()
    
    print("\n8. Deleting item...")
    delete_item('103', 'charlie@example.com')
    
    print("\n=== Operations Complete ===")

if __name__ == "__main__":
    main()