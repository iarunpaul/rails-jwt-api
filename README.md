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

POST request takes the username and password as request body parameters and response includes the token issued for authorization along with the user data,message of transaction if User data matches. If no match, info message returns. No ```auth_token``` refresh sent in response headers

Request:

Headers:

Content type: Application/Json
Request URL: localhost:3000/login
api-key: 123

METHOD: POST

Body:

{
    "username": "admin",
    "password": "password"
}


Response:

Headers:

Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin


Body:

{
    "status": 200,
    "message": "User logged in successfully",
    "data": {
        "user": {
            "id": 1,
            "username": "admin",
            "password_digest": "$2a$12$8bOTiNvAJ232y0ujayte3uVCYMghGBgNrVBKI9bm4uFcu4QyVXy/O",
            "email": "user@example.com",
            "role": "admin",
            "created_at": "2020-07-17T12:25:38.120Z",
            "updated_at": "2020-07-17T12:25:38.120Z"
        },
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwMTE5OTd9.OsfsS-Anf6OHQSy96A_J7TisoadMFPGzIDwtiQqiTbg"
    }
}

USER CREATE
---------------

Takes the `username` and `password` as required parametes and `role`(default `customer`) and `email` as optional from request body with `Bearer token` from header request that verifies user details. If the authenticated user is `admin` permissions are granted to create `admin` user in addition to `owner` and `customer` users creation privillages. Anything except `admin` token is given as valid `Auth token`, then  parameters valid for a user creation will create a user except with `role: admin`. Refreshes the token for admin user whenever action runs and sends response header refreshed token each time as `auth_token`

test data for admin user
Request:

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "username": "customer4",
   "password": "password",
   "email": "customertest2@email.com",
   "role": "customer"
}

Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwMTQ3ODd9.XgIWSOsmg2Ex0JzQ6jCu4oKAmfMsgNtDTZsVutJ4XnQ

Body:
{
    "status": 200,
    "message": "User with id 9 created successfully",
    "data": {
        "user": {
            "id": 9,
            "username": "customer4",
            "password_digest": "$2a$12$.SXCTs3VuXBdrbrF8zQRke.eBRIAOecUT5jX3X9R/AHEa.qEBwo86",
            "email": "customertest2@email.com",
            "role": "customer",
            "created_at": "2020-07-17T19:24:47.888Z",
            "updated_at": "2020-07-17T19:24:47.888Z"
        },
        "user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo5LCJleHAiOjE1OTUwMTQ3ODd9.K_v9_T67HMAz7wiJgnnz9dV4rYyrD0DwjNHN6fm1GU8"
    }
}

test data without authorization
Request:

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:
{
   "username": "owner",
   "password": "password",
   "email": "owner@email.com",
   "role": "owner"
}

Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin


Body:
{
    "status": 200,
    "message": "User created successfully",
    "data": {
        "user": {
            "id": 10,
            "username": "owner",
            "password_digest": "$2a$12$xleVL2nJ4n2Mlc.GClMZC.Yku673TkjbO6svTw1U38mszC3uXvCHS",
            "email": "owner@email.com",
            "role": "owner",
            "created_at": "2020-07-17T19:29:56.503Z",
            "updated_at": "2020-07-17T19:29:56.503Z"
        },
        "user_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE1MDk2fQ.bjuOCoDUHFsArTFeV0Y0-dTVqZLma3NSp1hMF6mSuLw"
    }
}

CURRENT USER
--------------
A GET request that takes the `Bearer token` and gives the current signed in user if any. Refreshes the current user token by a before_action hook and sends the response header `auth_token`

Request:


Content type: Application/Json
Request URL: localhost:3000/current_user
api-key: 123
Authorization: Bearer <token>
METHOD: GET

Response:

Headers:

Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwMTM5MjN9.ByrNw8QvOnrpoY3KpFD6Xr561oT5qb2B0GtGPIw4_Us


Body:

