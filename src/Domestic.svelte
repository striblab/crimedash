<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import domesticMonthlyComparison from './data/domestic_monthly_comparison.json';
    import domesticYearlyIncidentCounts from './data/domestic_yearly_incident_counts.json';
    import domesticYTDComparison from './data/domestic_ytd_comparison.json';
    import domesticPrecincts from './data/domestic_precinct.json';
  
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
      const years = [...new Set(domesticPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
  
      domesticPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: domesticMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly domestics', data: domesticMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: domesticYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly domestics', data: domesticYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const aytdChartData = { labels: domesticYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD domestics', data: domesticYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 1 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'domestics', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'domestics');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'domestics');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct domestics', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Domestic Assault</h3>

  <div class="disclaimer"><p>Domestic Aggravated Assault is a subset of Aggravated Assaults.</p></div>
  
  {#if domesticYTDComparison && domesticYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount}</strong> domestics this year, a
    <span class={domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{domesticYTDComparison[domesticYTDComparison.length - 1].PrevYTDCount}</strong> domestics at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{domesticYTDComparison[0].YTDCount}</strong> domestics, the change is
    <span class={
      (domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount - domesticYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount === 'number' && typeof domesticYTDComparison[0].YTDCount === 'number' ?
          (((domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount - domesticYTDComparison[0].YTDCount) / domesticYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount - domesticYTDComparison[0].YTDCount) / domesticYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount - domesticYTDComparison[0].YTDCount) / domesticYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date aggravated domestic assault trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="../store/domestic/domestic_ytd_comparison.csv">Download Minneapolis aggravated domestic assaults year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly aggravated domestic assault trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/domestic/domestic_monthly_comparison.csv">Download Minneapolis aggravated domestic assaults by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly aggravated domestic assault trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/domestic/domestic_yearly_incident_counts.csv">Download Minneapolis aggravated domestic assaults by year data</a></div>
  <div class="download"><a href="../store/domestic/domestic_historical.csv">Download historical Minneapolis SRS aggravated domestic assaults data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Aggravated domestic assaults by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/domestic/domestic_precinct.csv">Download Minneapolis aggravated domestic assaults by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Aggravated domestic assaults by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../store/domestic/domestic_map_2019.svg', '../store/domestic/domestic_map_2020.svg', '../store/domestic/domestic_map_2021.svg', '../store/domestic/domestic_map_2022.svg', '../store/domestic/domestic_map_2023.svg', '../store/domestic/domestic_map_2024.svg'] as image}
      <img src={image} alt={`domestic Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/domestic/domestic_geo.csv">Download Minneapolis aggravated domestic assaults by neighborhood data</a></div>
  <div class="download"><a href="../store/domestic/domestic_neighborhoods.geojson">Download Minneapolis aggravated domestic assaults by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/domestic/domestic_raw.csv">Download Minneapolis aggravated domestic assaults raw CSV file (includes incident coordinates)</a></div>
  
  
  
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