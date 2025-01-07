<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import autotheftMonthlyComparison from './data/autotheft_monthly_comparison.json';
    import autotheftYearlyIncidentCounts from './data/autotheft_yearly_incident_counts.json';
    import autotheftYTDComparison from './data/autotheft_ytd_comparison.json';
    import autotheftPrecincts from './data/autotheft_precinct.json';
  
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
      const years = [...new Set(autotheftPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];
  
      autotheftPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: autotheftMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Auto Thefts', data: autotheftMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: autotheftYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Auto Thefts', data: autotheftYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 0 }] };
      const aytdChartData = { labels: autotheftYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Auto Thefts', data: autotheftYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 0)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('amonthlyChart').getContext('2d'), amonthlyChartData, 'autothefts', 'line');
      ayearlyChart = createChart(document.getElementById('ayearlyChart').getContext('2d'), ayearlyChartData, 'autothefts');
      aytdChart = createChart(document.getElementById('aytdChart').getContext('2d'), aytdChartData, 'autothefts');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('aprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct Auto Thefts', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Motor Vehicle Theft</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>

  <div class="def"><p>Auto theft is the stealing of motorized vehicles that run on land (not water or rails). It's separate from carjacking.</p></div>

  <div class="disclaimer"><p>The historic spike in Minneapolis auto thefts is largely driven by Kia and Hyundai thefts in the city.</p></div>
  
  {#if autotheftYTDComparison && autotheftYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{formatNumber(autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDCount)}</strong> auto thefts this year, a
    <span class={autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{formatNumber(autotheftYTDComparison[autotheftYTDComparison.length - 1].PrevYTDCount)}</strong> auto thefts at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{formatNumber(autotheftYTDComparison[0].YTDCount)}</strong> auto thefts, the change is
    <span class={
      (autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDCount - autotheftYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDCount === 'number' && typeof autotheftYTDComparison[0].YTDCount === 'number' ?
          (((autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDCount - autotheftYTDComparison[0].YTDCount) / autotheftYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDCount - autotheftYTDComparison[0].YTDCount) / autotheftYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((autotheftYTDComparison[autotheftYTDComparison.length - 1].YTDCount - autotheftYTDComparison[0].YTDCount) / autotheftYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date auto theft trend</h4>
  <div class="chart-container">
    <canvas id="aytdChart"></canvas>
  </div>
  <div class="download"><a href="../store/autotheft/autotheft_ytd_comparison.csv">Download Minneapolis auto thefts year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly auto thefts trend</h4>
  <div class="chart-container">
    <canvas id="amonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/autotheft/autotheft_monthly_comparison.csv">Download Minneapolis auto thefts by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly auto thefts trend</h4>
  <div class="chart-container">
    <canvas id="ayearlyChart"></canvas>
  </div>
  <div class="download"><a href="../store/autotheft/autotheft_yearly_incident_counts.csv">Download Minneapolis auto thefts by year data</a></div>
  <div class="download"><a href="../store/autotheft/autotheft_historical.csv">Download historical Minneapolis SRS auto thefts data 1985-2022 (includes clearances)</a></div>
  
  
  <p>&nbsp;</p>
  <h4>Auto thefts by police precinct</h4>
  <div class="chart-container">
    <canvas id="aprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../store/autotheft/autotheft_precinct.csv">Download Minneapolis auto thefts by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Auto thefts by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../store/autotheft/autotheft_map_2019.svg', '../store/autotheft/autotheft_map_2020.svg', '../store/autotheft/autotheft_map_2021.svg', '../store/autotheft/autotheft_map_2022.svg', '../store/autotheft/autotheft_map_2023.svg', '../store/autotheft/autotheft_map_2024.svg', '../store/autotheft/autotheft_map_2025.svg'] as image}
      <img src={image} alt={`autotheft Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../store/autotheft/autotheft_geo.csv">Download Minneapolis auto thefts by neighborhood data</a></div>
  <div class="download"><a href="../store/autotheft/autotheft_neighborhoods.geojson">Download Minneapolis auto thefts by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../store/autotheft/autotheft_raw.csv">Download Minneapolis auto thefts raw CSV file (includes incident coordinates)</a></div>
  
  <h4>Links</h4>
  <ul>
    <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  </ul>
  
  <style>
  
  </style>