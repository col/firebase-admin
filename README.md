# Firebase Admin

A ruby wrapper for the Firebase Admin APIs.

## Example

```
# Initial global configuration
FirebaseAdmin.configure do |config|
  config.project_id = "YOUR_PROJECT_ID"   
end

# Client specific configuration 
client = FirebaseAdmin.client(access_token: "")

# API call
response = client.create_account(
    email: "",
    ...
)

```