{
    "status": 200,
    "message": "You are logged in as:",
    "data": {
        "id": 1,
        "username": "admin",
        "password_digest": "$2a$12$8bOTiNvAJ232y0ujayte3uVCYMghGBgNrVBKI9bm4uFcu4QyVXy/O",
        "email": "user@example.com",
        "role": "admin",
        "created_at": "2020-07-17T12:25:38.120Z",
        "updated_at": "2020-07-17T12:25:38.120Z"
    }
}

User Update
--------------
A PUT request that updates the attributes of a User. If the user is not an admin they can update any fields except for the role as "admin" value. The admin can find the user by username and update any attribute including the role assignation.

Request:

As admin user authorized update

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: PUT
Body:

{
   "username": "customer",
   "role": "admin",
   "email": "changed@email.com"
}

Response:

Headers:

Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwMTU3ODd9.eKKejofKB6eiQoOxkS667Los_q8Q3GlugLd3zEZchGI
Body:

{
    "status": 200,
    "message": "User with id 3 is updated successfully",
    "data": {
        "user": {
            "id": 3,
            "username": "customer",
            "email": "changed@email.com",
            "role": "admin",
            "password_digest": "$2a$12$h4LjcFDrZAF86SDOk//ABee3W.fwkD2JcPCNi3TmyaZBAdeRjzDkG",
            "created_at": "2020-07-17T12:25:38.648Z",
            "updated_at": "2020-07-17T19:37:37.088Z"
        }
    }
}

Request:

As standard user for self account update

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: PUT
Body:

{

   "email": "changed@email.com"
}

Response:

Headers:

Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo5LCJleHAiOjE1OTUwMTY5MDZ9.mWykZsECQiQiXp7d5LIHY6wse-oRnq2dHxXDnCJG-H8

Body:

{
    "status": 200,
    "message": "Your accout got updated successfully",
    "data": {
        "user": {
            "id": 9,
            "email": "changed@email.com",
            "password_digest": "$2a$12$.SXCTs3VuXBdrbrF8zQRke.eBRIAOecUT5jX3X9R/AHEa.qEBwo86",
            "username": "customer4",
            "role": "customer",
            "created_at": "2020-07-17T19:24:47.888Z",
            "updated_at": "2020-07-17T19:57:56.707Z"
        }
    }
}

Delete User
-----------

A POST request with username as request parameter finds and deletes the user associated. The admin can find and delete the record related to any account while other users can delete their own.

Deleting a user account as an admin

Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/delete_user
api-key: 123
Authorization: bearer <token>
METHOD: POST


Body:

{
   "username": "customer2"
}


Response:
Headers:

Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwMTg1NjR9.CH_YtBX7Jh3BFhT65bbabg4HfnSxuCkJnf90hJmB95A

{
    "status": 200,
    "message": "User with id 4 is deleted successfully",
    "data": null
}

(deleting self account)
Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/delete_user
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{

}

Response:
Headers:

Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo5LCJleHAiOjE1OTUwMTgyMTJ9.fuZDX1W4x6jawzOtClfhMGyXbrwU_awwj3obAYugPCs

Body:
{
    "status": 200,
    "message": "You have successfully deleted your account.",
    "data": null
}

User Show
--------------

A GET request that takes username as request parameter finds the user details associated. Only admin can find the record of user by show method. The standard users can get their details by current_user method after logging in



Request:
Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: GET

Body:

{
   "username": "owner"
}

Response:

Body:

{
    "status": 200,
    "message": "See received user details.",
    "data": {
        "user": {
            "id": 10,
            "username": "owner",
            "password_digest": "$2a$12$xleVL2nJ4n2Mlc.GClMZC.Yku673TkjbO6svTw1U38mszC3uXvCHS",
            "email": "owner@email.com",
            "role": "owner",
            "created_at": "2020-07-17T19:29:56.503Z",
            "updated_at": "2020-07-17T19:29:56.503Z"
        }
    }
}

Request:
By non admin user

Content type: Application/Json
Request URL: localhost:3000/users
api-key: 123
Authorization: bearer <token>
METHOD: GET

Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY

Body:

{
    "status": 403,
    "message": "Only admin can view user details.",
    "data": null
}



