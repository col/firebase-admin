# Firebase Auth

A ruby wrapper for the Firebase Auth APIs.

## Example

```

# Initial global configuration
FirebaseAuth.configure do |config|
  config.project_id = "YOUR_PROJECT_ID"   
end

# Client specific configuration 
client = FirebaseAuth.client(access_token: "")

# API call
response = client.create_account(
    email: "",
    ...
)

```