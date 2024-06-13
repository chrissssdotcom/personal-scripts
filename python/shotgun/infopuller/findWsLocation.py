import shotgun_api3
import json
import sys
import os
from tabulate import tabulate
from dotenv import load_dotenv

load_dotenv()

# Shotgun API credentials and site URL
SERVER_PATH = os.getenv('SERVER_PATH')
SCRIPT_NAME = os.getenv('SCRIPT_NAME')
SCRIPT_KEY = os.getenv('SCRIPT_KEY')

# Connect to the Shotgun server
sg = shotgun_api3.Shotgun(SERVER_PATH, SCRIPT_NAME, SCRIPT_KEY)



# Ensure a name is provided as an argument
if len(sys.argv) != 2:
    print("Usage: python fetch_computer_data.py <sg_name>")
    sys.exit(1)

sg_name = sys.argv[1]

# Define the entity name for the "Computers" table
entity_name = 'CustomEntity01'

# Define the fields you want to retrieve
fields = [
    'sg_name', 'sg_serial_number', 'sg_used_by',
    'sg_location_1', 'sg_desk', 'sg_location_3'
]

# Retrieve data from the "Computers" table based on sg_name
filters = [['sg_name', 'is', sg_name]]
computers_data = sg.find(entity_name, filters, fields)

# Print the data in the desired format
if computers_data:
    computer = computers_data[0]
    sg_used_by = computer.get('sg_used_by')
    sg_used_by_name = sg_used_by['name'] if sg_used_by else 'None'

    # Prepare data for the table
    header = ["Field", "Value"]
    top_data = [
        ["Name", computer.get('sg_name')],
        ["Serial Number", computer.get('sg_serial_number')],
        ["Used By", sg_used_by_name]
    ]
    location_data = [
        ["Location 1", computer.get('sg_location_1')],
        ["Location 2", computer.get('sg_desk')],
        ["Location 3", computer.get('sg_location_3')]
    ]

    # Print top data
    print(tabulate(top_data, headers=header, tablefmt="grid"))
    print()
    # Print location data
    print(tabulate(location_data, headers=header, tablefmt="grid"))

else:
    print(f"No computer found with sg_name: {sg_name}")