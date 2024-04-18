<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import carjackMonthlyComparison from './data/carjack_monthly_comparison.json';
    import carjackYearlyIncidentCounts from './data/carjack_yearly_incident_counts.json';
    import carjackYTDComparison from './data/carjack_ytd_comparison.json';
    import carjackPrecincts from './data/carjack_precinct.json';
  
    // Store to track the active image for the lightbox
    let activeImage = writable(null);
  
    function openLightbox(image) {
      activeImage.set(image);
    }
  
    function closeLightbox() {
      activeImage.set(null);
    }
  
    let amonthlyChart, ayearlyChart, aytdChart, aprecinctChart;
    let resizeTimer;
  
    function createChart(ctx, chartData, title, type = 'bar') {
      return new Chart(ctx, {
        type: type,
        data: {
          labels: chartData.labels,
          datasets: chartData.datasets
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      });
    }
  
    function handleResize() {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(() => {
        amonthlyChart.resize();
        ayearlyChart.resize();
        aytdChart.resize();
        aprecinctChart.resize();
      }, 250);
    }
  
    function preparePrecinctChartData() {
      const years = [...new Set(carjackPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
  
      carjackPrecincts.forEach(item => {
        if (!precinctMap.has(item.Precinct)) {
          precinctMap.set(item.Precinct, {
            label: `Precinct ${item.Precinct}`,
            data: new Array(years.length).fill(null), // Initialize with nulls for all years
            borderColor: `hsl(${Math.random() * 360}, 70%, 50%)`,
            fill: false
          });
        }
        const precinct = precinctMap.get(item.Precinct);
        const index = years.indexOf(item.Year);
        precinct.data[index] = item.OffenseCount; // Place the count in the corresponding year position
      });
  
      return {
        labels: years,
        datasets: Array.from(precinctMap.values())
      };
    }
  
    onMount(() => {
      window.addEventListener('resize', handleResize);
  
      // Prepare chart data
      const amonthlyChartData = { labels: carjackMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly carjacking', data: carjackMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: carjackYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly carjacking', data: carjackYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const aytdChartData = { labels: carjackYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD carjacking', data: carjackYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 1 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'carjacking', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'carjacking');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'carjacking');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct carjacking', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Carjacking</h3>
  
  {#if carjackYTDComparison && carjackYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{carjackYTDComparison[carjackYTDComparison.length - 1].YTDCount}</strong> carjackings this year, a
    <span class={carjackYTDComparison[carjackYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof carjackYTDComparison[carjackYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (carjackYTDComparison[carjackYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${carjackYTDComparison[carjackYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${carjackYTDComparison[carjackYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{carjackYTDComparison[carjackYTDComparison.length - 1].PrevYTDCount}</strong> carjackings at this time.
  </p>
  {/if}
  
  <h4>Year-to-date carjacking trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="public/carjack/carjack_ytd_comparison.csv">Download Minneapolis carjacks year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly carjacking trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="public/carjack/carjack_monthly_comparison.csv">Download Minneapolis carjacks by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly carjacking trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="public/carjack/carjack_yearly_incident_counts.csv">Download Minneapolis carjacks by year data</a></div>  
  
  <p>&nbsp;</p>
  <h4>Carjacking by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="public/carjack/carjack_precinct.csv">Download Minneapolis carjacks by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Carjacking by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['public/carjack/carjack_map_2020.svg', 'public/carjack/carjack_map_2021.svg', 'public/carjack/carjack_map_2022.svg', 'public/carjack/carjack_map_2023.svg', 'public/carjack/carjack_map_2024.svg'] as image}
      <img src={image} alt={`carjack Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="public/carjack/carjack_geo.csv">Download Minneapolis carjacks by neighborhood data</a></div>
  <div class="download"><a href="public/carjack/carjack_neighborhoods.geojson">Download Minneapolis carjacks by neighborhood GEOJSON</a></div>
  <div class="download"><a href="public/carjack/carjack_raw.csv">Download Minneapolis carjacks raw CSV file (includes incident coordinates)</a></div>
  
  
  
  <style>
    .chart-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-around;
      padding: 20px;
    }
    canvas {
      max-width: 100%;
      height: 300px !important;
    }
    .positive {
    color: red;
    }
    .negative {
      color: green;
    }
    .map-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-around;
      gap: 20px;
    }
  
    img {
      width: 200px;
      height: auto;
      cursor: pointer;
      transition: transform 0.2s;
      border:1px solid #dddddd;
    }
  
    img:hover {
      transform: scale(1.05);
    }
  
    .lightbox {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background-color: white;
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
  
    .lightbox img {
      max-width: 90%; 
      max-height: 90%;
      height: auto;
      width: auto;
    }
  </style>