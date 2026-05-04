#!/bin/bash
echo "Master (100.25.246.38): $(ssh -i /home/aniket/accesskey -o StrictHostKeyChecking=no ubuntu@100.25.246.38 hostname -I | awk '{print $1}')"
echo "Node 1 (34.205.225.101): $(ssh -i /home/aniket/accesskey -o StrictHostKeyChecking=no ubuntu@34.205.225.101 hostname -I | awk '{print $1}')"
echo "Node 2 (18.234.219.40): $(ssh -i /home/aniket/accesskey -o StrictHostKeyChecking=no ubuntu@18.234.219.40 hostname -I | awk '{print $1}')"
echo "Node 3 (44.204.26.141): $(ssh -i /home/aniket/accesskey -o StrictHostKeyChecking=no ubuntu@44.204.26.141 hostname -I | awk '{print $1}')"
echo "Node 4 (13.218.117.158): $(ssh -i /home/aniket/accesskey -o StrictHostKeyChecking=no ubuntu@13.218.117.158 hostname -I | awk '{print $1}')"
