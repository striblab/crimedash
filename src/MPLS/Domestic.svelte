<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import domesticMonthlyComparison from '../data/domestic_monthly_comparison.json';
    import domesticYearlyIncidentCounts from '../data/domestic_yearly_incident_counts.json';
    import domesticYTDComparison from '../data/domestic_ytd_comparison.json';
    import domesticPrecincts from '../data/domestic_precinct.json';
  
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
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];
  
      domesticPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: domesticMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Domestic Aggravated Assaults', data: domesticMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: domesticYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Domestic Aggravated Assaults', data: domesticYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 0 }] };
      const aytdChartData = { labels: domesticYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Domestic Aggravated Assaults', data: domesticYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'domestics', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'domestics');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'domestics');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct domestics', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Domestic Aggravated Assault</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>

  <div class="def"><p>Domestic Aggravated Assault is a subset of Aggravated Assaults and describes violent incidents that occur between family or household members.</p></div>
  
  {#if domesticYTDComparison && domesticYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{domesticYTDComparison[domesticYTDComparison.length - 1].YTDCount}</strong> domestic aggravated assaults this year, a
    <span class={domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${domesticYTDComparison[domesticYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{domesticYTDComparison[domesticYTDComparison.length - 1].PrevYTDCount}</strong> domestic aggravated assaults at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{domesticYTDComparison[0].YTDCount}</strong> domestic aggravated assaults, the change is
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
  <div class="download"><a href="../../store/domestic/domestic_ytd_comparison.csv">Download Minneapolis aggravated domestic aggravated assaults year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly domestic aggravated assault trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../../store/domestic/domestic_monthly_comparison.csv">Download Minneapolis domestic aggravated assaults by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly domestic aggravated assault trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../../store/domestic/domestic_yearly_incident_counts.csv">Download Minneapolis domestic aggravated assault by year data</a></div>
  <div class="download"><a href="../../store/domestic/domestic_historical.csv">Download historical Minneapolis SRS domestic aggravated assault data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Domestic aggravated assaults by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../../store/domestic/domestic_precinct.csv">Download Minneapolis domestic aggravated assaults by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Domestic aggravated assaults by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../../store/domestic/domestic_map_2019.svg', '../../store/domestic/domestic_map_2020.svg', '../../store/domestic/domestic_map_2021.svg', '../../store/domestic/domestic_map_2022.svg', '../../store/domestic/domestic_map_2023.svg', '../../store/domestic/domestic_map_2024.svg', '../../store/domestic/domestic_map_2025.svg'] as image}
      <img src={image} alt={`domestic Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../../store/domestic/domestic_geo.csv">Download Minneapolis domestic aggravated assaults by neighborhood data</a></div>
  <div class="download"><a href="../../store/domestic/domestic_neighborhoods.geojson">Download Minneapolis domestic aggravated assaults by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../../store/domestic/domestic_raw.csv">Download Minneapolis domestic aggravated assault raw CSV file (includes incident coordinates)</a></div>
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  </ul>
  
  <style>
 
  </style>