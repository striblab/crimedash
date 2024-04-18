<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import drugsMonthlyComparison from './data/drugs_monthly_comparison.json';
    import drugsYearlyIncidentCounts from './data/drugs_yearly_incident_counts.json';
    import drugsYTDComparison from './data/drugs_ytd_comparison.json';
    import drugsPrecincts from './data/drugs_precinct.json';
  
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
      const years = [...new Set(drugsPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
  
      drugsPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: drugsMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly drug offenses', data: drugsMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: drugsYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly drug offenses', data: drugsYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const aytdChartData = { labels: drugsYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD drug offenses', data: drugsYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 1 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'drugss', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'drugss');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'drugss');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct drugss', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Drug Offenses</h3>
  
  {#if drugsYTDComparison && drugsYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{drugsYTDComparison[drugsYTDComparison.length - 1].YTDCount}</strong> drug offenses this year, a
    <span class={drugsYTDComparison[drugsYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof drugsYTDComparison[drugsYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (drugsYTDComparison[drugsYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${drugsYTDComparison[drugsYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${drugsYTDComparison[drugsYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{drugsYTDComparison[drugsYTDComparison.length - 1].PrevYTDCount}</strong> drug offenses at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{drugsYTDComparison[0].YTDCount}</strong> drug offenses, the change is
    <span class={
      (drugsYTDComparison[drugsYTDComparison.length - 1].YTDCount - drugsYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof drugsYTDComparison[drugsYTDComparison.length - 1].YTDCount === 'number' && typeof drugsYTDComparison[0].YTDCount === 'number' ?
          (((drugsYTDComparison[drugsYTDComparison.length - 1].YTDCount - drugsYTDComparison[0].YTDCount) / drugsYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((drugsYTDComparison[drugsYTDComparison.length - 1].YTDCount - drugsYTDComparison[0].YTDCount) / drugsYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((drugsYTDComparison[drugsYTDComparison.length - 1].YTDCount - drugsYTDComparison[0].YTDCount) / drugsYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date drugs trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="public/drugs/drugs_ytd_comparison.csv">Download Minneapolis drugss year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly drug offense trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="public/drugs/drugs_monthly_comparison.csv">Download Minneapolis drug offenses by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly drug offense trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="public/drugs/drugs_yearly_incident_counts.csv">Download Minneapolis  drug offense by year data</a></div>
  
  <p>&nbsp;</p>
  <h4>Drug offenses by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="public/drugs/drugs_precinct.csv">Download Minneapolis drugs by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Drug offenses by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['public/drugs/drugs_map_2019.svg', 'public/drugs/drugs_map_2020.svg', 'public/drugs/drugs_map_2021.svg', 'public/drugs/drugs_map_2022.svg', 'public/drugs/drugs_map_2023.svg', 'public/drugs/drugs_map_2024.svg'] as image}
      <img src={image} alt={`drugs Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="public/drugs/drugs_geo.csv">Download Minneapolis drug offenses by neighborhood data</a></div>
  <div class="download"><a href="public/drugs/drugs_neighborhoods.geojson">Download Minneapolis drug offenses by neighborhood GEOJSON</a></div>
  <div class="download"><a href="public/drugs/drugs_raw.csv">Download Minneapolis drug offenses raw CSV file (includes incident coordinates)</a></div>
  
  
  
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