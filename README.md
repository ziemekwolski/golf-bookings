# Golf Bookings Programming Challenge

Where you can book all your booking times.

## Scenario

Your team is working with a golf club management company. As part of an enterprise-wide update the company would like a Rails app for booking tee times at their various clubs. Your job is to prototype the application over several iterations. Acceptance criteria will be provided for each iteration.

## Deliverable

This is not a design assignment. While the app should be usable, it needn't look pretty. If you wish to use something like Twitter Boostrap that's perfectly acceptable.

This exercise is not designed to take a long time. How much time you spend is totally up to you, but do not feel obligated to spend more than a few hours. With that said, your code should be of good quality: something that could easily be used as a base for a more complex production application.

## Release 1

Build a prototype Rails app which allows a user to book a tee-time at a single golf club.

Acceptance criteria:

* Tee times are separated by 20 minutes.
* Only one user may book a given twenty-minute slot.
* The golf club is open for bookings from 9am to 5pm every day.
* Users should have some mechanism to see if a time is already booked.
* Users should be able to cancel a booking.

## Release 2

The prototype has been approved by the management company. Please extend the application to support multiple golf clubs.

Acceptance criteria:

* The application should support multiple golf clubs. A user can make a booking at any club.

## Release 3

Management would like to add some constraints to the booking process.

Acceptance criteria:

* A given user should only be able to have a maximum of 2 concurrent bookings.
* Bookings can't be canceled when they start less than an hour from the current time.

## Requires

* Postgres
* Rails 4
* Ruby 1.9

## Setup

Configure your own database.yml, run rake db:migrate
