# README

API Documentation
------------------
<!-- Current User Details

Headers:

Content type: Application/Json
Request URL: localhost:3000/current user
api-key: 123
Authorization: bearer <token>
METHOD: GET -->

User Login
------------

POST request takes the username and password as request body parameters and response includes the token issued for authorization along with the user data,message of transaction if User data matches. If no match, info message returns. A refresh token value is returned for current logged user which will always return null for LOGIN action.

Request:

Headers:

Content type: Application/Json
Request URL: localhost:3000/current user
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
    "username": "admin",
    "password": "password"
}


Response:

Body:

{
    "status": 200,
    "message": "User logged in successfully",
    "data": {
        "user": {
            "id": 1,
            "username": "admin",
            "password_digest": "$2a$12$rMbWyU/41waNQpO4y0O3L.jcH49AYqv9DV1kOPJkNhOpy7mLM2BQG",
            "email": "user@example.com",
            "role": "admin",
            "created_at": "2020-07-17T07:15:02.134Z",
            "updated_at": "2020-07-17T07:15:02.134Z"
        },
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTQ5ODU5OTh9.G8oPxqGOjKwEGfuTJZX_e6sbq7Bv-ESNN32SPmvCf4s"
    },
    "current_user_token": null
}

USER CREATE
---------------

Takes the username and password as required parametes and role and email as optional from request body with bearer token from header request that verifies user details. If the authenticated user is admin permissions are granted to create admin user in addition to owner and customer users creation privillages. Anything except admin token is given, then valid parameters for a user creation will create a user except with role: "admin". Refreshes the token for admin user

Request:

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "username": "customer1",
   "password": "password",
   "email": "customer@email.com",
   "role": "customer"
}

Response:

{
    "status": 200,
    "message": "User with id 5 created successfully",
    "data": {
        "user": {
            "id": 5,
            "username": "customer1",
            "password_digest": "$2a$12$WuC858T762InYyHEOt6vF.kyIRnPVE.wHBStFpsNVwBfF11duevqe",
            "email": "customer@email.com",
            "role": "customer",
            "created_at": "2020-07-17T11:54:16.013Z",
            "updated_at": "2020-07-17T11:54:16.013Z"
        },
        "user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1LCJleHAiOjE1OTQ5ODc3NTZ9.AFd7es4gJQZ74n-oNgu7OFVO71-SZd1ZvV0SBaFYMHM"
    },
    "current_user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTQ5ODc3NTV9.NxxHFaawKj3Y6OG8gH4hiAaTJb68gZbi8HUUNL_IkNo"
}

CURRENT USER
--------------
A GET request that Decodes the bearer token and gives the current signed in user if any. Refreshes the current user token


Request:


Content type: Application/Json
Request URL: localhost:3000/current_user
api-key: 123
Authorization: bearer <token>
METHOD: GET

Response:

Body:

{
    "status": 200,
    "message": "You are logged in as:",
    "data": {
        "id": 1,
        "username": "admin",
        "password_digest": "$2a$12$XGcB55VvAhpMedy6SCTSNu6ie6miEstRXzkwgwAXTiRQ9ydWrRCb6",
        "email": "user@example.com",
        "role": "admin",
        "created_at": "2020-07-17T11:53:56.822Z",
        "updated_at": "2020-07-17T11:53:56.822Z"
    },
    "current_user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTQ5ODg1MTR9.1giHTCW29JamHTRodCjVCAa_wAHiTy37-oX-zOomFjc"
}

User Update
--------------
A PUT request that updates the attributes of a User. If the user is not an admin they can update any fields except for the role as "admin" value. The admin can find the user by username and update any attribute including the role assignation.

Request:

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: PUT
Body:

{
   "username": "customer1",
   "password": "passpass",
   "email": "changed@email.com",
   "role": "admin"

}

Response:

Body:

{
    "status": 200,
    "message": "User with id 5 is updated successfully",
    "data": {
        "user": {
            "id": 5,
            "username": "customer1",
            "password_digest": "$2a$12$I/TnXo/bSwS3Zl61/PR6/O0FbU.RczAeCLmH8VBdIIdoN6Q0Itm.q",
            "email": "changed@email.com",
            "role": "admin",
            "created_at": "2020-07-17T12:26:03.900Z",
            "updated_at": "2020-07-17T13:03:50.550Z"
        }
    },
    "current_user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTQ5OTE5MzB9.qyeG-s1ZLDhZVnBw29a80fU1NfLiLXuxYHRvnJxneG4"
}

Delete User
-----------

A POST request with username as request parameter finds and deletes the user associated. The admin can find and delete the record related to any account while other users can delete their own.


Content type: Application/Json
Request URL: localhost:3000/delete_user
api-key: 123
Authorization: bearer <token>
METHOD: POST

Request:

Body:

{
   "username": "customer1"
}


Response:

{
    "status": 200,
    "message": "User with id 5 is deleted successfully",
    "data": null,
    "current_user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTQ5OTI2NTl9.igncCYydXrchetY6KIp6HzxfGiQzoq4V0uFLATvsPMQ"
}

(deleting self account)
Request:

Body:

{
   "username": "owner"
}

Response:

Body:

{
    "status": 200,
    "message": "You have successfully deleted your account.",
    "data": null,
    "current_user_token": null
}

User Show
--------------

A GET request that takes username as request parameter finds the user details associated. Only admin can find the record of user by show method. The standard users can get their details by current_user method after logging in

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: GET

Request:

Body:

{
   "username": "customer2"
}

Response:

Body:

{
    "status": 200,
    "message": "See the user details.",
    "data": {
        "user": {
            "id": 4,
            "username": "customer2",
            "password_digest": "$2a$12$/1oJ8y8MuVk4psoY0.SOWuU2LSy29nycM.HfuBuUS1rxf1stxPoMm",
            "email": "user@example.com",
            "role": "owner",
            "created_at": "2020-07-17T12:25:38.910Z",
            "updated_at": "2020-07-17T12:25:38.910Z"
        }
    },
    "current_user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTQ5OTU2MDJ9.elNXVsuJ-LpZh-THc2dQrutEdOtBKTrviSj7PWsPxT4"
}