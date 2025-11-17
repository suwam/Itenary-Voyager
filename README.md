🌍Itinerary Voyager

Itinerary Voyager is a mobile application developed as a final-year project to help users create personalized and well-structured travel plans. 
The system combines modern technologies such as Flutter, Firebase, and Google Maps APIs to provide users with smart itinerary suggestions, scenic route visualization, and location-based recommendations.
The goal of this project is to make travel planning easier, more accurate, and more enjoyable.

Features
1. Personalized Itinerary Planning
The user enters their destination, travel dates, and preferences. Based on this information, the application automatically generates a day-wise itinerary, including popular attractions, cultural spots, food places, and activities.

2. Scenic Route Optimization (A* Algorithm)
To enhance the travel experience, the project uses the A* algorithm to calculate an optimized scenic route.
The heuristic function h(n) estimates the straight-line distance to the destination.
Additional factors like scenic score and points of interest (POIs) are included to recommend routes that are not only shortest but more enjoyable.

3. Google Maps Integration
The app displays the travel route directly on a map using polylines.
Each activity point has a marker.
Location coordinates are fetched dynamically using the Google Geocoding API.
Users can interact with the map to explore details of each spot.

4. Smart POI and Sub-Location Suggestions
When users type broad destinations (e.g., Kathmandu Valley), the app automatically suggests major sub-locations such as Patan, Bouddha, and Thamel.
Each sub-location contains a list of popular places and activities with real coordinates.

5. Firebase Integration
Firebase Authentication for secure login and signup.
Cloud Firestore stores itineraries, user preferences, and route details.
Users can save, view, edit, and delete their itineraries at any time.

6. Role-Based Access
The system allows administrators to manage POIs, scenic data, and route information, while normal users can generate and view itineraries.

Technologies Used

Flutter (Dart) – Frontend UI development

Firebase Authentication – User login and registration

Cloud Firestore – Storing itineraries and route data

Google Maps SDK – Map rendering

Google Directions & Geocoding API – Route and coordinate generation

A* Algorithm – Scenic route optimization

📌Project Workflow Overview

User enters travel preferences.

The system fetches coordinates using Geocoding API.

A* algorithm computes the scenic route based on distance
, heuristic, and POIs.

The itinerary is generated and stored in Firestore.

The user views the itinerary along with a visual route on Google Maps.

[Major Project for the Bachelor in Computer Engineering.docx](https://github.com/user-attachments/files/23572825/Major.Project.for.the.Bachelor.in.Computer.Engineering.docx)
