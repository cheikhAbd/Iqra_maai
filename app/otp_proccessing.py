import requests

# Your unique validation key provided by Chinguisoft.
validation_key = 'sou1exrIoaUFVxlC'
# The API token required for authorization.
token = 'X32HQ38ERgP5GIAA1pjlu8nuZbH41mrE'

# The API endpoint for validation.
url = f"https://chinguisoft.com/api/sms/validation/{validation_key}"

# Headers for the request.
headers = {
    'Validation-token': token,
    'Content-Type': 'application/json',
}

# Data payload for the request.
data = {
    'phone': '49435749',
    'lang': 'ar'
}

# Make the POST request.
response = requests.post(url, headers=headers, json=data)

# Output the response body (validation result).
print(response.text)