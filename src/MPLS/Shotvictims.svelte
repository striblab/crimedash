<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    import Chart from 'chart.js/auto';
  
    import shotvictimsMonthlyComparison from '../data/shotvictims_monthly_comparison.json';
    import shotvictimsYearlyIncidentCounts from '../data/shotvictims_yearly_incident_counts.json';
    import shotvictimsYTDComparison from '../data/shotvictims_ytd_comparison.json';
    import shotvictimsPrecincts from '../data/shotvictims_precinct.json';
  
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
      const years = [...new Set(shotvictimsPrecincts.map(item => item.Year))].sort();
      const precinctMap = new Map();
      const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];

  
      shotvictimsPrecincts.forEach(item => {
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
      const amonthlyChartData = { labels: shotvictimsMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Gunshot Victims', data: shotvictimsMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 1)', borderWidth: 1 }] };
      const ayearlyChartData = { labels: shotvictimsYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Gunshot Victims', data: shotvictimsYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0)', borderWidth: 0 }] };
      const aytdChartData = { labels: shotvictimsYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Gunshot Victims', data: shotvictimsYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180 0)', borderWidth: 0 }] };
  
      // Create charts
      amonthlyChart = createChart(document.getElementById('vmonthlyChart').getContext('2d'), amonthlyChartData, 'Gunshot Victims', 'line');
      ayearlyChart = createChart(document.getElementById('vyearlyChart').getContext('2d'), ayearlyChartData, 'Gunshot Victims');
      aytdChart = createChart(document.getElementById('vytdChart').getContext('2d'), aytdChartData, 'Gunshot Victims');
      const aprecinctChartData = preparePrecinctChartData();
      aprecinctChart = createChart(document.getElementById('vprecinctChart').getContext('2d'), aprecinctChartData, 'Precinct Gunshot Victims', 'line');
    });
  </script>
  
  
  <h3>Minneapolis: Shooting Victims</h3>

  <h4 class="source">Data sources: Minneapolis Police Department</h4>
  
  <div class="def"><p>Counts both fatal and nonfatal gunshot victims.</p></div>

  <div class="disclaimer"><p>Canonical shooting victim data is hard to pindown. Cities, states, feds and private orgs all have similar-yet-differing numbers of fatal and nonfatal shootings. Choose a source and stick with it. Accuracy is vital, precision is impossible.</p></div>
  
  {#if shotvictimsYTDComparison && shotvictimsYTDComparison.length > 0}
  <p>
    Minneapolis has recorded <strong>{shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDCount}</strong> shooting victims this year, a
    <span class={shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
          (shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
          : 'N/A'}
      </strong>
    </span> change from last year's <strong>{shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].PrevYTDCount}</strong> shooting victims at this time.
  </p>
  <p>
    Compared to 2019's count of <strong>{shotvictimsYTDComparison[0].YTDCount}</strong> shooting victims, the change is
    <span class={
      (shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDCount - shotvictimsYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
      <strong>
        {typeof shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDCount === 'number' && typeof shotvictimsYTDComparison[0].YTDCount === 'number' ?
          (((shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDCount - shotvictimsYTDComparison[0].YTDCount) / shotvictimsYTDComparison[0].YTDCount * 100) > 0 ?
          `+${((shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDCount - shotvictimsYTDComparison[0].YTDCount) / shotvictimsYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
          `${((shotvictimsYTDComparison[shotvictimsYTDComparison.length - 1].YTDCount - shotvictimsYTDComparison[0].YTDCount) / shotvictimsYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
          : 'N/A'}
      </strong>
    </span>.
  </p>
  {/if}
  
  <h4>Year-to-date shooting victims trend</h4>
  <div class="chart-container">
    <canvas id="vytdChart"></canvas>
  </div>
  <div class="download"><a href="../../store/shotvictims/shotvictims_ytd_comparison.csv">Download Minneapolis shooting victims year-to-date data</a></div> 
  
  <p>&nbsp;</p>
  <h4>Monthly shooting victims trend</h4>
  <div class="chart-container">
    <canvas id="vmonthlyChart"></canvas>
  </div>
  <div class="download"><a href="../../store/shotvictims/shotvictims_monthly_comparison.csv">Download Minneapolis shooting victims by month data</a></div>
  
  <p>&nbsp;</p>
  <h4>Yearly shooting victims trend</h4>
  <div class="chart-container">
    <canvas id="vyearlyChart"></canvas>
  </div>
  <div class="download"><a href="../../store/shotvictims/mpls_victims.csv">Download historical Minneapolis shooting victims data, 2008-present</a></div>
  <div class="download"><a href="../../store/shotvictims/gva_mn.zip">Download Gun Violence Archive Minnesota shooting victims data, 2014-2023</a></div>
  
  <p>&nbsp;</p>
  <h4>Shooting victims by police precinct</h4>
  <div class="chart-container">
    <canvas id="vprecinctChart"></canvas>
  </div>
  <div class="download"><a href="../../store/shotvictims/shotvictims_precinct.csv">Download Minneapolis shooting victims by police precinct data</a></div>
  
  <p>&nbsp;</p>
  <h4>Shooting victims by neighborhood</h4>
  <p>Click a map to expand.</p>
  <div class="map-container">
    {#each ['../../store/shotvictims/shotvictims_map_2019.svg', '../../store/shotvictims/shotvictims_map_2020.svg', '../../store/shotvictims/shotvictims_map_2021.svg', '../../store/shotvictims/shotvictims_map_2022.svg', '../../store/shotvictims/shotvictims_map_2023.svg', '../../store/shotvictims/shotvictims_map_2024.svg', '../../store/shotvictims/shotvictims_map_2025.svg'] as image}
      <img src={image} alt={`shotvictims Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
    {/each}
  </div>
  
  {#if $activeImage}
    <div class="lightbox" on:click={closeLightbox}>
      <img src={$activeImage} alt="Expanded Image">
    </div>
  {/if}
  <div class="download"><a href="../../store/shotvictims/shotvictims_geo.csv">Download Minneapolis shooting victims by neighborhood data</a></div>
  <div class="download"><a href="../../store/shotvictims/shotvictims_neighborhoods.geojson">Download Minneapolis shooting victims by neighborhood GEOJSON</a></div>
  <div class="download"><a href="../../store/shotvictims/shotvictims_raw.csv">Download Minneapolis shooting victims raw CSV file (includes incident coordinates)</a></div>
  
  <p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
  <li><a href="https://cityoflakes.maps.arcgis.com/apps/webappviewer/index.html?id=292a52a52b354387a94020db10c19749">Minneapolis Gunfire Activity Map</a> | <a href="https://opendata.minneapolismn.gov/datasets/shots-fired/explore?location=44.969425%2C-93.264019%2C12.00">DATA</a></li>
  <li><a href="https://tableau.minneapolismn.gov/views/MStatGunshotData/GunshotWoundDashboard-byDate?:showAppBanner=false&:display_count=n&:showVizHome=n&:origin=viz_share_link&:iid=6&:isGuestRedirectFromVizportal=y&:embed=y">Minneapolis Gunshot Wounds/Shootings</a></li>
  <li><a href="https://www.gunviolencearchive.org/query/4c112967-14d3-41b1-871f-2c0dfa095f9b">Gun Violence Archives</a></li>
  <li><a href="https://www.health.state.mn.us/communities/injury/midas/mnvdrs.html">MNVDRS Dashboard</a></li>

</ul>

  <style>
  
  </style>