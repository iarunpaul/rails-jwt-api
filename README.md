# README

* Ruby version

* API Documentation

User Creation API
-------------------

Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/users
App Key 		:
Authorization	: bearer token
Method			: POST

Create admin (has role: admin, authorization as admin required to create an admin user)
Body:
{
    "username": "admin2", (required and should be unique)
    "password": "password", (required and should be in range 6..20 chars)
    "email": "admin2@example.com", (optional)
    "role": "admin"   (should be set as admin to create an admin)
}
Response:
{
    "status": 200,
    "error": null,
    "message": "User created successfully",
    "data": {
        "user": {
            "id": 7,
            "username": "admin2",
            "password_digest": "$2a$12$oKW1VwZpXimb6PXsC1rMj.w9d9XjUnhlkpHtWxbcjftFcoShMnadi",
            "email": "admin2@example.com",
            "role": "admin",
            "created_at": "2020-07-15T18:54:33.126Z",
            "updated_at": "2020-07-15T18:54:33.126Z"
        },
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo3fQ.kPxvpXMFUMcI-LnBA9ngNl8mL00Sk4OPFn8lElNcXHM"
    }
}

Create customer with role: customer
Authorization	: not required

Body:
{
    "username": "customer1", (required and should be unique)
    "password": "password", (required and should be in range 6..20 chars)
    "email": "email@example.com", (optional)
    "role": "customer"   (optional, default value: customer)
}
Response:

{
    "status": 200,
    "error": null,
    "message": "User created successfully",
    "data": {
        "user": {
            "id": 4,
            "username": "customer1",
            "password_digest": "$2a$12$OKbeO8zbCHbZQOhewBLMdO712dIGPszSKIrFFx0B90wzI.Pr4lkfC",
            "email": "email@example.com",
            "role": "customer",
            "created_at": "2020-07-15T17:54:54.657Z",
            "updated_at": "2020-07-15T17:54:54.657Z"
        },
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0fQ.TGZqqK-y64gP21bNqHhunTDewFSlGXWHpC17sPghG2k"
    }
}

Create owner with role: owner
Authorization	: not required
Body:
{
    "username": "owner", (required and should be unique)
    "password": "password", (required and should be in range 6..20 chars)
    "email": "owner@example.com", (optional)
    "role": "owner"  (optional, default value: customer)
}
Response:
{
    "satus": 200,
    "error": null,
    "message": "User created successfully",
    "data": {
        "user": {
            "id": 5,
            "username": "owner",
            "password_digest": "$2a$12$EwNuYFIs3XRudZBHh9490eNc0mY0s8CDEg69HNykUYZMCaZrwRhWa",
            "email": "owner@example.com",
            "role": "owner",
            "created_at": "2020-07-15T18:03:54.460Z",
            "updated_at": "2020-07-15T18:03:54.460Z"
        },
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1fQ.Zqphmh3IaPRjT13RMMpeyN4tBVssqtTKmCFs28yC_Ls"
    }
}
User Login
-------------

Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/login
App Key 		:
Authorization	: bearer token
Method			: POST

Log in user (authorization as any user required)

Body:
{
    "username": "customer",
    "password": "password"
}

Response:

{
    "status": 200,
    "error": null,
    "message": "User logged in successfully",
    "data": {
        "user": {
            "id": 3,
            "username": "customer",
            "password_digest": "$2a$12$fGb5QMTYqTg/M59iKuluoufLttDCt.9Z14sm/X33u099W/lG43tN2",
            "email": null,
            "role": "customer",
            "created_at": "2020-07-15T17:52:41.214Z",
            "updated_at": "2020-07-15T17:52:41.214Z"
        },
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozfQ.pDfHpeHdqQZa-UzzQYF_8GmQyyadQNxtA5-DZnczV9I"
    }
}

Current User details
---------------------

Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/current_user
App Key 		:
Authorization	: bearer token
Method			: GET

Show the current signed in user data

{
    "status": 200,
    "error": null,
    "message": "Your details",
    "data": {
        "user": {
            "id": 1,
            "username": "admin",
            "password_digest": "$2a$12$U4IVpibk0LSNJRwdYqbceuqKdlmDkixASEfH1w4EEqVzje6Rg/YLq",
            "email": "user@example.com",
            "role": "admin",
            "created_at": "2020-07-15T17:13:34.862Z",
            "updated_at": "2020-07-15T17:13:34.862Z"
        }
    }
}

User details update
---------------------

Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/users
App Key 		:
Authorization	: bearer token
Method			: PUT

Updates attributes for user

Admin user updates all attributes by username
Other users can update their own attributes except role as admin

Admin user

Body:
{
    "username": "customer1",
    "password": "password",
    "email": "@email.com",
    "role": "admin"
}

Response:

{
    "status": 200,
    "error": null,
    "message": "User with id : 4 is updated.",
    "data": {
        "id": 4,
        "username": "customer1",
        "password_digest": "$2a$12$G0gT/x.99UEUGYuRvL/wY.VHs92clw37DoqIZlkE3Q5yX6zJtoX4S",
        "email": "@email.com",
        "role": "admin",
        "created_at": "2020-07-15T17:54:54.657Z",
        "updated_at": "2020-07-15T22:14:18.839Z"
    }
}
Owner user update
Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/users
App Key 		:
Authorization	: bearer token
Method			: PUT


Body:
{

    "email": "changed@email.com"
}

Response:

{
    "status": 200,
    "error": null,
    "message": "Your record got updated.",
    "data": {
        "id": 5,
        "email": "changed@email.com",
        "password_digest": "$2a$12$EwNuYFIs3XRudZBHh9490eNc0mY0s8CDEg69HNykUYZMCaZrwRhWa",
        "username": "owner",
        "role": "owner",
        "created_at": "2020-07-15T18:03:54.460Z",
        "updated_at": "2020-07-15T21:50:16.891Z"
    }
}


User Account Delete
--------------------

Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/users
App Key 		:
Authorization	: bearer token
Method			: POST

Admin user deleting user by username

Body:
{
   "username": "customer1"

}

Response:
{
    "status": 200,
    "error": null,
    "message": "User customer1 is deleted.",
    "data": null
}

Customer user deleting their account

Headers:

Content type	: Application/Json
Request URL		: http://localhost:3000/users
App Key 		:
Authorization	: bearer token
Method			: POST

Response:
{
    "status": 200,
    "error": null,
    "message": "You have successfully deleted your account.",
    "data": null
}