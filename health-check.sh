#!/bin/bash
curl -sSf http://localhost:3001/todos > /dev/null
if [ $? -eq 0 ]; then
	echo "Health check passed."
else
    	echo "Health check failed."
  	exit 1
fi
      