HOTEL Create
---------------------
Owner and admin can create a Hotel. parameters `name`, `rate` and `rating` and `owner_id` are required parameters. If owner creates the hotel `owner_id` is created as the `owner`.id implicit. `customer` is not permitted to create a Hotel object.

Request:
By admin user

Content type: Application/Json
Request URL: localhost:3000/hotels
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "name": "SunPool",
   "rating": 5,
   "rate": 750,
   "owner_id": 10

}
Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY

Body:{
    "status": 200,
    "message": "You have created the hotel records successfully",
    "data": {
        "id": 3,
        "name": "SunPool",
        "rating": 5,
        "description": null,
        "created_at": "2020-07-17T21:16:16.514Z",
        "updated_at": "2020-07-17T21:16:16.514Z",
        "rate": "750.0",
        "owner_id": 10
    }
}

Request:
By owner user

Headers:
Content type: Application/Json
Request URL: localhost:3000/hotels
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "name": "SunPoolasdf",
   "rating": 5,
   "rate": 1250
}
Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY

Body:
{
    "status": 200,
    "message": "You have created the hotel records successfully",
    "data": {
        "id": 10,
        "name": "SunPoolasdf",
        "rating": 5,
        "description": null,
        "created_at": "2020-07-18T03:35:40.011Z",
        "updated_at": "2020-07-18T03:35:40.011Z",
        "rate": "1250.0",
        "owner_id": 10
    }
}


HOTEL List
--------------
All users can see the list of hotels by authenticating

Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/hotels/index
api-key: 123
Authorization: bearer <token>
METHOD: GET

Response:
Body:

{
    "status": 200,
    "message": "Hotels List:",
    "data": [
        {
            "id": 1,
            "name": "SunMoon",
            "rating": 3,
            "description": "The best class hotel in town!",
            "created_at": "2020-07-17T12:25:38.961Z",
            "updated_at": "2020-07-17T12:25:38.961Z",
            "rate": "1000.0",
            "owner_id": 2
        },
        {
            "id": 2,
            "name": "MoonSun",
            "rating": 3,
            "description": "The best class hotel in town!",
            "created_at": "2020-07-17T12:25:38.987Z",
            "updated_at": "2020-07-17T12:25:38.987Z",
            "rate": "1000.0",
            "owner_id": 2
        },
        {
            "id": 3,
            "name": "SunPool",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-17T21:16:16.514Z",
            "updated_at": "2020-07-17T21:16:16.514Z",
            "rate": "750.0",
            "owner_id": 10
        },
        {
            "id": 4,
            "name": "SunPool",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:11:10.864Z",
            "updated_at": "2020-07-18T03:11:10.864Z",
            "rate": "750.0",
            "owner_id": 10
        },
        {
            "id": 5,
            "name": "SunPool",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:16:18.721Z",
            "updated_at": "2020-07-18T03:16:18.721Z",
            "rate": "1250.0",
            "owner_id": 10
        },
        {
            "id": 6,
            "name": "SunPool",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:20:48.254Z",
            "updated_at": "2020-07-18T03:20:48.254Z",
            "rate": "1250.0",
            "owner_id": 10
        },
        {
            "id": 7,
            "name": "SunPool",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:21:05.803Z",
            "updated_at": "2020-07-18T03:21:05.803Z",
            "rate": "1250.0",
            "owner_id": 10
        },
        {
            "id": 8,
            "name": "SunPoolasdf",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:21:30.598Z",
            "updated_at": "2020-07-18T03:21:30.598Z",
            "rate": "1250.0",
            "owner_id": 10
        },
        {
            "id": 9,
            "name": "SunPoolasdf",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:21:51.526Z",
            "updated_at": "2020-07-18T03:21:51.526Z",
            "rate": "1250.0",
            "owner_id": 10
        },
        {
            "id": 10,
            "name": "SunPoolasdf",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:35:40.011Z",
            "updated_at": "2020-07-18T03:35:40.011Z",
            "rate": "1250.0",
            "owner_id": 10
        },
        {
            "id": 11,
            "name": "SunPool",
            "rating": 5,
            "description": null,
            "created_at": "2020-07-18T03:41:41.725Z",
            "updated_at": "2020-07-18T03:41:41.725Z",
            "rate": "1250.0",
            "owner_id": 11
        }
    ]
}

