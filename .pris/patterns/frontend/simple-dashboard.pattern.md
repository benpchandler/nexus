---
pattern_id: "simple-dashboard"
name: "Simple HTML Dashboard"
language: "html"
framework: "vanilla"
type: "frontend"
tags: ["dashboard", "simple", "html", "vanilla", "minimal"]
description: "Basic dashboard with HTML/CSS/JS - no frameworks or build process"
usage_prompt: "When creating simple dashboards for personal use or learning"
complexity_tier: "minimal"
appropriate_for: ["learning", "personal", "prototypes", "quick-tools"]
avoid_for: ["enterprise", "complex-state", "team-development"]
dependencies_count: 0
estimated_lines: 100
common_mistakes:
  - "Adding unnecessary frameworks"
  - "Complex build processes"
  - "Over-engineering simple data display"
success_rate: 0.99
usage_count: 8
---

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .dashboard {
            max-width: 1200px;
            margin: 0 auto;
        }
        .card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: inline-block;
            width: 300px;
            vertical-align: top;
        }
        .card h3 {
            margin-top: 0;
            color: #333;
        }
        .metric {
            font-size: 2em;
            font-weight: bold;
            color: #2196F3;
        }
        .loading {
            color: #999;
            font-style: italic;
        }
        .error {
            color: #f44336;
        }
        button {
            background: #2196F3;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background: #1976D2;
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <h1>My Dashboard</h1>
        
        <div class="card">
            <h3>Data Source 1</h3>
            <div id="metric1" class="metric loading">Loading...</div>
            <p id="description1">Fetching data...</p>
        </div>
        
        <div class="card">
            <h3>Data Source 2</h3>
            <div id="metric2" class="metric loading">Loading...</div>
            <p id="description2">Fetching data...</p>
        </div>
        
        <div class="card">
            <h3>Actions</h3>
            <button onclick="refreshData()">Refresh Data</button>
            <button onclick="exportData()">Export</button>
        </div>
    </div>

    <script>
        // Simple state management
        let data = {
            metric1: null,
            metric2: null,
            lastUpdated: null
        };

        // Fetch data from API or generate sample data
        async function fetchData() {
            try {
                // Example: Replace with your actual API calls
                // const response = await fetch('/api/data');
                // const apiData = await response.json();
                
                // Sample data for demo
                return {
                    metric1: Math.floor(Math.random() * 1000),
                    metric2: Math.floor(Math.random() * 100),
                    lastUpdated: new Date().toLocaleTimeString()
                };
            } catch (error) {
                console.error('Error fetching data:', error);
                throw error;
            }
        }

        // Update dashboard display
        function updateDisplay() {
            const metric1El = document.getElementById('metric1');
            const metric2El = document.getElementById('metric2');
            const desc1El = document.getElementById('description1');
            const desc2El = document.getElementById('description2');

            if (data.metric1 !== null) {
                metric1El.textContent = data.metric1;
                metric1El.className = 'metric';
                desc1El.textContent = `Last updated: ${data.lastUpdated}`;
            }

            if (data.metric2 !== null) {
                metric2El.textContent = data.metric2 + '%';
                metric2El.className = 'metric';
                desc2El.textContent = `Last updated: ${data.lastUpdated}`;
            }
        }

        // Refresh data
        async function refreshData() {
            try {
                const newData = await fetchData();
                data = { ...data, ...newData };
                updateDisplay();
            } catch (error) {
                document.getElementById('metric1').innerHTML = '<span class="error">Error loading data</span>';
                document.getElementById('metric2').innerHTML = '<span class="error">Error loading data</span>';
            }
        }

        // Export data (simple implementation)
        function exportData() {
            const exportData = {
                data: data,
                exportedAt: new Date().toISOString()
            };
            
            const blob = new Blob([JSON.stringify(exportData, null, 2)], 
                                { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            
            const a = document.createElement('a');
            a.href = url;
            a.download = 'dashboard-data.json';
            a.click();
            
            URL.revokeObjectURL(url);
        }

        // Initialize dashboard
        document.addEventListener('DOMContentLoaded', function() {
            refreshData();
            
            // Auto-refresh every 5 minutes
            setInterval(refreshData, 5 * 60 * 1000);
        });
    </script>
</body>
</html>
```

## Usage Notes

**Perfect for:**
- Personal dashboards
- Simple data visualization
- Learning basic web development
- Quick internal tools

**Features included:**
- Responsive design
- Auto-refresh
- Error handling
- Export functionality
- Clean, modern styling

**To customize:**
- Replace `fetchData()` with your API calls
- Modify cards for your specific metrics
- Add more visualizations as needed
- Style to match your preferences

**No build process required - just open in browser!**