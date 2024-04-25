<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import rapeMonthlyComparison from './data/rape_monthly_comparison.json';
    import rapeYearlyIncidentCounts from './data/rape_yearly_incident_counts.json';
    import rapeYTDComparison from './data/rape_ytd_comparison.json';
    import rapePrecincts from './data/rape_precinct.json';
  
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
      const years = [...new Set(rapePrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
  
      rapePrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: rapeMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly sex offenses', data: rapeMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: rapeYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly sex offenses', data: rapeYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const aytdChartData = { labels: rapeYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD sex offenses', data: rapeYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 1 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'Sex Offenses', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'Sex Offenses');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'Sex Offenses');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct sex offenses', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Sex Offenses</h3>

  <p class="disclaimer">Under NIBRS in Minneapolis, sex offenses include rape, sexual assault and nonconsensual sodomy, fondling, etc. This metric is yet another revision to how rape statistics are calculated, so exercise additional caution when measuring trends over time.</p>
  
  {#if rapeYTDComparison && rapeYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{rapeYTDComparison[rapeYTDComparison.length - 1].YTDCount}</strong> sex offenses this year, a
    <span class={rapeYTDComparison[rapeYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof rapeYTDComparison[rapeYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (rapeYTDComparison[rapeYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${rapeYTDComparison[rapeYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${rapeYTDComparison[rapeYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{rapeYTDComparison[rapeYTDComparison.length - 1].PrevYTDCount}</strong> sex offenses at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{rapeYTDComparison[0].YTDCount}</strong> sex offenses, the change is
    <span class={
      (rapeYTDComparison[rapeYTDComparison.length - 1].YTDCount - rapeYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof rapeYTDComparison[rapeYTDComparison.length - 1].YTDCount === 'number' && typeof rapeYTDComparison[0].YTDCount === 'number' ?
          (((rapeYTDComparison[rapeYTDComparison.length - 1].YTDCount - rapeYTDComparison[0].YTDCount) / rapeYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((rapeYTDComparison[rapeYTDComparison.length - 1].YTDCount - rapeYTDComparison[0].YTDCount) / rapeYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((rapeYTDComparison[rapeYTDComparison.length - 1].YTDCount - rapeYTDComparison[0].YTDCount) / rapeYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date sex offense trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="../store/rape/rape_ytd_comparison.csv">Download Minneapolis rapes year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly sex offense trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/rape/rape_monthly_comparison.csv">Download Minneapolis rapes by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly sex offense trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/rape/rape_yearly_incident_counts.csv">Download Minneapolis rapes by year data</a></div>
  <div class="download"><a href="../store/rape/rape_historical.csv">Download historical Minneapolis SRS rapes data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Sex offenses by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/rape/rape_precinct.csv">Download Minneapolis rapes by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Sex offenses by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../store/rape/rape_map_2019.svg', '../store/rape/rape_map_2020.svg', '../store/rape/rape_map_2021.svg', '../store/rape/rape_map_2022.svg', '../store/rape/rape_map_2023.svg', '../store/rape/rape_map_2024.svg'] as image}
      <img src={image} alt={`rape Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/rape/rape_geo.csv">Download Minneapolis rapes by neighborhood data</a></div>
  <div class="download"><a href="../store/rape/rape_neighborhoods.geojson">Download Minneapolis rapes by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/rape/rape_raw.csv">Download Minneapolis rapes raw CSV file (includes incident coordinates)</a></div>
  
  
  
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
    .disclaimer {
      color:#de2d26;
     }
  </style>