HOTEL Show
-------------------

Fetches the details of hotel with `id`

Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/show_hotel
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "id": 10
}

Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY

Body:

{
    "status": 200,
    "message": "The hotel details:",
    "data": {
        "id": 10,
        "name": "SunPoolasdf",
        "rating": 5,
        "description": null,
        "created_at": "2020-07-18T03:35:40.011Z",
        "updated_at": "2020-07-18T03:35:40.011Z",
        "rate": "1250.0",
        "owner_id": 10
    }
}

Hotel Update
------------------
Admin can update all hotels with all parameters. Owner can edit his own hotel
as admin
Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/hotels
api-key: 123
Authorization: bearer <token>
METHOD: PUT
Body:
{
   "id": 1,
   "name": "ChangedAgain",
   "owner_id": 10
}
Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY

Body:
{
    "status": 200,
    "message": "The hotel ChangedAgain has been updated.",
    "data": {
        "id": 1,
        "name": "ChangedAgain",
        "owner_id": 10,
        "rate": "1000.0",
        "rating": 3,
        "description": "The best class hotel in town!",
        "created_at": "2020-07-17T12:25:38.961Z",
        "updated_at": "2020-07-18T05:10:36.193Z"
    }
}

Hotel Delete
-----------------
Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/delete_hotel
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "id": 3
}
Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY

Body:

{
    "status": 200,
    "message": "You have successfully deleted the Hotel Changed's records.",
    "data": null
}

Bookings list for a Hotel
-------------------------------------
Lists all the bookings in a hotel by `id`

Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/bookings_in_hotel
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:
{
   "id": 2
}

Response:
Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwiZXhwIjoxNTk1MDE5ODU5fQ.ht_Ey2jVlUf6fP1HRP_SzJAuXghb3uFiw2za4DYXEpY


Body:

