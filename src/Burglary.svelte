<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import burglaryMonthlyComparison from './data/burglary_monthly_comparison.json';
    import burglaryYearlyIncidentCounts from './data/burglary_yearly_incident_counts.json';
    import burglaryYTDComparison from './data/burglary_ytd_comparison.json';
    import burglaryPrecincts from './data/burglary_precinct.json';
  
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

    function formatNumber(number) {
        return number.toLocaleString('en-US');
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
      const years = [...new Set(burglaryPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];
  
      burglaryPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: burglaryMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Burglaries', data: burglaryMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: burglaryYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Burglaries', data: burglaryYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 0 }] };
      const aytdChartData = { labels: burglaryYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Burglaries', data: burglaryYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'burglaries', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'burglaries');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'burglaries');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct Burglaries', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Burglary</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>

  <div class="def"><p>Burglaries involve illegal breaking and entering into a building with the intent to commit a crime, especially theft.</p></div>
  
  {#if burglaryYTDComparison && burglaryYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{formatNumber(burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDCount)}</strong> burglaries this year, a
    <span class={burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{formatNumber(burglaryYTDComparison[burglaryYTDComparison.length - 1].PrevYTDCount)}</strong> burglaries at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{formatNumber(burglaryYTDComparison[0].YTDCount)}</strong> burglaries, the change is
    <span class={
      (burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDCount - burglaryYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDCount === 'number' && typeof burglaryYTDComparison[0].YTDCount === 'number' ?
          (((burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDCount - burglaryYTDComparison[0].YTDCount) / burglaryYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDCount - burglaryYTDComparison[0].YTDCount) / burglaryYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((burglaryYTDComparison[burglaryYTDComparison.length - 1].YTDCount - burglaryYTDComparison[0].YTDCount) / burglaryYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date burglary trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="../store/burglary/burglary_ytd_comparison.csv">Download Minneapolis burglaries year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly burglary trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/burglary/burglary_monthly_comparison.csv">Download Minneapolis burglaries by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly burglary trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/burglary/burglary_yearly_incident_counts.csv">Download Minneapolis burglaries by year data</a></div>
  <div class="download"><a href="../store/burglary/burglary_historical.csv">Download historical Minneapolis SRS burglaries data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Burglaries by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/burglary/burglary_precinct.csv">Download Minneapolis burglaries by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Burglaries by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../store/burglary/burglary_map_2019.svg', '../store/burglary/burglary_map_2020.svg', '../store/burglary/burglary_map_2021.svg', '../store/burglary/burglary_map_2022.svg', '../store/burglary/burglary_map_2023.svg', '../store/burglary/burglary_map_2024.svg'] as image}
      <img src={image} alt={`burglary Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/burglary/burglary_geo.csv">Download Minneapolis burglaries by neighborhood data</a></div>
  <div class="download"><a href="../store/burglary/burglary_neighborhoods.geojson">Download Minneapolis burglaries by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/burglary/burglary_raw.csv">Download Minneapolis burglaries raw CSV file (includes incident coordinates)</a></div>
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  </ul>
  
  <style>
  
  </style>