# Self Destructing Messages

## Flow:
1. User posts message to the REST API endpoint
2. App generates a link and returns it as a response
3. User can do request to the provided link and see saved message only once
4. On second request info message “You already requested this message” should be
returned