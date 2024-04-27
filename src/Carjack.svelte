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
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];
  
      carjackPrecincts.forEach(item => {
        if (!precinctMap.has(item.Precinct)) {
          precinctMap.set(item.Precinct, {
            label: `Precinct ${item.Precinct}`,
            data: new Array(years.length).fill(null), // Initialize with nulls for all years
            borderColor: colors[item.Precinct-1],
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
      const amonthlyChartData = { labels: carjackMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Carjackings', data: carjackMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: carjackYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Carjackings', data: carjackYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 0 }] };
      const aytdChartData = { labels: carjackYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Carjackings', data: carjackYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'carjacking', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'carjacking');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'carjacking');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct Carjackings', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Carjacking</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>

  <div class="def"><p>Carjackings are a subset of robberies where automobiles are stolen by threat of violence, and are different from motor vehicle thefts. Most agencies didn't start tracking carjackings separately from other robberies until 2021.</p></div>
  
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
  <div class="download"><a href="../store/carjack/carjack_ytd_comparison.csv">Download Minneapolis carjackings year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly carjacking trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/carjack/carjack_monthly_comparison.csv">Download Minneapolis carjackings by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly carjacking trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/carjack/carjack_yearly_incident_counts.csv">Download Minneapolis carjackings by year data</a></div>  
  
  <p>&nbsp;</p>
  <h4>Carjackings by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/carjack/carjack_precinct.csv">Download Minneapolis carjackings by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Carjackings by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../store/carjack/carjack_map_2020.svg', '../store/carjack/carjack_map_2021.svg', '../store/carjack/carjack_map_2022.svg', '../store/carjack/carjack_map_2023.svg', '../store/carjack/carjack_map_2024.svg'] as image}
      <img src={image} alt={`carjack Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/carjack/carjack_geo.csv">Download Minneapolis carjackings by neighborhood data</a></div>
  <div class="download"><a href="../store/carjack/carjack_neighborhoods.geojson">Download Minneapolis carjackings by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/carjack/carjack_raw.csv">Download Minneapolis carjackings raw CSV file (includes incident coordinates)</a></div>
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  </ul>
  
  <style>
 
  </style>