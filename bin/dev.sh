#!/bin/bash

# Run assets precompilation
echo "Precompiling assets..."
rails assets:precompile

# Start the Rails server
echo "Starting Rails server..."
rails s
