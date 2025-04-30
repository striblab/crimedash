<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

  import Chart from 'chart.js/auto';

  import murderMonthlyComparison from '../data/murder_monthly_comparison.json';
  import murderYearlyIncidentCounts from '../data/murder_yearly_incident_counts.json';
  import murderYTDComparison from '../data/murder_ytd_comparison.json';
  import murderHistory from '../../store/murder/murderHistory.json';
  import murderPrecincts from '../data/murder_precinct.json';

  // Store to track the active image for the lightbox
  let activeImage = writable(null);

  function openLightbox(image) {
    activeImage.set(image);
  }

  function closeLightbox() {
    activeImage.set(null);
  }

  let monthlyChart, yearlyChart, ytdChart, precinctChart, historyChart;
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
      monthlyChart.resize();
      yearlyChart.resize();
      ytdChart.resize();
      historyChart.resize();
      precinctChart.resize();
    }, 250);
  }

  function preparePrecinctChartData() {
    const years = [...new Set(murderPrecincts.map(item => item.Year))].sort();
    const precinctMap = new Map();
    const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
    '#C9CBCF', '#7E57C2', '#D4E157', '#66BB6A', '#FF7043', '#8D6E63'];

    murderPrecincts.forEach(item => {
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
    const monthlyChartData = { labels: murderMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Murders', data: murderMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
    const yearlyChartData = { labels: murderYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Murders', data: murderYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0 }] };
    const ytdChartData = { labels: murderYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Murders', data: murderYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 0}] };
    const historyChartData = { labels: murderHistory.map(item => item.year.toString()), datasets: [{ label: 'Homicide Rate', data: murderHistory.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
    
    // Create charts
    monthlyChart = createChart(document.getElementById('monthlyChart').getContext('2d'), monthlyChartData, 'Murders', 'line');
    yearlyChart = createChart(document.getElementById('yearlyChart').getContext('2d'), yearlyChartData, 'Murders');
    ytdChart = createChart(document.getElementById('ytdChart').getContext('2d'), ytdChartData, 'Murders');
    historyChart = createChart(document.getElementById('historyChart').getContext('2d'), historyChartData, 'Murders');
    const precinctChartData = preparePrecinctChartData();
    precinctChart = createChart(document.getElementById('precinctChart').getContext('2d'), precinctChartData, 'Precinct Murders', 'line');
  });
</script>


<h3>Minneapolis: Murder</h3>

<h4 class="source">Data sources: Minneapolis Police Department</h4>

<div class="def">
  <p>The following data reflects murders investigated by MPD.</p>
  <p>For crime trend stories, the Star Tribune uses a speciaized calculation for its historical Minneapolis homicide rates that combines murder cases investigated by MPD, officer-involved deaths and self-defense killings.</p></div>

{#if murderYTDComparison && murderYTDComparison.length > 0}
<p>
  Minneapolis has recorded <strong>{murderYTDComparison[murderYTDComparison.length - 1].YTDCount}</strong> murders this year, a
  <span class={murderYTDComparison[murderYTDComparison.length - 1].YTDPercentageChange >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof murderYTDComparison[murderYTDComparison.length - 1].YTDPercentageChange === 'number' ? 
        (murderYTDComparison[murderYTDComparison.length - 1].YTDPercentageChange > 0 ? `+${murderYTDComparison[murderYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%` : `${murderYTDComparison[murderYTDComparison.length - 1].YTDPercentageChange.toFixed(0)}%`) 
        : 'N/A'}
    </strong>
  </span> change from last year's <strong>{murderYTDComparison[murderYTDComparison.length - 1].PrevYTDCount}</strong> murders at this time.
</p>
<p>
  Compared to 2019's count of <strong>{murderYTDComparison[0].YTDCount}</strong> murders, the change is
  <span class={
    (murderYTDComparison[murderYTDComparison.length - 1].YTDCount - murderYTDComparison[0].YTDCount) >= 0 ? 'positive' : 'negative'}>
    <strong>
      {typeof murderYTDComparison[murderYTDComparison.length - 1].YTDCount === 'number' && typeof murderYTDComparison[0].YTDCount === 'number' ?
        (((murderYTDComparison[murderYTDComparison.length - 1].YTDCount - murderYTDComparison[0].YTDCount) / murderYTDComparison[0].YTDCount * 100) > 0 ?
        `+${((murderYTDComparison[murderYTDComparison.length - 1].YTDCount - murderYTDComparison[0].YTDCount) / murderYTDComparison[0].YTDCount * 100).toFixed(0)}%` :
        `${((murderYTDComparison[murderYTDComparison.length - 1].YTDCount - murderYTDComparison[0].YTDCount) / murderYTDComparison[0].YTDCount * 100).toFixed(0)}%`)
        : 'N/A'}
    </strong>
  </span>.
</p>
{/if}


<h4>Year-to-date murder trend</h4>
<div class="chart-container">
  <canvas id="ytdChart"></canvas>
</div>
<div class="download"><a href="../store/murder/murder_ytd_comparison.csv">Download Minneapolis murders year-to-date data</a></div> 

<p>&nbsp;</p>
<h4>Monthly murder trend</h4>
<div class="chart-container">
  <canvas id="monthlyChart"></canvas>
</div>
<div class="download"><a href="../store/murder/murder_monthly_comparison.csv">Download Minneapolis murders by month data</a></div>

<p>&nbsp;</p>
<h4>Yearly murder trend</h4>
<div class="chart-container">
  <canvas id="yearlyChart"></canvas>
</div>
<div class="download"><a href="../store/murder/murder_yearly_incident_counts.csv">Download Minneapolis murders by year data</a></div>

<p>&nbsp;</p>
<h4>Historical homicide rates per 100,000 residents</h4>
<div class="chart-container">
  <canvas id="historyChart"></canvas>
</div>
<div class="download"><a href="../store/murder/murder_historical.csv">Download historical Minneapolis homicide data 1985-2022 (includes clearances)</a></div>
<div class="download"><a href="https://docs.google.com/spreadsheets/d/1ntBqZokbzsPQEatu-rlHsIYKq2ngM0hoO1xXmRBQ8jc/edit#gid=1736309950">Star Tribune: Minneapolis Homicides Database</a></div>
<div class="download"><a href="../store/murder/MNSHR65_22.csv.zip">Download Minneapolis FBI Supplementary Homicide Report, 1976-2022</a></div>


<p>&nbsp;</p>
<h4>Murders by police precinct</h4>
<div class="chart-container">
  <canvas id="precinctChart"></canvas>
</div>
<div class="download"><a href="../store/murder/murder_precinct.csv">Download Minneapolis murders by police precinct data</a></div>

<p>&nbsp;</p>
<h4>Murders by neighborhood</h4>
<p>Click a map to expand.</p>
<div class="map-container">
  {#each ['../store/murder/murder_map_2019.svg', '../store/murder/murder_map_2020.svg', '../store/murder/murder_map_2021.svg', '../store/murder/murder_map_2022.svg', '../store/murder/murder_map_2023.svg', '../store/murder/murder_map_2024.svg', '../store/murder/murder_map_2025.svg'] as image}
    <img src={image} alt={`Murder Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
  {/each}
</div>

{#if $activeImage}
  <div class="lightbox" on:click={closeLightbox}>
    <img src={$activeImage} alt="Expanded Image">
  </div>
{/if}
<div class="download"><a href="../store/murder/murder_geo.csv">Download Minneapolis murders by neighborhood data</a></div>
<div class="download"><a href="../store/murder/murder_neighborhoods.geojson">Download Minneapolis murders by neighborhood GEOJSON</a></div>
<div class="download"><a href="../store/murder/murder_raw.csv">Download Minneapolis murders raw CSV file (includes incident coordinates)</a></div>

<p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://docs.google.com/spreadsheets/d/1ntBqZokbzsPQEatu-rlHsIYKq2ngM0hoO1xXmRBQ8jc/edit#gid=1736309950">Star Tribune: Minneapolis Homicides Database</a></li>
  <li><a href="http://www.murderdata.org/">Murder Accountability Project</a></li>
  <li><a href="https://tableau.minneapolismn.gov/views/CrimeDashboard/Summary?%3Adisplay_count=n&%3Aiid=5&%3Aorigin=viz_share_link&%3AshowAppBanner=false&%3AshowVizHome=n&%3Atabs=yes&%3Atoolbar=no&%3AisGuestRedirectFromVizportal=y&%3Aembed=y">Minneapolis NIBRS Crime Dashboard</a> | <a href="https://opendata.minneapolismn.gov/datasets/cityoflakes::crime-data/about">raw data</a></li>
</ul>


<style>

</style>