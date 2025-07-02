#!/bin/bash

echo "🔍 Testing all URLs from README.md..."
echo "=================================="

failed_urls=()
success_count=0
total_count=0

while IFS= read -r url; do
    if [[ -n "$url" ]]; then
        total_count=$((total_count + 1))
        echo -n "Testing: $url ... "
        
        # Use curl to get HTTP status code with timeout
        status_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 --connect-timeout 5 "$url")
        
        if [[ "$status_code" == "200" ]]; then
            echo "✅ $status_code"
            success_count=$((success_count + 1))
        else
            echo "❌ $status_code"
            failed_urls+=("$url")
        fi
    fi
done < urls_to_test.txt

echo ""
echo "=================================="
echo "📊 Results Summary:"
echo "Total URLs tested: $total_count"
echo "Successful (200): $success_count"
echo "Failed: $((total_count - success_count))"

if [[ ${#failed_urls[@]} -gt 0 ]]; then
    echo ""
    echo "❌ Failed URLs:"
    for failed_url in "${failed_urls[@]}"; do
        echo "  - $failed_url"
    done
else
    echo ""
    echo "🎉 All URLs are working properly!"
fi