{
    "status": 200,
    "message": "The list of bookings for the Hotel is:",
    "data": [
        {
            "id": 4,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-17T12:25:39.132Z",
            "updated_at": "2020-07-17T12:25:39.132Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 5,
            "hotel_id": 2,
            "user_id": 4,
            "payment_status": false,
            "created_at": "2020-07-17T12:25:39.156Z",
            "updated_at": "2020-07-17T12:25:39.156Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 6,
            "hotel_id": 2,
            "user_id": 1,
            "payment_status": false,
            "created_at": "2020-07-17T12:25:39.181Z",
            "updated_at": "2020-07-17T12:25:39.181Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        }
    ]
}


Bookings Creation
-------------------------------

Creates bookings by POST request `hotel_id` and `user_id` required. `adults` and `children` optional. `user_id` is set as current user id for users other than admin. `payment_status` set to default `false` on creation and `booking_status` to `pending` and they change to `true` and `confirmed` respectively upon successful payment.

Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/bookings
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:
{
   "hotel_id": 2,
   "adults": 3,
   "children": 3
}

Response:
Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token:eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJleHAiOjE1OTUwNTY1MDd9.-UElLHs18D-qBPLrh_pYn2rRoq7Y64MK6u6LKi_7Lls


Body:
{
    "status": 200,
    "message": "Booking with id 8 created",
    "data": {
        "id": 8,
        "hotel_id": 2,
        "user_id": 3,
        "payment_status": false,
        "created_at": "2020-07-18T07:00:07.818Z",
        "updated_at": "2020-07-18T07:00:07.818Z",
        "adults": 3,
        "children": 3,
        "rate": "1000.0",
        "amount": "4500.0",
        "booking_status": "pending"
    }
}


List of Bookings relevant to roles

Admin gets all the lists. Customer gets own list and owner gets bookings in hotel owned.
Request:

as customer

Headers:
Content type: Application/Json
Request URL: localhost:3000/bookings/list
api-key: 123
Authorization: bearer <token>
METHOD: GET

Response:
Response:
Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token:eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJleHAiOjE1OTUwNTY1MDd9.-UElLHs18D-qBPLrh_pYn2rRoq7Y64MK6u6LKi_7Lls

Body:

{
    "status": 200,
    "message": "The relevant bookings for you:",
    "data": [
        {
            "id": 1,
            "hotel_id": 1,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.300Z",
            "updated_at": "2020-07-18T06:56:12.300Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 4,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.400Z",
            "updated_at": "2020-07-18T06:56:12.400Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 7,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T06:58:54.301Z",
            "updated_at": "2020-07-18T06:58:54.301Z",
            "adults": 1,
            "children": null,
            "rate": "1000.0",
            "amount": "1000.0",
            "booking_status": "pending"
        },
        {
            "id": 8,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T07:00:07.818Z",
            "updated_at": "2020-07-18T07:00:07.818Z",
            "adults": 3,
            "children": 3,
            "rate": "1000.0",
            "amount": "4500.0",
            "booking_status": "pending"
        }
    ]
}

Request:

as customer

Headers:
Content type: Application/Json
Request URL: localhost:3000/bookings/list
api-key: 123
Authorization: bearer <token>
METHOD: GET


Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token:eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwNTc1MDd9.qeZEA48TfuT-Q8v6fJNofSoQYhxoD_G8xb96uLwzUbE

Body:

{
    "status": 200,
    "message": "The relevant bookings for you:",
    "data": [
        {
            "id": 1,
            "hotel_id": 1,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.300Z",
            "updated_at": "2020-07-18T06:56:12.300Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 2,
            "hotel_id": 1,
            "user_id": 4,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.333Z",
            "updated_at": "2020-07-18T06:56:12.333Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 3,
            "hotel_id": 1,
            "user_id": 1,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.367Z",
            "updated_at": "2020-07-18T06:56:12.367Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 4,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.400Z",
            "updated_at": "2020-07-18T06:56:12.400Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 5,
            "hotel_id": 2,
            "user_id": 4,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.437Z",
            "updated_at": "2020-07-18T06:56:12.437Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 6,
            "hotel_id": 2,
            "user_id": 1,
            "payment_status": false,
            "created_at": "2020-07-18T06:56:12.471Z",
            "updated_at": "2020-07-18T06:56:12.471Z",
            "adults": 3,
            "children": 1,
            "rate": null,
            "amount": null,
            "booking_status": "pending"
        },
        {
            "id": 7,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T06:58:54.301Z",
            "updated_at": "2020-07-18T06:58:54.301Z",
            "adults": 1,
            "children": null,
            "rate": "1000.0",
            "amount": "1000.0",
            "booking_status": "pending"
        },
        {
            "id": 8,
            "hotel_id": 2,
            "user_id": 3,
            "payment_status": false,
            "created_at": "2020-07-18T07:00:07.818Z",
            "updated_at": "2020-07-18T07:00:07.818Z",
            "adults": 3,
            "children": 3,
            "rate": "1000.0",
            "amount": "4500.0",
            "booking_status": "pending"
        }
    ]
}


Show Booking
----------------------------
Gets a booking by `id`


Request:

Headers:
Content type: Application/Json
Request URL: localhost:3000/bookings/list
api-key: 123
Authorization: bearer <token>
METHOD: POST

Body:

{
   "id": 2
}



Response:

Headers:
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Referrer-Policy: strict-origin-when-cross-origin
auth_token:eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1OTUwNTc1MDd9.qeZEA48TfuT-Q8v6fJNofSoQYhxoD_G8xb96uLwzUbE


Body:

{
    "status": 200,
    "message": "The booking with id 2 is:",
    "data": {
        "id": 2,
        "hotel_id": 1,
        "user_id": 4,
        "payment_status": false,
        "created_at": "2020-07-18T06:56:12.333Z",
        "updated_at": "2020-07-18T06:56:12.333Z",
        "adults": 3,
        "children": 1,
        "rate": null,
        "amount": null,
        "booking_status": "pending"
    }
}