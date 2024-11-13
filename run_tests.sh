#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Building test environment...${NC}"

# Build and run tests using docker-compose
docker-compose -f docker-compose.test.yml build && \
docker-compose -f docker-compose.test.yml up --abort-on-container-exit

# Get the exit code from the test container
TEST_EXIT_CODE=$?

# Clean up
echo -e "${YELLOW}Cleaning up test environment...${NC}"
docker-compose -f docker-compose.test.yml down

# Report final status
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}All tests passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Tests failed with exit code $TEST_EXIT_CODE${NC}"
    exit 1
fi
