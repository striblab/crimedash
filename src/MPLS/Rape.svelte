<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import rapeMonthlyComparison from '../data/rape_monthly_comparison.json';
    import rapeYearlyIncidentCounts from '../data/rape_yearly_incident_counts.json';
    import rapeYTDComparison from '../data/rape_ytd_comparison.json';
    import rapePrecincts from '../data/rape_precinct.json';
  
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
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];

  
      rapePrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: rapeMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Sex Offenses', data: rapeMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: rapeYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Sex Offenses', data: rapeYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 0 }] };
      const aytdChartData = { labels: rapeYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Sex Offenses', data: rapeYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 1)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'Sex Offenses', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'Sex Offenses');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'Sex Offenses');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct Sex Offenses', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Sex Offenses</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>

  <div class="def"><p>Under NIBRS in Minneapolis, sex offenses include forcible rape, sexual assault, nonconsensual sodomy, fondling and statutory rape. This metric is yet another revision to how rape statistics are calculated, so exercise additional caution when measuring trends over time.</p></div>
  
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
    {#each ['../store/rape/rape_map_2019.svg', '../store/rape/rape_map_2020.svg', '../store/rape/rape_map_2021.svg', '../store/rape/rape_map_2022.svg', '../store/rape/rape_map_2023.svg', '../store/rape/rape_map_2024.svg', '../store/rape/rape_map_2024.svg'] as image}
      <img src={image} alt={`rape Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/rape/rape_geo.csv">Download Minneapolis sex offenses by neighborhood data</a></div>
  <div class="download"><a href="../store/rape/rape_neighborhoods.geojson">Download Minneapolis sex offenses by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/rape/rape_raw.csv">Download Minneapolis sex offenses raw CSV file (includes incident coordinates)</a></div>
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  </ul>
  
  <style>
  
  </style>