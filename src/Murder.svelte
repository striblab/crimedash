<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

  import Chart from 'chart.js/auto';

  import murderMonthlyComparison from './data/murder_monthly_comparison.json';
  import murderYearlyIncidentCounts from './data/murder_yearly_incident_counts.json';
  import murderYTDComparison from './data/murder_ytd_comparison.json';
  import murderHistory from '../public/murder/murderHistory.json';
  import murderPrecincts from './data/murder_precinct.json';

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

    murderPrecincts.forEach(item => {
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
    const monthlyChartData = { labels: murderMonthlyComparison.map(item => `${item.Year}-${item.Month}`), datasets: [{ label: 'Monthly Murders', data: murderMonthlyComparison.map(item => item.IncidentCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
    const yearlyChartData = { labels: murderYearlyIncidentCounts.map(item => item.Year.toString()), datasets: [{ label: 'Yearly Murders', data: murderYearlyIncidentCounts.map(item => item.OffenseCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
    const ytdChartData = { labels: murderYTDComparison.map(item => item.Year.toString()), datasets: [{ label: 'YTD Murders', data: murderYTDComparison.map(item => item.YTDCount), backgroundColor: 'rgba(70, 130, 180, 0.8)', borderColor: 'rgba(70, 130, 180, 0.8)', borderWidth: 1 }] };
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


<h3>Minneapolis: Homicide</h3>

<p class="disclaimer">The Star Tribune uses a speciaized calculation for its historical Minneapolis homicide rates that includes murder cases investigated by MPD, officer-involved deaths and self-defense killings. The following data is just murders investigated by MPD unless otherwise noted.</p>

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
<div class="download"><a href="public/murder/murder_ytd_comparison.csv">Download Minneapolis murders year-to-date data</a></div> 

<p>&nbsp;</p>
<h4>Monthly monthly trend</h4>
<div class="chart-container">
  <canvas id="monthlyChart"></canvas>
</div>
<div class="download"><a href="public/murder/murder_monthly_comparison.csv">Download Minneapolis murders by month data</a></div>

<p>&nbsp;</p>
<h4>Yearly murder trend</h4>
<div class="chart-container">
  <canvas id="yearlyChart"></canvas>
</div>
<div class="download"><a href="public/murder/murder_yearly_incident_counts.csv">Download Minneapolis murders by year data</a></div>

<p>&nbsp;</p>
<h4>Historical homicide rates per 10,000 residents</h4>
<div class="chart-container">
  <canvas id="historyChart"></canvas>
</div>
<div class="download"><a href="public/murder/murder_historical.csv">Download historical Minneapolis homicide data 1985-2022 (includes clearances)</a></div>
<div class="download"><a href="https://docs.google.com/spreadsheets/d/1ntBqZokbzsPQEatu-rlHsIYKq2ngM0hoO1xXmRBQ8jc/edit#gid=1736309950">Star Tribune: Minneapolis Homicides Database</a></div>


<p>&nbsp;</p>
<h4>Murders by police precinct</h4>
<div class="chart-container">
  <canvas id="precinctChart"></canvas>
</div>
<div class="download"><a href="public/murder/murder_precinct.csv">Download Minneapolis murders by police precinct data</a></div>

<p>&nbsp;</p>
<h4>Murders by neighborhood</h4>
<p>Click a map to expand.</p>
<div class="map-container">
  {#each ['public/murder/murder_map_2019.svg', 'public/murder/murder_map_2020.svg', 'public/murder/murder_map_2021.svg', 'public/murder/murder_map_2022.svg', 'public/murder/murder_map_2023.svg', 'public/murder/murder_map_2024.svg'] as image}
    <img src={image} alt={`Murder Map ${image.slice(-8, -4)}`} on:click={() => openLightbox(image)}>
  {/each}
</div>

{#if $activeImage}
  <div class="lightbox" on:click={closeLightbox}>
    <img src={$activeImage} alt="Expanded Image">
  </div>
{/if}
<div class="download"><a href="public/murder/murder_geo.csv">Download Minneapolis murders by neighborhood data</a></div>
<div class="download"><a href="public/murder/murder_neighborhoods.geojson">Download Minneapolis murders by neighborhood GEOJSON</a></div>
<div class="download"><a href="public/murder/murder_raw.csv">Download Minneapolis murders raw CSV file (includes incident coordinates)</a></div>

<p>&nbsp;</p>
<h4>Links</h4>
<ul>
  <li><a href="https://docs.google.com/spreadsheets/d/1ntBqZokbzsPQEatu-rlHsIYKq2ngM0hoO1xXmRBQ8jc/edit#gid=1736309950">Star Tribune: Minneapolis Homicides Database</a></li>
  <li><a href="http://www.murderdata.org/">Murder Accountability Project</a></li>
</ul>


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