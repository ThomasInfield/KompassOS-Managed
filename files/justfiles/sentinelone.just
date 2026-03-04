# Test this Just file: /usr/bin/just --justfile files/justfiles/sentinelone.just --choose

# Configure SentinelOne registration token
[group('SentinelOne')]
sentinelone-set-token:
    #!/usr/bin/env bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh

    echo "${blue}SentinelOne — Token instellen${normal}"
    echo "Vul het Site- of Group Token in vanuit de Management Console."
    echo ""

    TOKEN=$(gum input --placeholder "Plak hier je SentinelOne token..." --password)

    if [[ -z "$TOKEN" ]]; then
        echo "${red}Geen token ingevoerd. Afgebroken.${normal}"
        exit 1
    fi

    echo "${blue}Token instellen...${normal}"
    sudo /opt/sentinelone/bin/sentinelctl management token set "$TOKEN"
    echo "${green}Token succesvol ingesteld.${normal}"
    echo ""
    echo "${blue}SentinelOne agent starten...${normal}"
    sudo /opt/sentinelone/bin/sentinelctl control start
    echo "${green}Agent gestart.${normal}"

# Start the SentinelOne agent
[group('SentinelOne')]
sentinelone-start:
    #!/usr/bin/env bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh

    echo "${blue}SentinelOne agent starten...${normal}"
    sudo /opt/sentinelone/bin/sentinelctl control start
    echo "${green}Agent gestart.${normal}"

# Show SentinelOne agent status
[group('SentinelOne')]
sentinelone-status:
    #!/usr/bin/env bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh

    echo "${blue}=== Agent status ===${normal}"
    sudo /opt/sentinelone/bin/sentinelctl control status
    echo ""
    echo "${blue}=== Management connectiviteit ===${normal}"
    sudo /opt/sentinelone/bin/sentinelctl management status

# Show SentinelOne agent version
[group('SentinelOne')]
sentinelone-version:
    #!/usr/bin/env bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh

    echo "${blue}SentinelOne versie-informatie:${normal}"
    sudo /opt/sentinelone/bin/sentinelctl version
