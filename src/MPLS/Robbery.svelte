<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import robberyMonthlyComparison from '../data/robbery_monthly_comparison.json';
    import robberyYearlyIncidentCounts from '../data/robbery_yearly_incident_counts.json';
    import robberyYTDComparison from '../data/robbery_ytd_comparison.json';
    import robberyPrecincts from '../data/robbery_precinct.json';
  
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
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];

  
      robberyPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: robberyMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Robberies', data: robberyMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: robberyYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Robberies', data: robberyYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 0 }] };
      const aytdChartData = { labels: robberyYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Robberies', data: robberyYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'robberies', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'robberies');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'robberies');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct Robberies', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Robbery</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>

  <div class="def"><p>Robberies are the theft (or attempted theft) of personal property by force or the threat of force.</p></div>
  
  <div class="disclaimer"><p>NIBRS changed robberies from a violent crime to a property crime from 2019 onward, so numbers represent incidents, not victims – be careful with longterm historical comparisons.</p></div>
  
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
  <div class="download"><a href="../../store/robbery/robbery_ytd_comparison.csv">Download Minneapolis robberies year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly robbery trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../../store/robbery/robbery_monthly_comparison.csv">Download Minneapolis robberies by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly robbery trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../../store/robbery/robbery_yearly_incident_counts.csv">Download Minneapolis robberies by year data</a></div>
  <div class="download"><a href="../../store/robbery/robbery_historical.csv">Download historical Minneapolis SRS robberies data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Robberies by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../../store/robbery/robbery_precinct.csv">Download Minneapolis robberies by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Robberies by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../../store/robbery/robbery_map_2019.svg', '../../store/robbery/robbery_map_2020.svg', '../../store/robbery/robbery_map_2021.svg', '../../store/robbery/robbery_map_2022.svg', '../../store/robbery/robbery_map_2023.svg', '../../store/robbery/robbery_map_2024.svg', '../../store/robbery/robbery_map_2025.svg'] as image}
      <img src={image} alt={`robbery Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../../store/robbery/robbery_geo.csv">Download Minneapolis robberies by neighborhood data</a></div>
  <div class="download"><a href="../../store/robbery/robbery_neighborhoods.geojson">Download Minneapolis robberies by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../../store/robbery/robbery_raw.csv">Download Minneapolis robberies raw CSV file (includes incident coordinates)</a></div>
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  </ul>
  
  <style>
  
  </style>