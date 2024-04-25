<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import robberyMonthlyComparison from './data/robbery_monthly_comparison.json';
    import robberyYearlyIncidentCounts from './data/robbery_yearly_incident_counts.json';
    import robberyYTDComparison from './data/robbery_ytd_comparison.json';
    import robberyPrecincts from './data/robbery_precinct.json';
  
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
      const years = [...new Set(robberyPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
  
      robberyPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: robberyMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly robberys', data: robberyMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: robberyYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly robberys', data: robberyYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const aytdChartData = { labels: robberyYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD robberys', data: robberyYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 1 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'robberys', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'robberys');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'robberys');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct robberys', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Robbery</h3>
  
  {#if robberyYTDComparison && robberyYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{robberyYTDComparison[robberyYTDComparison.length - 1].YTDCount}</strong> robberies this year, a
    <span class={robberyYTDComparison[robberyYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof robberyYTDComparison[robberyYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (robberyYTDComparison[robberyYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${robberyYTDComparison[robberyYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${robberyYTDComparison[robberyYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{robberyYTDComparison[robberyYTDComparison.length - 1].PrevYTDCount}</strong> robberies at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{robberyYTDComparison[0].YTDCount}</strong> robberies, the change is
    <span class={
      (robberyYTDComparison[robberyYTDComparison.length - 1].YTDCount - robberyYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof robberyYTDComparison[robberyYTDComparison.length - 1].YTDCount === 'number' && typeof robberyYTDComparison[0].YTDCount === 'number' ?
          (((robberyYTDComparison[robberyYTDComparison.length - 1].YTDCount - robberyYTDComparison[0].YTDCount) / robberyYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((robberyYTDComparison[robberyYTDComparison.length - 1].YTDCount - robberyYTDComparison[0].YTDCount) / robberyYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((robberyYTDComparison[robberyYTDComparison.length - 1].YTDCount - robberyYTDComparison[0].YTDCount) / robberyYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date robbery trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="../store/robbery/robbery_ytd_comparison.csv">Download Minneapolis robberies year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly robbery trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/robbery/robbery_monthly_comparison.csv">Download Minneapolis robberies by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly robbery trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/robbery/robbery_yearly_incident_counts.csv">Download Minneapolis robberies by year data</a></div>
  <div class="download"><a href="../store/robbery/robbery_historical.csv">Download historical Minneapolis SRS robberies data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Robberies by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/robbery/robbery_precinct.csv">Download Minneapolis robberies by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Robberies by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['store/robbery/robbery_map_2019.svg', 'store/robbery/robbery_map_2020.svg', 'store/robbery/robbery_map_2021.svg', 'store/robbery/robbery_map_2022.svg', 'store/robbery/robbery_map_2023.svg', 'store/robbery/robbery_map_2024.svg'] as image}
      <img src={image} alt={`robbery Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/robbery/robbery_geo.csv">Download Minneapolis robberies by neighborhood data</a></div>
  <div class="download"><a href="../store/robbery/robbery_neighborhoods.geojson">Download Minneapolis robberies by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/robbery/robbery_raw.csv">Download Minneapolis robberies raw CSV file (includes incident coordinates)</a></div>
  
  
  
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